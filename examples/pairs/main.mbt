///|
/// Example: batch collision queries without a physics world.
///
/// Builds a small set of shapes, reports every colliding pair with its
/// penetration depth and contact normal, and counts total hits. Demonstrates
/// the standalone narrowphase API. Run with `moon run examples/pairs`.
fn main {
  let shapes : Array[@mooncollider.Shape] = []
  // A row of overlapping circles.
  shapes.push(
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0),
    ),
  )
  shapes.push(
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::new(1.5, 0.0), 1.0),
    ),
  )
  shapes.push(
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::new(4.0, 0.0), 1.0),
    ),
  )
  // An overlapping box.
  shapes.push(
    @mooncollider.Shape::from_aabb(
      @mooncollider.AABB::from_min_max(
        @mooncollider.Vec2::new(0.5, -0.5),
        @mooncollider.Vec2::new(2.5, 0.5),
      ),
    ),
  )
  // A triangle touching the box.
  shapes.push(
    @mooncollider.Shape::from_polygon(
      @mooncollider.Polygon::convex_hull([
        @mooncollider.Vec2::new(2.4, 0.0),
        @mooncollider.Vec2::new(3.5, 0.0),
        @mooncollider.Vec2::new(3.0, 1.5),
      ]),
    ),
  )
  println("MoonCollider batch collision example")
  println("Shapes: \{shapes.length()}")
  println("pair, depth, normal_x, normal_y, contact_x, contact_y")
  let mut count = 0
  for i = 0; i < shapes.length(); i = i + 1 {
    for j = i + 1; j < shapes.length(); j = j + 1 {
      let m = @mooncollider.collide(shapes[i], shapes[j])
      if m.colliding() {
        count = count + 1
        println(
          "\{i}-\{j}, \{m.depth}, \{m.normal.x}, \{m.normal.y}, \{m.contact.x}, \{m.contact.y}",
        )
      }
    }
  }
  println("Total colliding pairs: \{count}")
}
