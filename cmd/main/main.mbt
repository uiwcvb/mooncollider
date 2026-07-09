// Demo: a bouncing ball under gravity, simulated step by step. Prints the
// ball's height each step to stdout. Run with `moon run cmd/main`.

///|
fn main {
  let world = @mooncollider.World::new()
  // A dynamic circle (the ball) starting at height 10, perfect bounce.
  let _ball = world.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 10.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.5),
      ),
      1.0,
      0.8,
    ),
  )
  // A static floor.
  let _ = world.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::from_min_max(
          @mooncollider.Vec2::new(-10.0, -1.0),
          @mooncollider.Vec2::new(10.0, 0.0),
        ),
      ),
    ),
  )
  println("MoonCollider bounce demo")
  println("step, y, vy")
  let dt = 0.016
  let mut step = 0
  while step < 200 {
    world.step(dt)
    let body = world.body(0)
    println("\{step}, \{body.position.y}, \{body.velocity.y}")
    step = step + 1
  }
  println("done")
}
