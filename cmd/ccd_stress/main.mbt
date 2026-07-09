///|
/// CCD stress test: a fast small ball fired at a thin wall. Without CCD the
/// ball tunnels through; with CCD the collision is caught. Prints the
/// penetration depth with and without CCD. Run with `moon run cmd/ccd_stress`.
fn main {
  // Wall: 1 unit thick, centered at x=5.
  let wall = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(4.5, -5.0),
    @mooncollider.Vec2::new(5.5, 5.0),
  )
  let ball_radius = 0.3
  let start = @mooncollider.Vec2::new(0.0, 0.0)
  // High velocity: 100 units/sec, dt=0.016 -> 1.6 units/step. The ball is
  // 0.6 wide and the wall is 1.0 thick, so discrete collision can tunnel.
  let velocity = @mooncollider.Vec2::new(100.0, 0.0)
  let dt = 0.016
  println("MoonCollider CCD stress test")
  println(
    "Ball radius: \{ball_radius}, wall thickness: 1.0, velocity: \{velocity.x} u/s, dt: \{dt}",
  )
  // --- Without CCD: discrete stepping, check final position ---
  let world = @mooncollider.World::new()
  let _ = world.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_aabb(wall),
    ),
  )
  let ball_def = @mooncollider.BodyDef::dynamic(
    start,
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::zero(), ball_radius),
    ),
    1.0,
    0.0,
  )
  let ball_id = world.add_body(ball_def)
  world.body(ball_id).velocity = velocity
  let mut step = 0
  let mut tunneled = false
  while step < 60 {
    world.step(dt)
    let p = world.body(ball_id).position
    // If the ball passed the far side of the wall without stopping, it tunneled.
    if p.x > 5.5 + ball_radius {
      tunneled = true
    }
    step = step + 1
  }
  let final_no_ccd = world.body(ball_id).position
  println("Without CCD: final_x=\{final_no_ccd.x}, tunneled=\{tunneled}")
  // --- With CCD: sweep before stepping ---
  let world2 = @mooncollider.World::new()
  let _ = world2.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_aabb(wall),
    ),
  )
  let ball_def2 = @mooncollider.BodyDef::dynamic(
    start,
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::zero(), ball_radius),
    ),
    1.0,
    0.0,
  )
  let ball_id2 = world2.add_body(ball_def2)
  world2.body(ball_id2).velocity = velocity
  let mut step2 = 0
  let mut ccd_stopped = false
  while step2 < 60 {
    // CCD: sweep the ball along its velocity this step.
    let b = world2.body(ball_id2)
    let delta = b.velocity.scale(dt)
    let sweep = @mooncollider.ccd_sweep_circle(
      ball_radius,
      b.position,
      delta,
      @mooncollider.Shape::from_aabb(wall),
    )
    if sweep.hit {
      // Move to the hit point and zero the normal velocity.
      b.position = b.position.add(delta.scale(sweep.t))
      b.velocity = @mooncollider.Vec2::zero()
      ccd_stopped = true
    } else {
      world2.step(dt)
    }
    step2 = step2 + 1
  }
  let final_ccd = world2.body(ball_id2).position
  println("With CCD: final_x=\{final_ccd.x}, stopped=\{ccd_stopped}")
  println(
    "CCD prevented tunneling: \{if final_ccd.x < 5.5 { "yes" } else { "no" }}",
  )
  println("done")
}
