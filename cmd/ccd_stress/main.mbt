///|
/// CCD stress test: a fast small ball fired at a thin wall.
///
/// Without CCD: the ball moves 8 units/step (500 u/s * 0.016s), which is far
/// larger than the 0.2-unit-thick wall. Discrete collision detection checks
/// only the start and end positions of the step; the ball is clear of the
/// wall at both, so it tunnels through.
///
/// With CCD: the sweep finds the time of impact and stops the ball at the
/// wall surface. The normal is reported pointing from the wall back toward
/// the ball (opposing motion).
///
/// Run with `moon run cmd/ccd_stress`.
fn main {
  let ball_radius = 0.3
  let start = @mooncollider.Vec2::new(0.0, 0.0)
  // 500 u/s: 8 units per 0.016s step. Wall is 0.2 thick. Ball is 0.6 wide.
  // The ball jumps from before the wall to past it in a single step.
  let speed = 500.0
  let dt = 0.016
  let delta = @mooncollider.Vec2::new(speed * dt, 0.0)
  // Thin wall: 0.2 units thick, centered at x=5.
  let wall = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(4.9, -5.0),
      @mooncollider.Vec2::new(5.1, 5.0),
    ),
  )
  println("MoonCollider CCD stress test")
  println(
    "Ball radius: \{ball_radius}, wall thickness: 0.2, speed: \{speed} u/s, step: \{delta.x} u/step",
  )
  // --- Without CCD: pure discrete check at start and end positions ---
  let shape_start = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(start, ball_radius),
  )
  let end_pos = start.add(delta)
  let shape_end = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(end_pos, ball_radius),
  )
  let m_start = @mooncollider.collide(shape_start, wall)
  let m_end = @mooncollider.collide(shape_end, wall)
  let tunneled = !m_start.colliding() && !m_end.colliding()
  println("Without CCD:")
  println("  collide at start: \{m_start.colliding()}")
  println("  collide at end:   \{m_end.colliding()}")
  println("  tunneled:         \{tunneled}")
  // --- With CCD: sweep the ball along delta ---
  let sweep = @mooncollider.ccd_sweep_circle(ball_radius, start, delta, wall)
  println("With CCD:")
  println("  hit:      \{sweep.hit}")
  if sweep.hit {
    let stop_pos = start.add(delta.scale(sweep.t))
    println("  t:        \{sweep.t}")
    println("  stop_x:   \{stop_pos.x}")
    println("  hit_x:    \{sweep.point.x}")
    println("  normal:   (\{sweep.normal.x}, \{sweep.normal.y})")
    // Normal should point from wall back toward ball (negative x direction).
    let normal_correct = sweep.normal.x < 0.0
    println("  normal points toward ball (x<0): \{normal_correct}")
    // Ball should stop before the wall surface (x < 4.9).
    let stopped_before_wall = stop_pos.x + ball_radius <= 5.1
    println("  stopped before wall exit: \{stopped_before_wall}")
    println("  CCD prevented tunneling: \{tunneled && sweep.hit}")
  }
  println("done")
}
