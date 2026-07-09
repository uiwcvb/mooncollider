///|
/// Stacking demo: a column of boxes falls under gravity and settles into a
/// stack on a static floor. Prints each box's height over time. Run with
/// `moon run cmd/stacking`.
fn main {
  let world = @mooncollider.World::new()
  // Static floor.
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
  // A column of 5 dynamic boxes.
  let mut i = 0
  while i < 5 {
    let def = @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 1.0 + i.to_double() * 1.05),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::new(
          @mooncollider.Vec2::zero(),
          @mooncollider.Vec2::new(0.5, 0.5),
        ),
      ),
      1.0,
      0.0,
    )
    def.friction = 0.6
    let _ = world.add_body(def)
    i = i + 1
  }
  println("MoonCollider stacking demo")
  println("step, box0_y, box1_y, box2_y, box3_y, box4_y")
  let dt = 0.016
  let mut step = 0
  while step < 400 {
    world.step(dt)
    if step % 20 == 0 {
      let b0 = world.body(1).position.y
      let b1 = world.body(2).position.y
      let b2 = world.body(3).position.y
      let b3 = world.body(4).position.y
      let b4 = world.body(5).position.y
      println("\{step}, \{b0}, \{b1}, \{b2}, \{b3}, \{b4}")
    }
    step = step + 1
  }
  println("done")
}
