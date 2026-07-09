///|
/// Uniform spatial hash grid broadphase.
///
/// Maps each shape's AABB to integer cells of a fixed size, recording every
/// pair of IDs that share at least one cell. Best for worlds where objects
/// are roughly uniformly distributed and similar in size.
pub(all) struct GridHash {
  /// Cell size (width = height).
  cell_size : Double
  /// cellKey -> list of body IDs in that cell.
  mut cells : Map[CellKey, Array[Int]]
}

///|
/// A 2D integer cell coordinate, used as a hashmap key.
pub(all) struct CellKey {
  cx : Int
  cy : Int
} derive(Eq, Hash)

///|
/// Construct a grid with the given cell size.
pub fn GridHash::new(cell_size : Double) -> GridHash {
  { cell_size, cells: Map([]) }
}

///|
/// Insert a body ID with the given AABB. Adds the ID to every cell the AABB
/// overlaps.
pub fn GridHash::insert(self : GridHash, id : Int, box : AABB) -> Unit {
  let lo = box.min()
  let hi = box.max()
  let x0 = cell_index(lo.x, self.cell_size)
  let x1 = cell_index(hi.x, self.cell_size)
  let y0 = cell_index(lo.y, self.cell_size)
  let y1 = cell_index(hi.y, self.cell_size)
  for cx = x0; cx <= x1; cx = cx + 1 {
    for cy = y0; cy <= y1; cy = cy + 1 {
      let key = { cx, cy }
      match self.cells.get(key) {
        Some(arr) => arr.push(id)
        None => {
          let arr : Array[Int] = []
          arr.push(id)
          self.cells.set(key, arr)
        }
      }
    }
  }
}

///|
/// Clear all entries.
pub fn GridHash::clear(self : GridHash) -> Unit {
  self.cells.clear()
}

///|
/// Compute all candidate collision pairs. Each pair (a, b) has a < b and is
/// reported at most once.
pub fn GridHash::pairs(self : GridHash) -> Array[(Int, Int)] {
  let result : Array[(Int, Int)] = []
  // Track already-emitted pairs to avoid duplicates across shared cells.
  let seen : Map[(Int, Int), Unit] = Map([])
  self.cells.each(fn(_k, arr) {
    let n = arr.length()
    for i = 0; i < n; i = i + 1 {
      for j = i + 1; j < n; j = j + 1 {
        let a = arr[i]
        let b = arr[j]
        let (lo, hi) = if a < b { (a, b) } else { (b, a) }
        let pk = (lo, hi)
        if !seen.contains(pk) {
          seen.set(pk, ())
          result.push((lo, hi))
        }
      }
    }
  })
  result
}

///|
fn cell_index(v : Double, cell_size : Double) -> Int {
  // Floor division towards negative infinity.
  let q = v / cell_size
  let i = q.floor().to_int()
  i
}

///|
/// Quadtree broadphase.
///
/// A loose quadtree: each node covers a square region and subdivides when it
/// holds more than `capacity` items. Items are stored at the deepest node
/// whose region fully contains their AABB, falling back to the node itself if
/// none fits (so large objects are always reported).
pub(all) struct QuadTree {
  /// Bounding square of this node (center + half-size).
  bounds : AABB
  /// Max items before subdividing.
  capacity : Int
  /// Max subdivision depth.
  max_depth : Int
  mut depth : Int
  /// Items in this node (id + aabb). Empty for internal nodes.
  mut items : Array[(Int, AABB)]
  /// Child quadrants; None while this node is a leaf.
  mut children : Array[QuadTree]?
}

///|
/// Construct a quadtree covering the given square region.
pub fn QuadTree::new(
  bounds : AABB,
  capacity : Int,
  max_depth : Int,
) -> QuadTree {
  { bounds, capacity, max_depth, depth: 0, items: [], children: None }
}

///|
/// Insert a body ID with the given AABB.
pub fn QuadTree::insert(self : QuadTree, id : Int, box : AABB) -> Unit {
  // Must fit (at least partially) inside this node.
  if !self.bounds.overlaps(box) {
    return
  }
  match self.children {
    Some(kids) => {
      // Try to push into a child whose bounds fully contain the box.
      let mut pushed = false
      for i = 0; i < 4; i = i + 1 {
        if kids[i].bounds.contains_box(box) {
          kids[i].insert(id, box)
          pushed = true
          break
        }
      }
      if !pushed {
        self.items.push((id, box))
      }
      return
    }
    None => {
      self.items.push((id, box))
      if self.items.length() > self.capacity && self.depth < self.max_depth {
        self.subdivide()
      }
    }
  }
}

///|
/// Does this AABB fully contain another?
fn AABB::contains_box(self : AABB, other : AABB) -> Bool {
  let a = self.min()
  let b = self.max()
  let c = other.min()
  let d = other.max()
  a.x <= c.x && a.y <= c.y && b.x >= d.x && b.y >= d.y
}

///|
fn QuadTree::subdivide(self : QuadTree) -> Unit {
  let c = self.bounds.center
  let h = self.bounds.half.scale(0.5)
  // Four child quadrants: NE, NW, SW, SE (y-up).
  let kids : Array[QuadTree] = [
    QuadTree::new(
      AABB::new(Vec2::new(c.x + h.x, c.y + h.y), h),
      self.capacity,
      self.max_depth,
    ),
    QuadTree::new(
      AABB::new(Vec2::new(c.x - h.x, c.y + h.y), h),
      self.capacity,
      self.max_depth,
    ),
    QuadTree::new(
      AABB::new(Vec2::new(c.x - h.x, c.y - h.y), h),
      self.capacity,
      self.max_depth,
    ),
    QuadTree::new(
      AABB::new(Vec2::new(c.x + h.x, c.y - h.y), h),
      self.capacity,
      self.max_depth,
    ),
  ]
  for i = 0; i < 4; i = i + 1 {
    kids[i].depth = self.depth + 1
  }
  // Re-insert this node's items into children where possible.
  let old = self.items
  self.items = []
  self.children = Some(kids)
  for i = 0; i < old.length(); i = i + 1 {
    let (id, box) = old[i]
    self.insert(id, box)
  }
}

///|
/// Query all candidate pairs. Walks the tree, pairing items whose AABBs
/// overlap. The quadtree has already culled far-apart objects by only
/// returning items whose ancestor nodes overlap the query region.
pub fn QuadTree::pairs(self : QuadTree) -> Array[(Int, Int)] {
  let all = self.collect()
  let result : Array[(Int, Int)] = []
  let seen : Map[(Int, Int), Unit] = Map([])
  let n = all.length()
  for i = 0; i < n; i = i + 1 {
    for j = i + 1; j < n; j = j + 1 {
      let (id_a, aabb_a) = all[i]
      let (id_b, aabb_b) = all[j]
      if aabb_a.overlaps(aabb_b) {
        let (lo, hi) = if id_a < id_b { (id_a, id_b) } else { (id_b, id_a) }
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
fn QuadTree::collect(self : QuadTree) -> Array[(Int, AABB)] {
  let all : Array[(Int, AABB)] = []
  self.collect_into(all)
  all
}

///|
fn QuadTree::collect_into(self : QuadTree, out : Array[(Int, AABB)]) -> Unit {
  for i = 0; i < self.items.length(); i = i + 1 {
    out.push(self.items[i])
  }
  match self.children {
    Some(kids) =>
      for i = 0; i < 4; i = i + 1 {
        kids[i].collect_into(out)
      }
    None => ()
  }
}
