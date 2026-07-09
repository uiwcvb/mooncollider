///|
/// Pendulum demo: a dynamic bob connected to a static anchor by a distance
/// joint, swinging under gravity. Prints the bob's position over time.
/// Run with `moon run cmd/pendulum`.
fn main {
  let world = @mooncollider.World::new()
  // Static anchor at the top.
  let _ = world.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 5.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.1),
      ),
    ),
  )
  // Dynamic bob, offset to the right so it starts swinging.
  let _ = world.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(3.0, 5.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.3),
      ),
      1.0,
      0.0,
    ),
  )
  // Distance joint keeping the bob on a 3-unit tether.
  let dj = @mooncollider.DistanceJoint::from_world(
    world,
    0,
    1,
    @mooncollider.Vec2::new(0.0, 5.0),
    @mooncollider.Vec2::new(3.0, 5.0),
  )
  world.add_joint(@mooncollider.Joint::distance(dj))
  println("MoonCollider pendulum demo")
  println("step, x, y, dist_from_anchor")
  let dt = 0.016
  let mut step = 0
  while step < 300 {
    world.step(dt)
    if step % 20 == 0 {
      let bob = world.body(1)
      let d = bob.position.sub(@mooncollider.Vec2::new(0.0, 5.0)).length()
      println("\{step}, \{bob.position.x}, \{bob.position.y}, \{d}")
    }
    step = step + 1
  }
  println("done")
}
