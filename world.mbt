///|
/// The physics world. Owns bodies, applies gravity, integrates, runs
/// broadphase + narrowphase, and resolves collisions.
pub(all) struct World {
  /// Gravity vector (units / second^2). Default: (0, -9.81).
  mut gravity : Vec2
  /// All bodies, indexed by body id (which equals array position).
  bodies : Array[RigidBody]
  /// Broadphase grid cell size. Bodies larger than this still work but may
  /// be reported in many cells.
  mut grid_cell_size : Double
  /// Velocity iterations for constraint solving.
  velocity_iterations : Int
  /// Position correction factor (Baumgarte). 0 = none, ~0.2 typical.
  position_correction : Double
  /// Slop: allowed penetration to avoid jitter.
  slop : Double
}

///|
/// Construct an empty world with sensible defaults.
pub fn World::new() -> World {
  {
    gravity: Vec2::new(0.0, -9.81),
    bodies: [],
    grid_cell_size: 2.0,
    velocity_iterations: 8,
    position_correction: 0.2,
    slop: 0.01,
  }
}

///|
/// Set the gravity vector.
pub fn World::set_gravity(self : World, g : Vec2) -> Unit {
  self.gravity = g
}

///|
/// Set the broadphase grid cell size.
pub fn World::set_grid_cell_size(self : World, s : Double) -> Unit {
  self.grid_cell_size = s
}

///|
/// Add a body to the world. Returns the body id.
pub fn World::add_body(self : World, def : BodyDef) -> Int {
  let id = self.bodies.length()
  let body = RigidBody::from_def(id, def)
  self.bodies.push(body)
  id
}

///|
/// Get a body by id.
pub fn World::body(self : World, id : Int) -> RigidBody {
  self.bodies[id]
}

///|
/// Number of bodies.
pub fn World::body_count(self : World) -> Int {
  self.bodies.length()
}

///|
/// Advance the simulation by `dt` seconds.
pub fn World::step(self : World, dt : Double) -> Unit {
  if dt <= 0.0 {
    return
  }
  // 1. Integrate forces -> velocities.
  for i = 0; i < self.bodies.length(); i = i + 1 {
    let b = self.bodies[i]
    if b.is_static() {
      continue
    }
    // Apply gravity.
    b.velocity = b.velocity.add(self.gravity.scale(b.gravity_scale * dt))
    // Apply accumulated force.
    b.velocity = b.velocity.add(b.force.scale(b.inv_mass * dt))
    b.angular_velocity = b.angular_velocity + b.inv_inertia * b.torque * dt
    // Damping.
    let damp = (1.0 - b.linear_damping * dt).max(0.0)
    b.velocity = b.velocity.scale(damp)
    let adamp = (1.0 - b.angular_damping * dt).max(0.0)
    b.angular_velocity = b.angular_velocity * adamp
    // Clear accumulators.
    b.force = Vec2::zero()
    b.torque = 0.0
  }
  // 2. Integrate velocities -> positions.
  for i = 0; i < self.bodies.length(); i = i + 1 {
    let b = self.bodies[i]
    if b.is_static() {
      continue
    }
    b.position = b.position.add(b.velocity.scale(dt))
    b.angle = b.angle + b.angular_velocity * dt
    b.update_aabb()
  }
  // 3. Broadphase.
  let grid = GridHash::new(self.grid_cell_size)
  for i = 0; i < self.bodies.length(); i = i + 1 {
    grid.insert(i, self.bodies[i].aabb)
  }
  let pairs = grid.pairs()
  // 4. Narrowphase + resolve.
  for k = 0; k < pairs.length(); k = k + 1 {
    let (a_id, b_id) = pairs[k]
    let a = self.bodies[a_id]
    let b = self.bodies[b_id]
    let sa = a.world_shape()
    let sb = b.world_shape()
    let m = collide(sa, sb)
    if m.colliding() {
      self.resolve(a, b, m)
    }
  }
}

///|
/// Resolve a collision between two bodies given a manifold (normal from a
/// to b).
fn World::resolve(
  self : World,
  a : RigidBody,
  b : RigidBody,
  m : Manifold,
) -> Unit {
  // Positional correction (Baumgarte) to reduce sinking.
  let correction = self.positional_correction(a, b, m.normal, m.depth)
  if !a.is_static() {
    a.position = a.position.sub(correction.scale(a.inv_mass))
    a.update_aabb()
  }
  if !b.is_static() {
    b.position = b.position.add(correction.scale(b.inv_mass))
    b.update_aabb()
  }
  // Velocity resolution.
  let ra = m.contact.sub(a.position)
  let rb = m.contact.sub(b.position)
  // Relative velocity at contact.
  let va = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv = vb.sub(va)
  let vel_along_normal = rv.dot(m.normal)
  // Do not resolve if bodies are separating.
  if vel_along_normal > 0.0 {
    return
  }
  let e = if a.restitution < b.restitution {
    a.restitution
  } else {
    b.restitution
  }
  let ra_cross_n = ra.cross(m.normal)
  let rb_cross_n = rb.cross(m.normal)
  let inv_mass_sum = a.inv_mass +
    b.inv_mass +
    ra_cross_n * ra_cross_n * a.inv_inertia +
    rb_cross_n * rb_cross_n * b.inv_inertia
  if inv_mass_sum == 0.0 {
    return
  }
  let j = -(1.0 + e) * vel_along_normal / inv_mass_sum
  let impulse = m.normal.scale(j)
  if !a.is_static() {
    a.velocity = a.velocity.sub(impulse.scale(a.inv_mass))
    a.angular_velocity = a.angular_velocity - ra.cross(impulse) * a.inv_inertia
  }
  if !b.is_static() {
    b.velocity = b.velocity.add(impulse.scale(b.inv_mass))
    b.angular_velocity = b.angular_velocity + rb.cross(impulse) * b.inv_inertia
  }
  // --- Friction (Coulomb model): tangential impulse, clamped by mu * |j|. ---
  // Recompute relative velocity after the normal impulse.
  let va2 = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb2 = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv2 = vb2.sub(va2)
  // Tangent direction (perpendicular to normal), in the direction of the
  // tangential relative velocity.
  let tangent = rv2.sub(m.normal.scale(rv2.dot(m.normal))).normalize()
  let ra_cross_t = ra.cross(tangent)
  let rb_cross_t = rb.cross(tangent)
  let inv_mass_sum_t = a.inv_mass +
    b.inv_mass +
    ra_cross_t * ra_cross_t * a.inv_inertia +
    rb_cross_t * rb_cross_t * b.inv_inertia
  if inv_mass_sum_t == 0.0 {
    return
  }
  let mut jt = -rv2.dot(tangent) / inv_mass_sum_t
  // Coulomb friction clamp.
  let mu = (a.friction * a.friction + b.friction * b.friction).sqrt()
  if jt.abs() > j * mu {
    jt = if jt > 0.0 { j * mu } else { -j * mu }
  }
  let friction_impulse = tangent.scale(jt)
  if !a.is_static() {
    a.velocity = a.velocity.sub(friction_impulse.scale(a.inv_mass))
    a.angular_velocity = a.angular_velocity -
      ra.cross(friction_impulse) * a.inv_inertia
  }
  if !b.is_static() {
    b.velocity = b.velocity.add(friction_impulse.scale(b.inv_mass))
    b.angular_velocity = b.angular_velocity +
      rb.cross(friction_impulse) * b.inv_inertia
  }
}

///|
/// Baumgarte positional correction.
fn World::positional_correction(
  self : World,
  a : RigidBody,
  b : RigidBody,
  normal : Vec2,
  depth : Double,
) -> Vec2 {
  let inv_sum = a.inv_mass + b.inv_mass
  if inv_sum == 0.0 {
    return Vec2::zero()
  }
  let percent = self.position_correction
  let slop = self.slop
  let correction = (depth - slop).max(0.0) / inv_sum * percent
  normal.scale(correction)
}
