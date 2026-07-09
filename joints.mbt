///|
/// Joint constraints. Unlike contacts (which are discovered each step), joints
/// are persistent constraints between two bodies created explicitly by the
/// user. The world solves them each step alongside contacts.
///
/// Three joint kinds are provided:
/// - `Distance` — keeps two anchor points a fixed distance apart (a rod).
/// - `Revolute` — pins two anchor points together (a hinge).
/// - `Weld` — locks relative position and angle (rigid glue).

///|
pub enum Joint {
  /// Distance constraint: |anchorB - anchorA| == length.
  Distance(DistanceJoint)
  /// Revolute (pin) joint: anchorA and anchorB coincide.
  Revolute(RevoluteJoint)
  /// Weld joint: locks relative position and angle.
  Weld(WeldJoint)
}

///|
pub(all) struct DistanceJoint {
  /// Body A id.
  a : Int
  /// Body B id.
  b : Int
  /// Local-space anchor on A (relative to A's origin).
  local_anchor_a : Vec2
  /// Local-space anchor on B (relative to B's origin).
  local_anchor_b : Vec2
  /// Rest length.
  length : Double
  /// Constraint stiffness (0 = rigid, higher = softer). Use ~1 for stiff.
  stiffness : Double
}

///|
pub(all) struct RevoluteJoint {
  /// Body A id.
  a : Int
  /// Body B id.
  b : Int
  /// Local-space anchor on A.
  local_anchor_a : Vec2
  /// Local-space anchor on B.
  local_anchor_b : Vec2
}

///|
pub(all) struct WeldJoint {
  /// Body A id.
  a : Int
  /// Body B id.
  b : Int
  /// Local-space anchor on A.
  local_anchor_a : Vec2
  /// Local-space anchor on B.
  local_anchor_b : Vec2
  /// Reference angle: initial relative orientation to maintain.
  ref_angle : Double
}

///|
/// Wrap a distance joint into a `Joint`.
pub fn Joint::distance(j : DistanceJoint) -> Joint {
  Joint::Distance(j)
}

///|
/// Wrap a revolute joint into a `Joint`.
pub fn Joint::revolute(j : RevoluteJoint) -> Joint {
  Joint::Revolute(j)
}

///|
/// Wrap a weld joint into a `Joint`.
pub fn Joint::weld(j : WeldJoint) -> Joint {
  Joint::Weld(j)
}

///|
/// Construct a distance joint between two bodies. The anchors are given in
/// world space and converted to local space automatically.
pub fn DistanceJoint::from_world(
  world : World,
  a : Int,
  b : Int,
  world_anchor_a : Vec2,
  world_anchor_b : Vec2,
  length? : Double,
) -> DistanceJoint {
  let ba = world.body(a)
  let bb = world.body(b)
  let la = world_anchor_a.sub(ba.position)
  let lb = world_anchor_b.sub(bb.position)
  let len = match length {
    Some(l) => l
    None => world_anchor_b.sub(world_anchor_a).length()
  }
  { a, b, local_anchor_a: la, local_anchor_b: lb, length: len, stiffness: 1.0 }
}

///|
/// Construct a revolute joint pinning two bodies at a world-space point.
pub fn RevoluteJoint::from_world(
  world : World,
  a : Int,
  b : Int,
  world_anchor : Vec2,
) -> RevoluteJoint {
  let la = world_anchor.sub(world.body(a).position)
  let lb = world_anchor.sub(world.body(b).position)
  { a, b, local_anchor_a: la, local_anchor_b: lb }
}

///|
/// Construct a weld joint between two bodies at a world-space point.
pub fn WeldJoint::from_world(
  world : World,
  a : Int,
  b : Int,
  world_anchor : Vec2,
) -> WeldJoint {
  let ba = world.body(a)
  let bb = world.body(b)
  let la = world_anchor.sub(ba.position)
  let lb = world_anchor.sub(bb.position)
  {
    a,
    b,
    local_anchor_a: la,
    local_anchor_b: lb,
    ref_angle: bb.angle - ba.angle,
  }
}

///|
/// Convert a local anchor to world space for a body.
fn world_anchor(body : RigidBody, local_anchor : Vec2) -> Vec2 {
  body.position.add(local_anchor.rotate(body.angle))
}

///|
/// Solve a joint constraint for one iteration (velocity-level).
fn solve_joint(joint : Joint, bodies : Array[RigidBody]) -> Unit {
  match joint {
    Joint::Distance(j) => solve_distance(j, bodies)
    Joint::Revolute(j) => solve_revolute(j, bodies)
    Joint::Weld(j) => solve_weld(j, bodies)
  }
}

///|
/// Distance constraint: project the relative anchor velocity onto the anchor
/// separation axis and remove it (plus a position-bias term for drift).
fn solve_distance(j : DistanceJoint, bodies : Array[RigidBody]) -> Unit {
  let a = bodies[j.a]
  let b = bodies[j.b]
  if a.inv_mass + b.inv_mass == 0.0 {
    return
  }
  let pa = world_anchor(a, j.local_anchor_a)
  let pb = world_anchor(b, j.local_anchor_b)
  let delta = pb.sub(pa)
  let dist = delta.length()
  if dist < 1.0e-9 {
    return
  }
  let n = delta.scale(1.0 / dist)
  // Velocity of anchor points.
  let ra = pa.sub(a.position)
  let rb = pb.sub(b.position)
  let va = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv = vb.sub(va)
  let c = dist - j.length
  // Soft Baumgarte bias: gently correct drift. The gain must be low enough
  // to avoid energy injection that destabilizes the solver.
  let bias = -0.1 * c * j.stiffness
  let ra_cross_n = ra.cross(n)
  let rb_cross_n = rb.cross(n)
  let inv_mass_sum = a.inv_mass +
    b.inv_mass +
    ra_cross_n * ra_cross_n * a.inv_inertia +
    rb_cross_n * rb_cross_n * b.inv_inertia
  if inv_mass_sum == 0.0 {
    return
  }
  let lambda = -(rv.dot(n) + bias) / inv_mass_sum
  let impulse = n.scale(lambda)
  if !a.is_static() {
    a.velocity = a.velocity.sub(impulse.scale(a.inv_mass))
    a.angular_velocity = a.angular_velocity - ra.cross(impulse) * a.inv_inertia
  }
  if !b.is_static() {
    b.velocity = b.velocity.add(impulse.scale(b.inv_mass))
    b.angular_velocity = b.angular_velocity + rb.cross(impulse) * b.inv_inertia
  }
}

///|
/// Revolute (pin) constraint: drive the relative anchor velocity to zero on
/// both axes.
fn solve_revolute(j : RevoluteJoint, bodies : Array[RigidBody]) -> Unit {
  let a = bodies[j.a]
  let b = bodies[j.b]
  if a.inv_mass + b.inv_mass == 0.0 {
    return
  }
  let pa = world_anchor(a, j.local_anchor_a)
  let pb = world_anchor(b, j.local_anchor_b)
  let ra = pa.sub(a.position)
  let rb = pb.sub(b.position)
  let va = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv = vb.sub(va)
  // Soft Baumgarte position bias on the anchor separation.
  let bias = pb.sub(pa).scale(0.1)
  // Solve along x and y independently (2x2 diagonal mass approximation).
  // x axis
  solve_revolute_axis(a, b, ra, rb, rv.x + bias.x, Vec2::new(1.0, 0.0))
  // recompute rv after x
  let va2 = a.velocity.add(
    Vec2::new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x),
  )
  let vb2 = b.velocity.add(
    Vec2::new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x),
  )
  let rv2 = vb2.sub(va2)
  solve_revolute_axis(a, b, ra, rb, rv2.y + bias.y, Vec2::new(0.0, 1.0))
}

///|
fn solve_revolute_axis(
  a : RigidBody,
  b : RigidBody,
  ra : Vec2,
  rb : Vec2,
  c : Double,
  axis : Vec2,
) -> Unit {
  let ra_cross = ra.cross(axis)
  let rb_cross = rb.cross(axis)
  let inv_mass_sum = a.inv_mass +
    b.inv_mass +
    ra_cross * ra_cross * a.inv_inertia +
    rb_cross * rb_cross * b.inv_inertia
  if inv_mass_sum == 0.0 {
    return
  }
  let lambda = -c / inv_mass_sum
  let impulse = axis.scale(lambda)
  if !a.is_static() {
    a.velocity = a.velocity.sub(impulse.scale(a.inv_mass))
    a.angular_velocity = a.angular_velocity - ra.cross(impulse) * a.inv_inertia
  }
  if !b.is_static() {
    b.velocity = b.velocity.add(impulse.scale(b.inv_mass))
    b.angular_velocity = b.angular_velocity + rb.cross(impulse) * b.inv_inertia
  }
}

///|
/// Weld constraint: revolute + angle lock.
fn solve_weld(j : WeldJoint, bodies : Array[RigidBody]) -> Unit {
  let a = bodies[j.a]
  let b = bodies[j.b]
  if a.inv_mass + b.inv_mass == 0.0 {
    return
  }
  // Position constraint (reuse revolute).
  solve_revolute(
    {
      a: j.a,
      b: j.b,
      local_anchor_a: j.local_anchor_a,
      local_anchor_b: j.local_anchor_b,
    },
    bodies,
  )
  // Angle constraint: drive relative angular velocity toward the ref angle
  // bias.
  let a2 = bodies[j.a]
  let b2 = bodies[j.b]
  let rel_angle = b2.angle - a2.angle - j.ref_angle
  let c = rel_angle * 0.1 + (b2.angular_velocity - a2.angular_velocity)
  let inv_mass_sum = a2.inv_inertia + b2.inv_inertia
  if inv_mass_sum == 0.0 {
    return
  }
  let lambda = -c / inv_mass_sum
  if !a2.is_static() {
    a2.angular_velocity = a2.angular_velocity - lambda * a2.inv_inertia
  }
  if !b2.is_static() {
    b2.angular_velocity = b2.angular_velocity + lambda * b2.inv_inertia
  }
}
