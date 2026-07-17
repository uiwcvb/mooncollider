///|
/// Contact manifold: the result of a narrowphase collision query.
///
/// `normal` points from A to B (the direction B should be pushed along to
/// separate). `depth` is the penetration depth. `contact` is a representative
/// contact point (the deepest overlap point), useful for torque computation.
/// `contact2` is an optional second contact point for edge/edge collisions
/// (AABB-AABB face contacts), improving stacking stability.
pub(all) struct Manifold {
  /// Unit normal pointing from A towards B.
  normal : Vec2
  /// Penetration depth (>= 0). Zero when shapes are just touching.
  depth : Double
  /// Representative contact point in world space.
  contact : Vec2
  /// Optional second contact point (None for single-point manifolds).
  contact2 : Vec2
} derive(Eq, Debug)

///|
/// An empty manifold (no collision). `normal` is zero, `depth` is 0.
pub fn Manifold::none() -> Manifold {
  {
    normal: Vec2::zero(),
    depth: 0.0,
    contact: Vec2::zero(),
    contact2: Vec2::zero(),
  }
}

///|
/// Did the shapes collide?
pub fn Manifold::colliding(self : Manifold) -> Bool {
  self.depth > 0.0
}

///|
/// Does this manifold have a second contact point?
pub fn Manifold::has_second_contact(self : Manifold) -> Bool {
  self.contact2.length_sq() > 0.0
}

///|
/// Build a manifold with a single contact point.
pub fn Manifold::new(normal : Vec2, depth : Double, contact : Vec2) -> Manifold {
  { normal, depth, contact, contact2: Vec2::zero() }
}

///|
/// Build a manifold with two contact points.
pub fn Manifold::new2(
  normal : Vec2,
  depth : Double,
  contact : Vec2,
  contact2 : Vec2,
) -> Manifold {
  { normal, depth, contact, contact2 }
}

///|
/// AABB vs AABB. Returns a manifold if they overlap, else `none`.
pub fn collide_aabb_aabb(a : AABB, b : AABB) -> Manifold {
  let a_lo = a.min()
  let a_hi = a.max()
  let b_lo = b.min()
  let b_hi = b.max()
  // Overlap on each axis.
  let ox = if a_hi.x < b_hi.x { a_hi.x - b_lo.x } else { b_hi.x - a_lo.x }
  let oy = if a_hi.y < b_hi.y { a_hi.y - b_lo.y } else { b_hi.y - a_lo.y }
  if ox <= 0.0 || oy <= 0.0 {
    return Manifold::none()
  }
  // Normal points from A to B along the axis of least penetration.
  if ox < oy {
    let nx = if a.center.x < b.center.x { 1.0 } else { -1.0 }
    let contact_x = if a.center.x < b.center.x { a_hi.x } else { a_lo.x }
    let y_hi = if a_hi.y < b_hi.y { a_hi.y } else { b_hi.y }
    let y_lo = if a_lo.y > b_lo.y { a_lo.y } else { b_lo.y }
    // Two contact points at the endpoints of the overlapping y-interval.
    let c1 = Vec2::new(contact_x, y_lo)
    let c2 = Vec2::new(contact_x, y_hi)
    Manifold::new2(Vec2::new(nx, 0.0), ox, c1, c2)
  } else {
    let ny = if a.center.y < b.center.y { 1.0 } else { -1.0 }
    let contact_y = if a.center.y < b.center.y { a_hi.y } else { a_lo.y }
    let x_hi = if a_hi.x < b_hi.x { a_hi.x } else { b_hi.x }
    let x_lo = if a_lo.x > b_lo.x { a_lo.x } else { b_lo.x }
    let c1 = Vec2::new(x_lo, contact_y)
    let c2 = Vec2::new(x_hi, contact_y)
    Manifold::new2(Vec2::new(0.0, ny), oy, c1, c2)
  }
}

///|
/// Circle vs Circle.
pub fn collide_circle_circle(a : Circle, b : Circle) -> Manifold {
  let d = b.center.sub(a.center)
  let r = a.radius + b.radius
  let dist_sq = d.length_sq()
  if dist_sq >= r * r {
    return Manifold::none()
  }
  let dist = dist_sq.sqrt()
  let normal = if dist > 0.0 {
    d.scale(1.0 / dist)
  } else {
    // Concentric: pick an arbitrary normal (up).
    Vec2::new(0.0, 1.0)
  }
  let depth = r - dist
  let contact = a.center.add(normal.scale(a.radius))
  Manifold::new(normal, depth, contact)
}

///|
/// AABB vs Circle. Normal points from AABB (A) to Circle (B).
pub fn collide_aabb_circle(a : AABB, b : Circle) -> Manifold {
  let lo = a.min()
  let hi = a.max()
  // Closest point on the AABB to the circle center.
  let cx = if b.center.x < lo.x {
    lo.x
  } else if b.center.x > hi.x {
    hi.x
  } else {
    b.center.x
  }
  let cy = if b.center.y < lo.y {
    lo.y
  } else if b.center.y > hi.y {
    hi.y
  } else {
    b.center.y
  }
  let closest = Vec2::new(cx, cy)
  let d = b.center.sub(closest)
  let dist_sq = d.length_sq()
  if dist_sq >= b.radius * b.radius {
    return Manifold::none()
  }
  let dist = dist_sq.sqrt()
  let normal = if dist > 0.0 {
    // From A (box) to B (circle): direction of d.
    d.scale(1.0 / dist)
  } else {
    // Center is inside the box. Push out along the axis of least penetration.
    let dx_lo = (b.center.x - lo.x).abs()
    let dx_hi = (b.center.x - hi.x).abs()
    let dy_lo = (b.center.y - lo.y).abs()
    let dy_hi = (b.center.y - hi.y).abs()
    let m = dx_lo
    let mut best = 0 // 0=xlo,1=xhi,2=ylo,3=yhi
    if dx_hi < m {
      best = 1
    }
    if dy_lo < m {
      best = 2
    }
    if dy_hi < m {
      best = 3
    }
    match best {
      0 => Vec2::new(-1.0, 0.0)
      1 => Vec2::new(1.0, 0.0)
      2 => Vec2::new(0.0, -1.0)
      _ => Vec2::new(0.0, 1.0)
    }
  }
  let depth = b.radius - dist
  let contact = closest
  Manifold::new(normal, depth, contact)
}

///|
/// Polygon vs Polygon using the Separating Axis Theorem.
/// Normals point from A to B.
pub fn collide_polygon_polygon(a : Polygon, b : Polygon) -> Manifold {
  if a.size() == 0 || b.size() == 0 {
    return Manifold::none()
  }
  // Test A's normals then B's normals, tracking the minimum overlap.
  let r1 = sat_axes(a, b)
  match r1 {
    None => return Manifold::none()
    Some(d1) => {
      let r2 = sat_axes(b, a)
      match r2 {
        None => return Manifold::none()
        Some(d2) => {
          let best = if d1.0 < d2.0 { d1 } else { d2 }
          let mut best_normal = best.1
          // Ensure normal points from A to B.
          let dir = polygon_center(b).sub(polygon_center(a))
          if dir.dot(best_normal) < 0.0 {
            best_normal = best_normal.neg()
          }
          let contact = polygon_center(a).add(best_normal.scale(best.0))
          return Manifold::new(best_normal, best.0, contact)
        }
      }
    }
  }
}

///|
/// SAT test over all axes of `a`. Returns None if a separating axis is found,
/// else Some((min_overlap, axis)).
fn sat_axes(a : Polygon, b : Polygon) -> (Double, Vec2)? {
  let n = a.normals.length()
  let mut best_depth = 1.0e30
  let mut best_axis = Vec2::zero()
  for i = 0; i < n; i = i + 1 {
    let axis = a.normals[i]
    let (pa, qa) = project(a, axis)
    let (pb, qb) = project(b, axis)
    let overlap = if qa < qb { qa - pb } else { qb - pa }
    if overlap <= 0.0 {
      return None
    }
    if overlap < best_depth {
      best_depth = overlap
      best_axis = axis
    }
  }
  Some((best_depth, best_axis))
}

///|
/// Project a polygon onto an axis, returning (min, max).
fn project(p : Polygon, axis : Vec2) -> (Double, Double) {
  let n = p.vertices.length()
  let mut lo = p.vertices[0].dot(axis)
  let mut hi = lo
  for i = 1; i < n; i = i + 1 {
    let v = p.vertices[i].dot(axis)
    if v < lo {
      lo = v
    }
    if v > hi {
      hi = v
    }
  }
  (lo, hi)
}

///|
fn polygon_center(p : Polygon) -> Vec2 {
  let n = p.vertices.length()
  if n == 0 {
    return Vec2::zero()
  }
  let mut sx = 0.0
  let mut sy = 0.0
  for i = 0; i < n; i = i + 1 {
    sx += p.vertices[i].x
    sy += p.vertices[i].y
  }
  Vec2::new(sx / n.to_double(), sy / n.to_double())
}

///|
/// AABB vs Polygon. Normal points from AABB (A) to Polygon (B).
pub fn collide_aabb_polygon(a : AABB, b : Polygon) -> Manifold {
  if b.size() == 0 {
    return Manifold::none()
  }
  // Treat the AABB as a polygon for SAT.
  let a_poly = Polygon::box(a.min(), a.max())
  collide_polygon_polygon(a_poly, b)
}

///|
/// Circle vs Polygon. Normal points from Circle (A) to Polygon (B).
pub fn collide_circle_polygon(a : Circle, b : Polygon) -> Manifold {
  if b.size() == 0 {
    return Manifold::none()
  }
  // Find the closest point on the polygon to the circle center.
  let mut best_dist_sq = 1.0e30
  let mut best_point = b.vertices[0]
  let n = b.vertices.length()
  for i = 0; i < n; i = i + 1 {
    let p1 = b.vertices[i]
    let p2 = b.vertices[(i + 1) % n]
    let cp = closest_point_on_segment(a.center, p1, p2)
    let d = a.center.sub(cp).length_sq()
    if d < best_dist_sq {
      best_dist_sq = d
      best_point = cp
    }
  }
  let to_circle = a.center.sub(best_point)
  let dist = best_dist_sq.sqrt()
  // Check if the circle center is inside the polygon.
  let inside = point_in_polygon(a.center, b)
  if !inside && dist >= a.radius {
    return Manifold::none()
  }
  // Normal points from A (circle) to B (polygon surface).
  let normal = if inside {
    // Center inside polygon: push toward nearest edge (outward from A to B).
    if dist > 0.0 {
      to_circle.scale(1.0 / dist)
    } else {
      Vec2::new(0.0, 1.0)
    }
  } else if dist > 0.0 {
    // Center outside: normal from circle center toward polygon surface.
    to_circle.scale(-1.0 / dist)
  } else {
    Vec2::new(0.0, 1.0)
  }
  let depth = if inside { a.radius + dist } else { a.radius - dist }
  Manifold::new(normal, depth, best_point)
}

///|
/// Closest point on segment p1->p2 to point p.
fn closest_point_on_segment(p : Vec2, p1 : Vec2, p2 : Vec2) -> Vec2 {
  let edge = p2.sub(p1)
  let len_sq = edge.length_sq()
  if len_sq == 0.0 {
    return p1
  }
  let t = p.sub(p1).dot(edge) / len_sq
  let tc = if t < 0.0 { 0.0 } else if t > 1.0 { 1.0 } else { t }
  p1.add(edge.scale(tc))
}

///|
/// Is point `p` inside convex polygon `poly`? Uses winding; edges inclusive.
fn point_in_polygon(p : Vec2, poly : Polygon) -> Bool {
  let n = poly.vertices.length()
  if n < 3 {
    return false
  }
  for i = 0; i < n; i = i + 1 {
    let a = poly.vertices[i]
    let b = poly.vertices[(i + 1) % n]
    let c = cross3(a, b, p)
    if c < 0.0 {
      return false
    }
  }
  true
}

///|
/// Dispatch a generic shape-vs-shape collision. Normal points from `a` to `b`.
pub fn collide(a : Shape, b : Shape) -> Manifold {
  match (a, b) {
    (Shape::AABB(a), Shape::AABB(b)) => collide_aabb_aabb(a, b)
    (Shape::Circle(a), Shape::Circle(b)) => collide_circle_circle(a, b)
    (Shape::AABB(a), Shape::Circle(b)) => collide_aabb_circle(a, b)
    (Shape::Circle(a), Shape::AABB(b)) => {
      let m = collide_aabb_circle(b, a)
      if m.colliding() {
        Manifold::new(m.normal.neg(), m.depth, m.contact)
      } else {
        m
      }
    }
    (Shape::Polygon(a), Shape::Polygon(b)) => collide_polygon_polygon(a, b)
    (Shape::AABB(a), Shape::Polygon(b)) => collide_aabb_polygon(a, b)
    (Shape::Polygon(a), Shape::AABB(b)) => {
      let m = collide_aabb_polygon(b, a)
      if m.colliding() {
        Manifold::new(m.normal.neg(), m.depth, m.contact)
      } else {
        m
      }
    }
    (Shape::Circle(a), Shape::Polygon(b)) => collide_circle_polygon(a, b)
    (Shape::Polygon(a), Shape::Circle(b)) => {
      let m = collide_circle_polygon(b, a)
      if m.colliding() {
        Manifold::new(m.normal.neg(), m.depth, m.contact)
      } else {
        m
      }
    }
  }
}
