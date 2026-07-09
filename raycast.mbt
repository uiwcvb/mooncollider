///|
/// A ray: origin + direction. Direction need not be normalized; `t` results
/// are parametric (distance / |direction|).
pub(all) struct Ray {
  origin : Vec2
  direction : Vec2
} derive(Eq, Debug)

///|
/// Ray hit result. `t` is the parametric distance along the ray's direction
/// (so the world-space hit point is `ray.origin + ray.direction.scale(t)`).
/// `normal` is the surface normal at the hit (unit length, pointing back
/// towards the ray origin).
pub(all) struct RaycastHit {
  t : Double
  point : Vec2
  normal : Vec2
} derive(Eq, Debug)

///|
/// Construct a ray.
pub fn Ray::new(origin : Vec2, direction : Vec2) -> Ray {
  { origin, direction }
}

///|
/// Construct a ray from origin + a unit direction and a max distance.
pub fn Ray::from_to(origin : Vec2, target : Vec2) -> Ray {
  Ray::new(origin, target.sub(origin))
}

///|
/// Build a hit result.
pub fn RaycastHit::new(t : Double, point : Vec2, normal : Vec2) -> RaycastHit {
  { t, point, normal }
}

///|
/// Did the ray hit?
pub fn RaycastHit::hit(self : RaycastHit) -> Bool {
  self.t >= 0.0
}

///|
/// Ray vs AABB. Returns the nearest hit in `t in [0, +inf)`, or a miss
/// (`t = -1`) if the ray does not hit the box.
pub fn raycast_aabb(ray : Ray, box : AABB) -> RaycastHit {
  let lo = box.min()
  let hi = box.max()
  let inv_dx = if ray.direction.x != 0.0 {
    1.0 / ray.direction.x
  } else {
    1.0e30
  }
  let inv_dy = if ray.direction.y != 0.0 {
    1.0 / ray.direction.y
  } else {
    1.0e30
  }
  let tx1 = (lo.x - ray.origin.x) * inv_dx
  let tx2 = (hi.x - ray.origin.x) * inv_dx
  let mut tmin = if tx1 < tx2 { tx1 } else { tx2 }
  let mut tmax = if tx1 < tx2 { tx2 } else { tx1 }
  let ty1 = (lo.y - ray.origin.y) * inv_dy
  let ty2 = (hi.y - ray.origin.y) * inv_dy
  let tyn = if ty1 < ty2 { ty1 } else { ty2 }
  let tyx = if ty1 < ty2 { ty2 } else { ty1 }
  if tyn > tmin {
    tmin = tyn
  }
  if tyx < tmax {
    tmax = tyx
  }
  if tmax < 0.0 || tmin > tmax {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let t = if tmin >= 0.0 { tmin } else { tmax }
  if t < 0.0 {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let point = ray.origin.add(ray.direction.scale(t))
  // Normal: which face did we hit?
  let normal = aabb_face_normal(box, point)
  RaycastHit::new(t, point, normal)
}

///|
fn aabb_face_normal(box : AABB, p : Vec2) -> Vec2 {
  let lo = box.min()
  let hi = box.max()
  let d_left = (p.x - lo.x).abs()
  let d_right = (p.x - hi.x).abs()
  let d_bottom = (p.y - lo.y).abs()
  let d_top = (p.y - hi.y).abs()
  let m = d_left
  let mut best = 0
  if d_right < m {
    best = 1
  }
  if d_bottom < m {
    best = 2
  }
  if d_top < m {
    best = 3
  }
  match best {
    0 => Vec2::new(-1.0, 0.0)
    1 => Vec2::new(1.0, 0.0)
    2 => Vec2::new(0.0, -1.0)
    _ => Vec2::new(0.0, 1.0)
  }
}

///|
/// Ray vs Circle. Returns nearest hit or miss.
pub fn raycast_circle(ray : Ray, c : Circle) -> RaycastHit {
  let oc = ray.origin.sub(c.center)
  let a = ray.direction.dot(ray.direction)
  let b = 2.0 * oc.dot(ray.direction)
  let cc = oc.dot(oc) - c.radius * c.radius
  let disc = b * b - 4.0 * a * cc
  if disc < 0.0 {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let sq = disc.sqrt()
  let t1 = (-b - sq) / (2.0 * a)
  let t2 = (-b + sq) / (2.0 * a)
  let t = if t1 >= 0.0 {
    t1
  } else if t2 >= 0.0 {
    t2
  } else {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let point = ray.origin.add(ray.direction.scale(t))
  let normal = point.sub(c.center).normalize()
  RaycastHit::new(t, point, normal)
}

///|
/// Ray vs convex Polygon. Returns nearest hit or miss.
pub fn raycast_polygon(ray : Ray, p : Polygon) -> RaycastHit {
  let n = p.vertices.length()
  if n < 3 {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let mut best_t = 1.0e30
  let mut best_normal = Vec2::zero()
  let mut hit = false
  for i = 0; i < n; i = i + 1 {
    let a = p.vertices[i]
    let b = p.vertices[(i + 1) % n]
    match ray_segment(ray, a, b) {
      Some((t, normal)) =>
        if t >= 0.0 && t < best_t {
          best_t = t
          best_normal = normal
          hit = true
        }
      None => ()
    }
  }
  if !hit {
    return RaycastHit::new(-1.0, Vec2::zero(), Vec2::zero())
  }
  let point = ray.origin.add(ray.direction.scale(best_t))
  RaycastHit::new(best_t, point, best_normal)
}

///|
/// Ray vs segment a->b. Returns Some((t, outward_normal)) on hit, else None.
/// `t` is parametric along the ray.
fn ray_segment(ray : Ray, a : Vec2, b : Vec2) -> (Double, Vec2)? {
  let edge = b.sub(a)
  let denom = ray.direction.cross(edge)
  if denom.abs() < 1.0e-12 {
    // Parallel.
    return None
  }
  let diff = a.sub(ray.origin)
  let t = diff.cross(edge) / denom
  let s = diff.cross(ray.direction) / denom
  if t >= 0.0 && s >= 0.0 && s <= 1.0 {
    // Outward normal of edge (polygon assumed CCW): right-perp of edge.
    let normal = Vec2::new(edge.y, -edge.x).normalize()
    Some((t, normal))
  } else {
    None
  }
}

///|
/// Generic ray vs shape dispatch.
pub fn raycast(ray : Ray, shape : Shape) -> RaycastHit {
  match shape {
    Shape::AABB(b) => raycast_aabb(ray, b)
    Shape::Circle(c) => raycast_circle(ray, c)
    Shape::Polygon(p) => raycast_polygon(ray, p)
  }
}
