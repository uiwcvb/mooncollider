///|
/// Rigid body type. Static bodies have infinite mass and don't move.
pub enum BodyType {
  /// Infinite mass, infinite inertia; never moves. Used for walls/floors.
  Static
  /// Finite mass, responds to forces and collisions.
  Dynamic
}

///|
/// A 2D rigid body. Stores a shape (in local space centered at the body
/// origin) plus kinematic state. The shape's world position is derived from
/// `position` each step.
pub(all) struct RigidBody {
  /// Body id, assigned by the World. Used by broadphase.
  id : Int
  /// Static or dynamic.
  mut body_type : BodyType
  /// World-space position of the body origin.
  mut position : Vec2
  /// Orientation in radians.
  mut angle : Double
  /// Linear velocity (units / second).
  mut velocity : Vec2
  /// Angular velocity (radians / second).
  mut angular_velocity : Double
  /// Accumulated force to apply during the next step (cleared each step).
  mut force : Vec2
  /// Accumulated torque (cleared each step).
  mut torque : Double
  /// Mass (>= 0). Static bodies use 0 internally and infinite mass in math.
  mut mass : Double
  /// Inverse mass (1/mass). 0 for static.
  mut inv_mass : Double
  /// Moment of inertia about the center.
  mut inertia : Double
  /// Inverse inertia.
  mut inv_inertia : Double
  /// Coefficient of restitution (bounciness). 0 = no bounce, 1 = perfect.
  mut restitution : Double
  /// Linear damping per second (0 = none, ~0.1 typical).
  mut linear_damping : Double
  /// The local-space shape, centered at origin.
  shape : Shape
  /// Cached world-space AABB, updated by `update_aabb`.
  mut aabb : AABB
  /// Whether gravity applies to this body.
  mut gravity_scale : Double
}

///|
/// Body construction parameters.
pub(all) struct BodyDef {
  body_type : BodyType
  position : Vec2
  angle : Double
  shape : Shape
  mass : Double
  restitution : Double
  linear_damping : Double
  gravity_scale : Double
}

///|
/// Construct a dynamic body definition.
pub fn BodyDef::dynamic(
  position : Vec2,
  shape : Shape,
  mass : Double,
  restitution : Double,
) -> BodyDef {
  {
    body_type: BodyType::Dynamic,
    position,
    angle: 0.0,
    shape,
    mass,
    restitution,
    linear_damping: 0.1,
    gravity_scale: 1.0,
  }
}

///|
/// Construct a static body definition.
pub fn BodyDef::static_(position : Vec2, shape : Shape) -> BodyDef {
  {
    body_type: BodyType::Static,
    position,
    angle: 0.0,
    shape,
    mass: 0.0,
    restitution: 0.0,
    linear_damping: 0.0,
    gravity_scale: 0.0,
  }
}

///|
/// Construct a body from a definition.
pub fn RigidBody::from_def(id : Int, def : BodyDef) -> RigidBody {
  let (mass, inv_mass) = match def.body_type {
    BodyType::Static => (0.0, 0.0)
    BodyType::Dynamic => {
      let m = if def.mass > 0.0 { def.mass } else { 1.0 }
      (m, 1.0 / m)
    }
  }
  let (inertia, inv_inertia) = match def.body_type {
    BodyType::Static => (0.0, 0.0)
    BodyType::Dynamic => {
      let i = compute_inertia(def.shape, mass)
      if i > 0.0 {
        (i, 1.0 / i)
      } else {
        (0.0, 0.0)
      }
    }
  }
  let body = {
    id,
    body_type: def.body_type,
    position: def.position,
    angle: def.angle,
    velocity: Vec2::zero(),
    angular_velocity: 0.0,
    force: Vec2::zero(),
    torque: 0.0,
    mass,
    inv_mass,
    inertia,
    inv_inertia,
    restitution: def.restitution,
    linear_damping: def.linear_damping,
    shape: def.shape,
    aabb: AABB::new(Vec2::zero(), Vec2::zero()),
    gravity_scale: def.gravity_scale,
  }
  body.update_aabb()
  body
}

///|
/// Estimate moment of inertia for a shape about its center.
fn compute_inertia(shape : Shape, mass : Double) -> Double {
  match shape {
    Shape::Circle(c) => 0.5 * mass * c.radius * c.radius
    Shape::AABB(b) => {
      let w = b.width()
      let h = b.height()
      mass * (w * w + h * h) / 12.0
    }
    Shape::Polygon(p) =>
      // Polygon inertia via the standard formula.
      polygon_inertia(p, mass)
  }
}

///|
fn polygon_inertia(p : Polygon, mass : Double) -> Double {
  let n = p.vertices.length()
  if n < 3 {
    return 0.0
  }
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i = 0; i < n; i = i + 1 {
    let a = p.vertices[i]
    let b = p.vertices[(i + 1) % n]
    let cross = a.cross(b).abs()
    numerator += cross * (a.dot(a) + a.dot(b) + b.dot(b))
    denominator += cross
  }
  if denominator == 0.0 {
    return 0.0
  }
  mass * numerator / (6.0 * denominator)
}

///|
/// Update the cached world AABB from the current position and orientation.
pub fn RigidBody::update_aabb(self : RigidBody) -> Unit {
  let world_shape = self.world_shape()
  self.aabb = world_shape.aabb()
}

///|
/// Build the shape in world space (applying position and orientation).
pub fn RigidBody::world_shape(self : RigidBody) -> Shape {
  match self.shape {
    Shape::AABB(b) =>
      Shape::AABB(AABB::new(b.center.add(self.position), b.half))
    Shape::Circle(c) =>
      Shape::Circle(Circle::new(c.center.add(self.position), c.radius))
    Shape::Polygon(p) => {
      let n = p.vertices.length()
      let verts : Array[Vec2] = []
      for i = 0; i < n; i = i + 1 {
        let v = p.vertices[i]
        let rotated = v.rotate(self.angle)
        verts.push(rotated.add(self.position))
      }
      Shape::Polygon(Polygon::from_vertices_ccw(verts))
    }
  }
}

///|
/// Apply a force at the body center (accumulates; cleared each step).
pub fn RigidBody::apply_force(self : RigidBody, f : Vec2) -> Unit {
  self.force = self.force.add(f)
}

///|
/// Apply an impulse at the center (immediately changes velocity).
pub fn RigidBody::apply_linear_impulse(
  self : RigidBody,
  impulse : Vec2,
) -> Unit {
  if self.inv_mass == 0.0 {
    return
  }
  self.velocity = self.velocity.add(impulse.scale(self.inv_mass))
}

///|
/// Is this body static (immovable)?
pub fn RigidBody::is_static(self : RigidBody) -> Bool {
  match self.body_type {
    BodyType::Static => true
    BodyType::Dynamic => false
  }
}
