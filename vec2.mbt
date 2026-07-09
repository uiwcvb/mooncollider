///|
/// 2D vector. Core math type for all geometry in MoonCollider.
pub(all) struct Vec2 {
  x : Double
  y : Double
} derive(Eq, Debug)

///|
/// Construct a vector.
pub fn Vec2::new(x : Double, y : Double) -> Vec2 {
  { x, y }
}

///|
/// Zero vector.
pub fn Vec2::zero() -> Vec2 {
  { x: 0.0, y: 0.0 }
}

///|
/// Unit vector along +x.
pub fn Vec2::unit_x() -> Vec2 {
  { x: 1.0, y: 0.0 }
}

///|
/// Unit vector along +y.
pub fn Vec2::unit_y() -> Vec2 {
  { x: 0.0, y: 1.0 }
}

///|
/// Vector addition.
pub fn Vec2::add(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
/// Vector subtraction.
pub fn Vec2::sub(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x - other.x, y: self.y - other.y }
}

///|
/// Scale by a scalar.
pub fn Vec2::scale(self : Vec2, s : Double) -> Vec2 {
  { x: self.x * s, y: self.y * s }
}

///|
/// Negate.
pub fn Vec2::neg(self : Vec2) -> Vec2 {
  { x: -self.x, y: -self.y }
}

///|
/// Dot product.
pub fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.x * other.x + self.y * other.y
}

///|
/// 2D cross product (scalar): self.x * other.y - self.y * other.x.
pub fn Vec2::cross(self : Vec2, other : Vec2) -> Double {
  self.x * other.y - self.y * other.x
}

///|
/// Squared length (cheap, no sqrt).
pub fn Vec2::length_sq(self : Vec2) -> Double {
  self.x * self.x + self.y * self.y
}

///|
/// Length.
pub fn Vec2::length(self : Vec2) -> Double {
  (self.x * self.x + self.y * self.y).sqrt()
}

///|
/// Normalize to unit length. Returns zero vector if length is zero.
pub fn Vec2::normalize(self : Vec2) -> Vec2 {
  let l = self.length()
  if l == 0.0 {
    Vec2::zero()
  } else {
    { x: self.x / l, y: self.y / l }
  }
}

///|
/// Perpendicular vector (rotated +90 degrees).
pub fn Vec2::perp(self : Vec2) -> Vec2 {
  { x: -self.y, y: self.x }
}

///|
/// Rotate by `angle` radians (counter-clockwise).
pub fn Vec2::rotate(self : Vec2, angle : Double) -> Vec2 {
  let c = @math.cos(angle)
  let s = @math.sin(angle)
  { x: self.x * c - self.y * s, y: self.x * s + self.y * c }
}

///|
/// Approximate equality within `eps`.
pub fn Vec2::approx_eq(self : Vec2, other : Vec2, eps : Double) -> Bool {
  (self.x - other.x).abs() < eps && (self.y - other.y).abs() < eps
}
