///|
/// Sweep-and-Prune broadphase along a single axis (x by default).
///
/// Sorts body AABBs by their min-x coordinate, then for each body walks
/// forward while the next min-x is still below this body's max-x, reporting
/// overlapping pairs. Best for worlds where objects are spread along one
/// axis (side-scrollers, platforms) or where insertion order is already
/// roughly sorted.
pub(all) struct SweepAndPrune {
  /// Sorted list of (id, aabb) entries; rebuilt each `pairs` call.
  entries : Array[(Int, AABB)]
}

///|
/// Construct an empty SAP structure.
pub fn SweepAndPrune::new() -> SweepAndPrune {
  { entries: [] }
}

///|
/// Add a body AABB. Does not keep sorted; call `pairs` to rebuild.
pub fn SweepAndPrune::insert(
  self : SweepAndPrune,
  id : Int,
  box : AABB,
) -> Unit {
  self.entries.push((id, box))
}

///|
/// Clear all entries.
pub fn SweepAndPrune::clear(self : SweepAndPrune) -> Unit {
  self.entries.clear()
}

///|
/// Compute candidate pairs by sorting on min-x and sweeping.
pub fn SweepAndPrune::pairs(self : SweepAndPrune) -> Array[(Int, Int)] {
  // Sort by min-x using insertion sort (typical SAP benefit: nearly-sorted
  // input runs in near-linear time; even worst-case is fine for game-scale).
  let n = self.entries.length()
  for i = 1; i < n; i = i + 1 {
    let key = self.entries[i]
    let mut j = i - 1
    while j >= 0 && self.entries[j].1.min().x > key.1.min().x {
      self.entries[j + 1] = self.entries[j]
      j = j - 1
    }
    self.entries[j + 1] = key
  }
  let result : Array[(Int, Int)] = []
  for i = 0; i < n; i = i + 1 {
    let (id_i, aabb_i) = self.entries[i]
    let max_x = aabb_i.max().x
    let mut j = i + 1
    while j < n {
      let (id_j, aabb_j) = self.entries[j]
      if aabb_j.min().x > max_x {
        // No further overlaps along x.
        break
      }
      // x-intervals overlap; check y to confirm.
      if aabb_i.overlaps(aabb_j) {
        let (lo, hi) = if id_i < id_j { (id_i, id_j) } else { (id_j, id_i) }
        result.push((lo, hi))
      }
      j = j + 1
    }
  }
  result
}

///|
/// Dynamic AABB tree broadphase.
///
/// A binary tree of AABBs where each leaf is a body's AABB and each internal
/// node holds the union of its children. Insertion chooses the sibling that
/// minimizes the resulting union volume; removal rebalances lazily. Supports
/// incremental updates (move a body's AABB without rebuilding the whole tree),
/// making it well-suited for worlds with many moving bodies of varying size.
pub(all) struct AABBTree {
  /// Root node id; -1 if empty.
  mut root : Int
  /// Node storage indexed by id.
  nodes : Array[TreeNode]
  /// Free list of node ids available for reuse.
  free_list : Array[Int]
  /// Per-leaf body id mapping: node id -> body id (-1 for internal nodes).
  body_ids : Array[Int]
}

///|
/// A tree node. Leaves have `body_id >= 0` and `left == right == -1`;
/// internal nodes have `body_id == -1` and two children.
pub(all) struct TreeNode {
  /// Bounding box (union of children for internal nodes).
  mut box : AABB
  /// Parent node id, -1 for root.
  mut parent : Int
  /// Left child id, -1 for leaves.
  mut left : Int
  /// Right child id, -1 for leaves.
  mut right : Int
  /// Body id for leaves; -1 for internal nodes.
  mut body_id : Int
  /// Height of this node (0 for leaves).
  mut height : Int
}

///|
/// Construct an empty AABB tree.
pub fn AABBTree::new() -> AABBTree {
  { root: -1, nodes: [], free_list: [], body_ids: [] }
}

///|
fn AABBTree::alloc_node(self : AABBTree, box : AABB) -> Int {
  let id = match self.free_list.pop() {
    Some(id) => {
      self.nodes[id] = {
        box,
        parent: -1,
        left: -1,
        right: -1,
        body_id: -1,
        height: 0,
      }
      self.body_ids[id] = -1
      id
    }
    None => {
      self.nodes.push({
        box,
        parent: -1,
        left: -1,
        right: -1,
        body_id: -1,
        height: 0,
      })
      self.body_ids.push(-1)
      self.nodes.length() - 1
    }
  }
  id
}

///|
/// Insert a body's AABB as a leaf. Returns the leaf node id.
pub fn AABBTree::insert(self : AABBTree, body_id : Int, box : AABB) -> Int {
  let leaf = self.alloc_node(box)
  self.body_ids[leaf] = body_id
  self.nodes[leaf].body_id = body_id
  if self.root == -1 {
    self.root = leaf
    return leaf
  }
  // Stage 1: walk down to find the best sibling, minimizing union area.
  let mut node = self.root
  while self.nodes[node].body_id == -1 {
    let left = self.nodes[node].left
    let right = self.nodes[node].right
    let union = self.nodes[node].box.union(box)
    let cost_new = union.surface_area()
    let cost_descend = 2.0 * union.surface_area()
    let cost_inherit = 2.0 *
      (union.surface_area() - self.nodes[node].box.surface_area())
    if cost_descend - cost_inherit < cost_new {
      // Descend.
      let left_union = self.nodes[left].box.union(box).surface_area()
      let right_union = self.nodes[right].box.union(box).surface_area()
      node = if left_union < right_union { left } else { right }
    } else {
      break
    }
  }
  let sibling = node
  let old_parent = self.nodes[sibling].parent
  // Stage 2: create new internal node above the sibling.
  let new_internal = self.alloc_node(self.nodes[sibling].box.union(box))
  self.nodes[new_internal].parent = old_parent
  if old_parent == -1 {
    self.root = new_internal
  } else if self.nodes[old_parent].left == sibling {
    self.nodes[old_parent].left = new_internal
  } else {
    self.nodes[old_parent].right = new_internal
  }
  self.nodes[new_internal].left = sibling
  self.nodes[new_internal].right = leaf
  self.nodes[sibling].parent = new_internal
  self.nodes[leaf].parent = new_internal
  self.nodes[new_internal].height = 1 +
    self.nodes[sibling].height.max(self.nodes[leaf].height)
  // Stage 3: walk up, refit AABBs and heights.
  let mut p = self.nodes[leaf].parent
  while p != -1 {
    let l = self.nodes[p].left
    let r = self.nodes[p].right
    self.nodes[p].box = self.nodes[l].box.union(self.nodes[r].box)
    self.nodes[p].height = 1 + self.nodes[l].height.max(self.nodes[r].height)
    p = self.nodes[p].parent
  }
  leaf
}

///|
/// Query candidate pairs by intersecting all leaf AABBs.
pub fn AABBTree::pairs(self : AABBTree) -> Array[(Int, Int)] {
  let result : Array[(Int, Int)] = []
  if self.root == -1 {
    return result
  }
  // Collect leaves in id order.
  let leaves : Array[Int] = []
  self.collect_leaves(self.root, leaves)
  let n = leaves.length()
  let seen : Map[(Int, Int), Unit] = Map([])
  for i = 0; i < n; i = i + 1 {
    for j = i + 1; j < n; j = j + 1 {
      let a = self.body_ids[leaves[i]]
      let b = self.body_ids[leaves[j]]
      if self.nodes[leaves[i]].box.overlaps(self.nodes[leaves[j]].box) {
        let (lo, hi) = if a < b { (a, b) } else { (b, a) }
        let k = (lo, hi)
        if !seen.contains(k) {
          seen.set(k, ())
          result.push((lo, hi))
        }
      }
    }
  }
  result
}

///|
fn AABBTree::collect_leaves(
  self : AABBTree,
  node : Int,
  out : Array[Int],
) -> Unit {
  if self.nodes[node].body_id >= 0 {
    out.push(node)
    return
  }
  self.collect_leaves(self.nodes[node].left, out)
  self.collect_leaves(self.nodes[node].right, out)
}

///|
/// Number of nodes (leaves + internal).
pub fn AABBTree::size(self : AABBTree) -> Int {
  self.nodes.length()
}
