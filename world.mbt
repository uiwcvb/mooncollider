///|
/// The physics world. Owns bodies, applies gravity, integrates, runs
/// broadphase + narrowphase, and resolves collisions.
pub(all) struct World {
  /// Gravity vector (units / second^2). Default: (0, -9.81).
  mut gravity : Vec2
  /// All bodies, indexed by body id (which equals array position).
  bodies : Array[RigidBody]
  /// Persistent joint constraints, solved each step.
  joints : Array[Joint]
  /// Broadphase grid cell size. Bodies larger than this still work but may
  /// be reported in many cells.
  mut grid_cell_size : Double
  /// Velocity iterations for constraint solving.
  mut velocity_iterations : Int
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
    joints: [],
    grid_cell_size: 2.0,
    velocity_iterations: 12,
    position_correction: 0.4,
    slop: 0.005,
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
/// Remove a body by id (marks it as inactive). The body slot is reused
/// for future additions to keep id stability.
pub fn World::remove_body(self : World, id : Int) -> Unit {
  if id >= 0 && id < self.bodies.length() {
    self.bodies[id].alive = false
  }
}

///|
/// Add a joint to the world.
pub fn World::add_joint(self : World, joint : Joint) -> Unit {
  self.joints.push(joint)
}

///|
/// Number of joints.
pub fn World::joint_count(self : World) -> Int {
  self.joints.length()
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
    if b.is_static() || !b.alive {
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
  // 2. Broadphase.
  let grid = GridHash::new(self.grid_cell_size)
  for i = 0; i < self.bodies.length(); i = i + 1 {
    if self.bodies[i].alive {
      grid.insert(i, self.bodies[i].aabb)
    }
  }
  let pairs = grid.pairs()
  // 3. Narrowphase: build contact constraints.
  let contacts : Array[Contact] = []
  for k = 0; k < pairs.length(); k = k + 1 {
    let (a_id, b_id) = pairs[k]
    let a = self.bodies[a_id]
    let b = self.bodies[b_id]
    if !a.alive || !b.alive {
      continue
    }
    let sa = a.world_shape()
    let sb = b.world_shape()
    let m = collide(sa, sb)
    if m.colliding() {
      contacts.push(make_contact(a, b, m, m.contact))
      if m.has_second_contact() {
        contacts.push(make_contact(a, b, m, m.contact2))
      }
    }
  }
  // 4. Sequential-impulse velocity solving: iterate `velocity_iterations`
  //    times, applying normal + friction impulses to each contact. Multiple
  //    iterations propagate constraints through contact islands and
  //    dramatically improve stacking stability.
  let iters = if self.velocity_iterations > 0 {
    self.velocity_iterations
  } else {
    1
  }
  for _iter = 0; _iter < iters; _iter = _iter + 1 {
    for ci = 0; ci < contacts.length(); ci = ci + 1 {
      self.solve_contact(contacts[ci])
    }
    // Solve joint constraints alongside contacts.
    for ji = 0; ji < self.joints.length(); ji = ji + 1 {
      solve_joint(self.joints[ji], self.bodies)
    }
  }
  // 5. Integrate velocities -> positions.
  for i = 0; i < self.bodies.length(); i = i + 1 {
    let b = self.bodies[i]
    if b.is_static() || !b.alive {
      continue
    }
    // AABB shapes don't support rotation; zero angular velocity to avoid
    // friction impulses inducing phantom rotation that destabilizes stacks.
    match b.shape {
      Shape::AABB(_) => b.angular_velocity = 0.0
      _ => ()
    }
    b.position = b.position.add(b.velocity.scale(dt))
    b.angle = b.angle + b.angular_velocity * dt
    b.update_aabb()
  }
  // 6. Positional correction (Baumgarte) — multiple iterations for stable
  //    stacking. Each pass re-checks penetration and pushes bodies apart.
  let pos_iters = 4
  for _pi = 0; _pi < pos_iters; _pi = _pi + 1 {
    for ci = 0; ci < contacts.length(); ci = ci + 1 {
      self.positional_correct_contact(contacts[ci])
    }
  }
}

///|
/// Build a contact constraint from a manifold and a specific contact point.
fn make_contact(
  a : RigidBody,
  b : RigidBody,
  m : Manifold,
  point : Vec2,
) -> Contact {
  {
    a,
    b,
    normal: m.normal,
    contact_point: point,
    restitution: if a.restitution < b.restitution {
      a.restitution
    } else {
      b.restitution
    },
    friction: (a.friction * a.friction + b.friction * b.friction).sqrt(),
  }
}

///|
/// A resolved contact constraint used by the sequential-impulse solver.
priv struct Contact {
  a : RigidBody
  b : RigidBody
  normal : Vec2
  contact_point : Vec2
  restitution : Double
  friction : Double
}

///|
/// One velocity-solving iteration for a single contact: normal impulse then
/// Coulomb friction impulse.
fn World::solve_contact(self : World, c : Contact) -> Unit {
  ignore(self)
  let a = c.a
  let b = c.b
  let ra = c.contact_point.sub(a.position)
  let rb = c.contact_point.sub(b.position)
  // Relative velocity at contact.
  let va = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv = vb.sub(va)
  let vel_along_normal = rv.dot(c.normal)
  // Only resolve approaching contacts.
  if vel_along_normal > 0.0 {
    return
  }
  let ra_cross_n = ra.cross(c.normal)
  let rb_cross_n = rb.cross(c.normal)
  let inv_mass_sum = a.inv_mass +
    b.inv_mass +
    ra_cross_n * ra_cross_n * a.inv_inertia +
    rb_cross_n * rb_cross_n * b.inv_inertia
  if inv_mass_sum == 0.0 {
    return
  }
  let j = -(1.0 + c.restitution) * vel_along_normal / inv_mass_sum
  let impulse = c.normal.scale(j)
  if !a.is_static() {
    a.velocity = a.velocity.sub(impulse.scale(a.inv_mass))
    a.angular_velocity = a.angular_velocity - ra.cross(impulse) * a.inv_inertia
  }
  if !b.is_static() {
    b.velocity = b.velocity.add(impulse.scale(b.inv_mass))
    b.angular_velocity = b.angular_velocity + rb.cross(impulse) * b.inv_inertia
  }
  // --- Friction (Coulomb): tangential impulse clamped by mu * |j|. ---
  let va2 = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb2 = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv2 = vb2.sub(va2)
  let tangent = rv2.sub(c.normal.scale(rv2.dot(c.normal)))
  let tangent_len = tangent.length()
  if tangent_len < 1.0e-9 {
    return
  }
  let tangent_dir = tangent.scale(1.0 / tangent_len)
  let ra_cross_t = ra.cross(tangent_dir)
  let rb_cross_t = rb.cross(tangent_dir)
  let inv_mass_sum_t = a.inv_mass +
    b.inv_mass +
    ra_cross_t * ra_cross_t * a.inv_inertia +
    rb_cross_t * rb_cross_t * b.inv_inertia
  if inv_mass_sum_t == 0.0 {
    return
  }
  let mut jt = -rv2.dot(tangent_dir) / inv_mass_sum_t
  // Coulomb clamp.
  let max_friction = j.abs() * c.friction
  if jt.abs() > max_friction {
    jt = if jt > 0.0 { max_friction } else { -max_friction }
  }
  let friction_impulse = tangent_dir.scale(jt)
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
/// Baumgarte positional correction for a contact. Re-evaluates penetration
/// from current body positions so multiple iterations converge.
fn World::positional_correct_contact(self : World, c : Contact) -> Unit {
  // Re-compute penetration from current positions.
  let sa = c.a.world_shape()
  let sb = c.b.world_shape()
  let m = collide(sa, sb)
  if !m.colliding() {
    return
  }
  let inv_sum = c.a.inv_mass + c.b.inv_mass
  if inv_sum == 0.0 {
    return
  }
  let correction = (m.depth - self.slop).max(0.0) /
    inv_sum *
    self.position_correction
  let delta = m.normal.scale(correction)
  if !c.a.is_static() {
    c.a.position = c.a.position.sub(delta.scale(c.a.inv_mass))
    c.a.update_aabb()
  }
  if !c.b.is_static() {
    c.b.position = c.b.position.add(delta.scale(c.b.inv_mass))
    c.b.update_aabb()
  }
}
