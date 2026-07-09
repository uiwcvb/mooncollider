///|
/// GJK (Gilbert-Johnson-Keerthi) distance / collision for two convex shapes,
/// plus EPA (Expanding Polytope Algorithm) to recover penetration depth and
/// normal when the shapes overlap.
///
/// This is an alternative to the specialized narrowphase functions in
/// `narrowphase.mbt`. It works on any pair of convex shapes via their support
/// functions, so it handles Circle, AABB (as a box polygon), and convex
/// Polygon uniformly. Use `collide_gjk(a, b)` as a generic fallback.
///
/// Returns a `Manifold` with normal from A to B (consistent with the rest of
/// MoonCollider).

///|
/// A support function maps a direction `d` to the farthest point of a convex
/// shape along `d`. GJK only needs this to reason about a shape.
pub fn Shape::support(self : Shape, d : Vec2) -> Vec2 {
  match self {
    Shape::Circle(c) =>
      if d.length_sq() == 0.0 {
        c.center
      } else {
        c.center.add(d.normalize().scale(c.radius))
      }
    Shape::AABB(b) => aabb_support(b, d)
    Shape::Polygon(p) => polygon_support(p, d)
  }
}

///|
fn aabb_support(b : AABB, d : Vec2) -> Vec2 {
  // Farthest corner along d.
  let cx = if d.x >= 0.0 { b.max().x } else { b.min().x }
  let cy = if d.y >= 0.0 { b.max().y } else { b.min().y }
  Vec2::new(cx, cy)
}

///|
fn polygon_support(p : Polygon, d : Vec2) -> Vec2 {
  let n = p.vertices.length()
  if n == 0 {
    return Vec2::zero()
  }
  let mut best = p.vertices[0]
  let mut best_dot = best.dot(d)
  for i = 1; i < n; i = i + 1 {
    let dot = p.vertices[i].dot(d)
    if dot > best_dot {
      best_dot = dot
      best = p.vertices[i]
    }
  }
  best
}

///|
/// Minkowski support: support_B(d) - support_A(-d). Returns a point on the
/// Minkowski difference boundary.
fn minkowski_support(a : Shape, b : Shape, d : Vec2) -> Vec2 {
  let pa = a.support(d)
  let pb = b.support(d.neg())
  pa.sub(pb)
}

///|
/// GJK collision test + EPA penetration recovery. Returns a `Manifold`
/// (normal from A to B) if the shapes overlap, else `Manifold::none()`.
pub fn collide_gjk(a : Shape, b : Shape) -> Manifold {
  let dir = Vec2::new(1.0, 0.0)
  let s0 = minkowski_support(a, b, dir)
  let simplex : Array[Vec2] = [s0]
  let d0 = s0.neg()
  let (collided, final_simplex) = gjk_loop(a, b, simplex, d0)
  if !collided {
    return Manifold::none()
  }
  // EPA: expand the simplex to find the penetration.
  epa(a, b, final_simplex)
}

///|
/// GJK iteration loop. Returns (collided, final_simplex).
fn gjk_loop(
  a : Shape,
  b : Shape,
  simplex0 : Array[Vec2],
  d0 : Vec2,
) -> (Bool, Array[Vec2]) {
  let simplex : Array[Vec2] = []
  for i = 0; i < simplex0.length(); i = i + 1 {
    simplex.push(simplex0[i])
  }
  let mut d = d0
  let mut iter = 0
  let max_iter = 64
  let mut collided = false
  while iter < max_iter {
    iter = iter + 1
    let p = minkowski_support(a, b, d)
    if p.dot(d) < 0.0 {
      // Origin is outside the Minkowski difference -> no collision.
      collided = false
      break
    }
    simplex.push(p)
    let (result, new_d) = gjk_simplex_update(simplex, d)
    match result {
      GjkResult::Contain => {
        collided = true
        break
      }
      GjkResult::Continue => d = new_d
    }
  }
  (collided, simplex)
}

///|
priv enum GjkResult {
  /// Origin is inside the simplex.
  Contain
  /// Continue iterating with updated direction.
  Continue
}

///|
/// Update the simplex and search direction for GJK. Returns (result, new_d).
/// `Contain` means the origin is enclosed; otherwise the simplex is reduced
/// to 1 or 2 points and `new_d` is the next search direction.
fn gjk_simplex_update(simplex : Array[Vec2], _d : Vec2) -> (GjkResult, Vec2) {
  match simplex.length() {
    2 => {
      // 2-point simplex: line case.
      let b = simplex[0]
      let a = simplex[1]
      let ab = b.sub(a)
      let ao = a.neg()
      if ab.dot(ao) > 0.0 {
        // Origin is in the direction of ab from a.
        (Continue, triple_cross(ab, ao))
      } else {
        // Origin is past a.
        ignore(simplex.remove(0))
        (Continue, ao)
      }
    }
    3 => {
      // 3-point simplex (triangle). Check regions.
      let c = simplex[0]
      let b = simplex[1]
      let a = simplex[2]
      let ab = b.sub(a)
      let ac = c.sub(a)
      let ao = a.neg()
      let abc = ab.cross(ac)
      // Region ab: origin outside edge ab (on the c-side).
      if ab.cross(ao) * -abc > 0.0 {
        // remove c
        ignore(simplex.remove(0))
        return (Continue, triple_cross(ab, ao))
      }
      // Region ac: origin outside edge ac (on the b-side).
      if ac.cross(ao) * abc > 0.0 {
        // remove b
        ignore(simplex.remove(1))
        return (Continue, triple_cross(ac, ao))
      }
      // Origin is inside the triangle (passed both edge tests).
      // The winding determines the next direction if we needed it, but for
      // containment we're done.
      (Contain, Vec2::zero())
    }
    _ => (Continue, Vec2::new(1.0, 0.0))
  }
}

///|
/// Triple cross product: (a x b) x c. In 2D this gives a vector perpendicular
/// to `a` in the plane of a,b. Computed as z = a.cross(b); result = (-z*b.y, z*b.x).
fn triple_cross(a : Vec2, b : Vec2) -> Vec2 {
  let z = a.cross(b)
  Vec2::new(-z * b.y, z * b.x)
}

///|
/// EPA: expand the simplex toward the origin to find the closest edge and
/// thus the penetration depth + normal.
fn epa(a : Shape, b : Shape, simplex : Array[Vec2]) -> Manifold {
  let poly : Array[Vec2] = []
  for i = 0; i < simplex.length(); i = i + 1 {
    poly.push(simplex[i])
  }
  // Ensure CCW winding.
  if !poly_is_ccw(poly) {
    reverse_array(poly)
  }
  let mut iter = 0
  let max_iter = 64
  let mut best_normal = Vec2::new(0.0, 1.0)
  let mut best_depth = 0.0
  while iter < max_iter {
    iter = iter + 1
    // Find the edge closest to the origin.
    let (normal, depth, edge_idx) = closest_edge(poly)
    let p = minkowski_support(a, b, normal)
    let d = p.dot(normal)
    if d - depth < 1.0e-6 {
      // Converged.
      best_normal = normal
      best_depth = d
      break
    } else {
      // Insert p between edge_idx and edge_idx+1.
      poly.insert(edge_idx + 1, p)
    }
    best_normal = normal
    best_depth = d
  }
  // Contact point: approximate via the support points.
  let contact = a
    .support(best_normal)
    .add(b.support(best_normal.neg()))
    .scale(0.5)
  Manifold::new(best_normal, best_depth, contact)
}

///|
fn poly_is_ccw(poly : Array[Vec2]) -> Bool {
  let n = poly.length()
  if n < 3 {
    return true
  }
  let mut area = 0.0
  for i = 0; i < n; i = i + 1 {
    let a = poly[i]
    let b = poly[(i + 1) % n]
    area += a.cross(b)
  }
  area > 0.0
}

///|
/// In-place reverse of an array.
fn reverse_array(arr : Array[Vec2]) -> Unit {
  let n = arr.length()
  let mut i = 0
  let mut j = n - 1
  while i < j {
    let tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
    i = i + 1
    j = j - 1
  }
}

///|
/// Find the edge of `poly` closest to the origin. Returns
/// (outward_unit_normal, distance_from_origin, edge_start_index).
fn closest_edge(poly : Array[Vec2]) -> (Vec2, Double, Int) {
  let n = poly.length()
  let mut best_dist = 1.0e30
  let mut best_normal = Vec2::new(0.0, 1.0)
  let mut best_idx = 0
  for i = 0; i < n; i = i + 1 {
    let a = poly[i]
    let b = poly[(i + 1) % n]
    let edge = b.sub(a)
    // Outward normal (assuming CCW): right-perp = (edge.y, -edge.x).
    let normal = Vec2::new(edge.y, -edge.x).normalize()
    let dist = a.dot(normal)
    if dist < best_dist {
      best_dist = dist
      best_normal = normal
      best_idx = i
    }
  }
  (best_normal, best_dist, best_idx)
}
