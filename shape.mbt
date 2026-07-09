///|
/// Shape kinds supported by MoonCollider.
///
/// A `Shape` is geometry without a body: it lives in world space and is used
/// directly by the narrowphase and raycast APIs. The rigid-body layer wraps
/// shapes with mass and velocity (see `body.mbt`).
pub enum Shape {
  /// Axis-aligned bounding box, stored as center + half-extents.
  AABB(AABB)
  /// Circle, stored as center + radius.
  Circle(Circle)
  /// Convex polygon, stored as world-space vertices (counter-clockwise).
  /// The polygon must be convex; use `Polygon::convex_hull` to build one safely.
  Polygon(Polygon)
}

///|
/// Axis-aligned bounding box.
pub(all) struct AABB {
  center : Vec2
  half : Vec2
} derive(Eq, Debug)

///|
/// Circle.
pub(all) struct Circle {
  center : Vec2
  radius : Double
} derive(Eq, Debug)

///|
/// Convex polygon. Vertices are in world space, counter-clockwise.
pub(all) struct Polygon {
  vertices : Array[Vec2]
  /// Cached edge normals (outward, unit length), parallel to `vertices`.
  normals : Array[Vec2]
} derive(Eq, Debug)

///|
/// Construct an AABB from center and half-extents.
pub fn AABB::new(center : Vec2, half : Vec2) -> AABB {
  { center, half }
}

///|
/// Construct an AABB from min/max corners (inclusive).
pub fn AABB::from_min_max(min : Vec2, max : Vec2) -> AABB {
  let center = min.add(max).scale(0.5)
  let half = max.sub(min).scale(0.5)
  { center, half }
}

///|
/// Min corner.
pub fn AABB::min(self : AABB) -> Vec2 {
  self.center.sub(self.half)
}

///|
/// Max corner.
pub fn AABB::max(self : AABB) -> Vec2 {
  self.center.add(self.half)
}

///|
/// Width (full).
pub fn AABB::width(self : AABB) -> Double {
  self.half.x * 2.0
}

///|
/// Height (full).
pub fn AABB::height(self : AABB) -> Double {
  self.half.y * 2.0
}

///|
/// Does this AABB contain a point?
pub fn AABB::contains(self : AABB, p : Vec2) -> Bool {
  let lo = self.min()
  let hi = self.max()
  p.x >= lo.x && p.x <= hi.x && p.y >= lo.y && p.y <= hi.y
}

///|
/// Expand this AABB to include a point. Returns a new AABB.
pub fn AABB::expand_point(self : AABB, p : Vec2) -> AABB {
  let lo = self.min()
  let hi = self.max()
  let nlo = Vec2::new(
    if lo.x < p.x {
      lo.x
    } else {
      p.x
    },
    if lo.y < p.y {
      lo.y
    } else {
      p.y
    },
  )
  let nhi = Vec2::new(
    if hi.x > p.x {
      hi.x
    } else {
      p.x
    },
    if hi.y > p.y {
      hi.y
    } else {
      p.y
    },
  )
  AABB::from_min_max(nlo, nhi)
}

///|
/// Union of two AABBs.
pub fn AABB::union(self : AABB, other : AABB) -> AABB {
  let a = self.min()
  let b = self.max()
  let c = other.min()
  let d = other.max()
  let lo = Vec2::new(
    if a.x < c.x {
      a.x
    } else {
      c.x
    },
    if a.y < c.y {
      a.y
    } else {
      c.y
    },
  )
  let hi = Vec2::new(
    if b.x > d.x {
      b.x
    } else {
      d.x
    },
    if b.y > d.y {
      b.y
    } else {
      d.y
    },
  )
  AABB::from_min_max(lo, hi)
}

///|
/// Surface area.
pub fn AABB::surface_area(self : AABB) -> Double {
  2.0 * (self.half.x * 2.0 + self.half.y * 2.0)
}

///|
/// Perimeter.
pub fn AABB::perimeter(self : AABB) -> Double {
  2.0 * (self.half.x * 2.0 + self.half.y * 2.0)
}

///|
/// Area.
pub fn AABB::area(self : AABB) -> Double {
  self.half.x * 2.0 * (self.half.y * 2.0)
}

///|
/// Does this AABB overlap another (touching counts as overlap)?
pub fn AABB::overlaps(self : AABB, other : AABB) -> Bool {
  let a = self.min()
  let b = self.max()
  let c = other.min()
  let d = other.max()
  if b.x < c.x || d.x < a.x {
    false
  } else if b.y < c.y || d.y < a.y {
    false
  } else {
    true
  }
}

///|
/// Construct a circle.
pub fn Circle::new(center : Vec2, radius : Double) -> Circle {
  { center, radius }
}

///|
/// Does this circle contain a point?
pub fn Circle::contains(self : Circle, p : Vec2) -> Bool {
  let d = p.sub(self.center)
  d.length_sq() <= self.radius * self.radius
}

///|
/// Build a convex polygon from vertices. The vertices are reduced to their
/// convex hull and ordered counter-clockwise. Fewer than 3 unique points
/// returns an empty polygon (no vertices).
pub fn Polygon::convex_hull(points : Array[Vec2]) -> Polygon {
  let n = points.length()
  if n < 3 {
    return { vertices: [], normals: [] }
  }
  // Find the rightmost-lowest point as the hull start (lowest y, then lowest x).
  let mut start = 0
  for i = 0; i < n; i = i + 1 {
    let p = points[i]
    let s = points[start]
    if p.y < s.y || (p.y == s.y && p.x > s.x) {
      start = i
    }
  }
  // Andrew's monotone chain hull.
  // Sort by (x, then y).
  let sorted = Array::make(n, Vec2::zero())
  for i = 0; i < n; i = i + 1 {
    sorted[i] = points[i]
  }
  // Simple insertion sort (n is small for game polygons).
  for i = 1; i < n; i = i + 1 {
    let key = sorted[i]
    let mut j = i - 1
    while j >= 0 &&
          (sorted[j].x > key.x || (sorted[j].x == key.x && sorted[j].y > key.y)) {
      sorted[j + 1] = sorted[j]
      j = j - 1
    }
    sorted[j + 1] = key
  }
  // Build lower hull.
  let lower : Array[Vec2] = []
  for i = 0; i < n; i = i + 1 {
    let p = sorted[i]
    while lower.length() >= 2 {
      let m = lower.length()
      let a = lower[m - 2]
      let b = lower[m - 1]
      if cross3(a, b, p) <= 0.0 {
        ignore(lower.pop())
      } else {
        break
      }
    }
    lower.push(p)
  }
  // Build upper hull.
  let upper : Array[Vec2] = []
  let mut i = n - 1
  while i >= 0 {
    let p = sorted[i]
    while upper.length() >= 2 {
      let m = upper.length()
      let a = upper[m - 2]
      let b = upper[m - 1]
      if cross3(a, b, p) <= 0.0 {
        ignore(upper.pop())
      } else {
        break
      }
    }
    upper.push(p)
    i = i - 1
  }
  // Concatenate, dropping the last point of each (it's the first of the other).
  let hull : Array[Vec2] = []
  for k = 0; k < lower.length() - 1; k = k + 1 {
    hull.push(lower[k])
  }
  for k = 0; k < upper.length() - 1; k = k + 1 {
    hull.push(upper[k])
  }
  Polygon::from_vertices_ccw(hull)
}

///|
/// Cross product of (b - a) and (p - a). Positive => p is to the left of a->b.
fn cross3(a : Vec2, b : Vec2, p : Vec2) -> Double {
  b.sub(a).cross(p.sub(a))
}

///|
/// Build a polygon from counter-clockwise vertices, computing normals.
/// Vertices are assumed to already be in CCW order and convex.
pub fn Polygon::from_vertices_ccw(vertices : Array[Vec2]) -> Polygon {
  let n = vertices.length()
  let normals = Array::make(n, Vec2::zero())
  for i = 0; i < n; i = i + 1 {
    let a = vertices[i]
    let b = vertices[(i + 1) % n]
    let edge = b.sub(a)
    // Outward normal for CCW polygon is the right-perpendicular: (y, -x) then normalize.
    let normal = Vec2::new(edge.y, -edge.x).normalize()
    normals[i] = normal
  }
  { vertices, normals }
}

///|
/// Construct a regular polygon (n-gon) centered at `center` with given
/// `radius` (distance from center to each vertex).
pub fn Polygon::regular(center : Vec2, radius : Double, n : Int) -> Polygon {
  let vertices = Array::make(n, Vec2::zero())
  for i = 0; i < n; i = i + 1 {
    let angle = 2.0 * @math.PI * i.to_double() / n.to_double()
    vertices[i] = center.add(
      Vec2::new(radius * @math.cos(angle), radius * @math.sin(angle)),
    )
  }
  Polygon::from_vertices_ccw(vertices)
}

///|
/// Construct a box polygon (axis-aligned) from min/max corners.
pub fn Polygon::box(min : Vec2, max : Vec2) -> Polygon {
  let vertices = [
    Vec2::new(min.x, min.y),
    Vec2::new(max.x, min.y),
    Vec2::new(max.x, max.y),
    Vec2::new(min.x, max.y),
  ]
  Polygon::from_vertices_ccw(vertices)
}

///|
/// Bounding AABB of this polygon.
pub fn Polygon::aabb(self : Polygon) -> AABB {
  let n = self.vertices.length()
  if n == 0 {
    return AABB::new(Vec2::zero(), Vec2::zero())
  }
  let mut lo_x = self.vertices[0].x
  let mut hi_x = self.vertices[0].x
  let mut lo_y = self.vertices[0].y
  let mut hi_y = self.vertices[0].y
  for i = 1; i < n; i = i + 1 {
    let p = self.vertices[i]
    if p.x < lo_x {
      lo_x = p.x
    }
    if p.x > hi_x {
      hi_x = p.x
    }
    if p.y < lo_y {
      lo_y = p.y
    }
    if p.y > hi_y {
      hi_y = p.y
    }
  }
  AABB::from_min_max(Vec2::new(lo_x, lo_y), Vec2::new(hi_x, hi_y))
}

///|
/// Number of vertices.
pub fn Polygon::size(self : Polygon) -> Int {
  self.vertices.length()
}

///|
/// Bounding AABB of a shape.
pub fn Shape::aabb(self : Shape) -> AABB {
  match self {
    Shape::AABB(b) => b
    Shape::Circle(c) => AABB::new(c.center, Vec2::new(c.radius, c.radius))
    Shape::Polygon(p) => p.aabb()
  }
}

///|
/// Construct a shape from an AABB.
pub fn Shape::from_aabb(aabb : AABB) -> Shape {
  Shape::AABB(aabb)
}

///|
/// Construct a shape from a Circle.
pub fn Shape::from_circle(c : Circle) -> Shape {
  Shape::Circle(c)
}

///|
/// Construct a shape from a Polygon.
pub fn Shape::from_polygon(p : Polygon) -> Shape {
  Shape::Polygon(p)
}
