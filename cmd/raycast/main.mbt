///|
/// Raycast demo: casts rays from the origin in several directions and reports
/// the first hit against a small scene of shapes. Run with `moon run cmd/raycast`.
fn main {
  // A box, a circle, and a triangle (polygon), arranged in a row.
  let box = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(2.0, 0.0),
      @mooncollider.Vec2::new(3.0, 1.0),
    ),
  )
  let circle = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(6.0, 0.5), 0.8),
  )
  let triangle = @mooncollider.Shape::from_polygon(
    @mooncollider.Polygon::convex_hull([
      @mooncollider.Vec2::new(9.0, 0.0),
      @mooncollider.Vec2::new(10.0, 0.0),
      @mooncollider.Vec2::new(9.5, 1.5),
    ]),
  )
  let shapes = [box, circle, triangle]
  // Cast 5 rays from the origin at different upward angles.
  let angles = [0.0, 0.1, 0.2, 0.3, 0.5]
  println("MoonCollider raycast demo")
  println("ray_angle, hit_shape, t, point_x, point_y, normal_x, normal_y")
  for i = 0; i < angles.length(); i = i + 1 {
    let a = angles[i]
    let dir = @mooncollider.Vec2::new(@math.cos(a), @math.sin(a))
    let ray = @mooncollider.Ray::new(@mooncollider.Vec2::zero(), dir)
    let mut best_t = 1.0e30
    let mut best_idx = -1
    let mut best_hit = @mooncollider.RaycastHit::new(
      -1.0,
      @mooncollider.Vec2::zero(),
      @mooncollider.Vec2::zero(),
    )
    for j = 0; j < shapes.length(); j = j + 1 {
      let h = @mooncollider.raycast(ray, shapes[j])
      if h.hit() && h.t < best_t {
        best_t = h.t
        best_idx = j
        best_hit = h
      }
    }
    if best_idx >= 0 {
      let name = match best_idx {
        0 => "box"
        1 => "circle"
        _ => "triangle"
      }
      println(
        "\{a}, \{name}, \{best_hit.t}, \{best_hit.point.x}, \{best_hit.point.y}, \{best_hit.normal.x}, \{best_hit.normal.y}",
      )
    } else {
      println("\{a}, miss, -, -, -, -, -")
    }
  }
  println("done")
}
