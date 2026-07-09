///|
/// Performance benchmarks for MoonCollider. Run with `moon run cmd/bench`.
/// Measures narrowphase, broadphase, and full world-step throughput.
fn main {
  let bench = @bench.Bench::Bench()
  // --- Narrowphase: 1000 circle-circle collisions ---
  let circles : Array[@mooncollider.Shape] = []
  let mut i = 0
  while i < 1000 {
    let x = i.to_double() * 0.5
    circles.push(
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::new(x, 0.0), 1.0),
      ),
    )
    i = i + 1
  }
  bench.bench(
    name="narrowphase_1000_circle_pairs",
    fn() {
      let mut total = 0
      let mut k = 0
      while k < 999 {
        let m = @mooncollider.collide(circles[k], circles[k + 1])
        if m.colliding() {
          total += 1
        }
        k = k + 1
      }
      ignore(total)
    },
    count=100,
  )
  // --- Broadphase: GridHash with 500 bodies ---
  let grid = @mooncollider.GridHash::new(2.0)
  let mut j = 0
  while j < 500 {
    grid.insert(
      j,
      @mooncollider.AABB::new(
        @mooncollider.Vec2::new(j.to_double() * 0.3, j.to_double() * 0.2),
        @mooncollider.Vec2::new(0.5, 0.5),
      ),
    )
    j = j + 1
  }
  bench.bench(
    name="broadphase_gridhash_500_pairs",
    fn() { ignore(grid.pairs()) },
    count=100,
  )
  // --- World step: 100 bodies ---
  let world = @mooncollider.World::new()
  let _ = world.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::from_min_max(
          @mooncollider.Vec2::new(-50.0, -1.0),
          @mooncollider.Vec2::new(50.0, 0.0),
        ),
      ),
    ),
  )
  let mut b = 0
  while b < 99 {
    let _ = world.add_body(
      @mooncollider.BodyDef::dynamic(
        @mooncollider.Vec2::new(
          b.to_double() * 0.3 - 15.0,
          1.0 + (b % 10).to_double(),
        ),
        @mooncollider.Shape::from_circle(
          @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.3),
        ),
        1.0,
        0.3,
      ),
    )
    b = b + 1
  }
  bench.bench(
    name="world_step_100_bodies",
    fn() { world.step(0.016) },
    count=100,
  )
  println(bench.dump_summaries())
  println("done")
}
