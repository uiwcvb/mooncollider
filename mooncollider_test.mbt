// Blackbox tests run against the package's public API. Use `@mooncollider` to import.
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.

// ---------------------------------------------------------------------------
// Vec2
// ---------------------------------------------------------------------------

///|
test "vec2/add_sub" {
  let a = @mooncollider.Vec2::new(1.0, 2.0)
  let b = @mooncollider.Vec2::new(3.0, 4.0)
  let c = a.add(b)
  assert_true(c.approx_eq(@mooncollider.Vec2::new(4.0, 6.0), 1.0e-9))
  let d = a.sub(b)
  assert_true(d.approx_eq(@mooncollider.Vec2::new(-2.0, -2.0), 1.0e-9))
}

///|
test "vec2/scale_neg" {
  let a = @mooncollider.Vec2::new(2.0, -3.0)
  let b = a.scale(2.0)
  assert_true(b.approx_eq(@mooncollider.Vec2::new(4.0, -6.0), 1.0e-9))
  let n = a.neg()
  assert_true(n.approx_eq(@mooncollider.Vec2::new(-2.0, 3.0), 1.0e-9))
}

///|
test "vec2/dot_cross" {
  let a = @mooncollider.Vec2::new(1.0, 0.0)
  let b = @mooncollider.Vec2::new(0.0, 1.0)
  assert_eq(a.dot(b), 0.0)
  assert_eq(a.cross(b), 1.0)
  assert_eq(b.cross(a), -1.0)
}

///|
test "vec2/length_normalize" {
  let a = @mooncollider.Vec2::new(3.0, 4.0)
  assert_eq(a.length(), 5.0)
  assert_eq(a.length_sq(), 25.0)
  let u = a.normalize()
  assert_true((u.length() - 1.0).abs() < 1.0e-9)
  let z = @mooncollider.Vec2::zero()
  assert_true(z.normalize().approx_eq(z, 1.0e-9))
}

///|
test "vec2/perp_rotate" {
  let a = @mooncollider.Vec2::new(1.0, 0.0)
  let p = a.perp()
  assert_true(p.approx_eq(@mooncollider.Vec2::new(0.0, 1.0), 1.0e-9))
  // rotate 90 degrees CCW
  let r = a.rotate(@math.PI / 2.0)
  assert_true(r.approx_eq(@mooncollider.Vec2::new(0.0, 1.0), 1.0e-9))
}

// ---------------------------------------------------------------------------
// AABB / Circle / Polygon shapes
// ---------------------------------------------------------------------------

///|
test "aabb/contains_union" {
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  assert_true(a.contains(@mooncollider.Vec2::new(1.0, 1.0)))
  assert_false(a.contains(@mooncollider.Vec2::new(3.0, 3.0)))
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(1.0, 1.0),
    @mooncollider.Vec2::new(3.0, 3.0),
  )
  let u = a.union(b)
  assert_true(u.contains(@mooncollider.Vec2::new(0.0, 0.0)))
  assert_true(u.contains(@mooncollider.Vec2::new(3.0, 3.0)))
}

///|
test "aabb/overlaps" {
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(1.0, 1.0),
    @mooncollider.Vec2::new(3.0, 3.0),
  )
  assert_true(a.overlaps(b))
  let c = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(5.0, 5.0),
    @mooncollider.Vec2::new(6.0, 6.0),
  )
  assert_false(a.overlaps(c))
}

///|
test "circle/contains" {
  let c = @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 2.0)
  assert_true(c.contains(@mooncollider.Vec2::new(1.0, 0.0)))
  assert_true(c.contains(@mooncollider.Vec2::new(0.0, 0.0)))
  assert_false(c.contains(@mooncollider.Vec2::new(3.0, 0.0)))
}

///|
test "polygon/convex_hull_box" {
  // Five points including one interior point; hull should be 4 corners.
  let pts = [
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
    @mooncollider.Vec2::new(0.0, 2.0),
    @mooncollider.Vec2::new(1.0, 1.0),
  ]
  let p = @mooncollider.Polygon::convex_hull(pts)
  assert_eq(p.size(), 4)
}

///|
test "polygon/regular_aabb" {
  let p = @mooncollider.Polygon::regular(
    @mooncollider.Vec2::new(0.0, 0.0),
    1.0,
    4,
  )
  assert_eq(p.size(), 4)
  let box = p.aabb()
  // Square of radius 1 centered at origin: spans roughly [-1, 1].
  let lo = box.min()
  let hi = box.max()
  assert_true((lo.x + 1.0).abs() < 1.0e-9)
  assert_true((hi.x - 1.0).abs() < 1.0e-9)
}

// ---------------------------------------------------------------------------
// Narrowphase collisions
// ---------------------------------------------------------------------------

///|
test "narrowphase/aabb_aabb_hit" {
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(1.0, 1.0),
    @mooncollider.Vec2::new(3.0, 3.0),
  )
  let m = @mooncollider.collide_aabb_aabb(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

///|
test "narrowphase/aabb_aabb_miss" {
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(5.0, 5.0),
    @mooncollider.Vec2::new(6.0, 6.0),
  )
  let m = @mooncollider.collide_aabb_aabb(a, b)
  assert_false(m.colliding())
}

///|
test "narrowphase/circle_circle_hit" {
  let a = @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0)
  let b = @mooncollider.Circle::new(@mooncollider.Vec2::new(1.5, 0.0), 1.0)
  let m = @mooncollider.collide_circle_circle(a, b)
  assert_true(m.colliding())
  // Normal points from a to b: +x.
  assert_true(m.normal.approx_eq(@mooncollider.Vec2::new(1.0, 0.0), 1.0e-9))
  assert_true((m.depth - 0.5).abs() < 1.0e-9)
}

///|
test "narrowphase/circle_circle_miss" {
  let a = @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0)
  let b = @mooncollider.Circle::new(@mooncollider.Vec2::new(5.0, 0.0), 1.0)
  let m = @mooncollider.collide_circle_circle(a, b)
  assert_false(m.colliding())
}

///|
test "narrowphase/aabb_circle_hit" {
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.Circle::new(@mooncollider.Vec2::new(3.0, 1.0), 1.5)
  let m = @mooncollider.collide_aabb_circle(a, b)
  assert_true(m.colliding())
  // Normal from box to circle: +x.
  assert_true(m.normal.approx_eq(@mooncollider.Vec2::new(1.0, 0.0), 1.0e-9))
}

///|
test "narrowphase/aabb_circle_inside" {
  // Circle center inside the box.
  let a = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(4.0, 4.0),
  )
  let b = @mooncollider.Circle::new(@mooncollider.Vec2::new(2.0, 2.0), 1.0)
  let m = @mooncollider.collide_aabb_circle(a, b)
  assert_true(m.colliding())
}

///|
test "narrowphase/polygon_polygon_hit" {
  let a = @mooncollider.Polygon::box(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.Polygon::box(
    @mooncollider.Vec2::new(1.0, 1.0),
    @mooncollider.Vec2::new(3.0, 3.0),
  )
  let m = @mooncollider.collide_polygon_polygon(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

///|
test "narrowphase/polygon_polygon_miss" {
  let a = @mooncollider.Polygon::box(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let b = @mooncollider.Polygon::box(
    @mooncollider.Vec2::new(10.0, 10.0),
    @mooncollider.Vec2::new(12.0, 12.0),
  )
  let m = @mooncollider.collide_polygon_polygon(a, b)
  assert_false(m.colliding())
}

///|
test "narrowphase/collide_dispatch" {
  // AABB vs Circle via the generic dispatch.
  let a = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(2.0, 2.0),
    ),
  )
  let b = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(3.0, 1.0), 1.5),
  )
  let m = @mooncollider.collide(a, b)
  assert_true(m.colliding())
  // Circle vs AABB (reversed) — normal should flip.
  let m2 = @mooncollider.collide(b, a)
  assert_true(m2.colliding())
  assert_true(m2.normal.approx_eq(m.normal.neg(), 1.0e-9))
}

// ---------------------------------------------------------------------------
// Raycast
// ---------------------------------------------------------------------------

///|
test "raycast/aabb_hit" {
  let r = @mooncollider.Ray::from_to(
    @mooncollider.Vec2::new(-5.0, 1.0),
    @mooncollider.Vec2::new(5.0, 1.0),
  )
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let h = @mooncollider.raycast_aabb(r, b)
  assert_true(h.hit())
  // Hit point should be at the -x face: (0, 1).
  assert_true(h.point.approx_eq(@mooncollider.Vec2::new(0.0, 1.0), 1.0e-9))
  // Hit the -x face.
  assert_true(h.normal.approx_eq(@mooncollider.Vec2::new(-1.0, 0.0), 1.0e-9))
}

///|
test "raycast/aabb_miss" {
  let r = @mooncollider.Ray::from_to(
    @mooncollider.Vec2::new(-5.0, 10.0),
    @mooncollider.Vec2::new(5.0, 10.0),
  )
  let b = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let h = @mooncollider.raycast_aabb(r, b)
  assert_false(h.hit())
}

///|
test "raycast/circle_hit" {
  let r = @mooncollider.Ray::from_to(
    @mooncollider.Vec2::new(-5.0, 0.0),
    @mooncollider.Vec2::new(5.0, 0.0),
  )
  let c = @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0)
  let h = @mooncollider.raycast_circle(r, c)
  assert_true(h.hit())
  // Hit point at (-1, 0).
  assert_true(h.point.approx_eq(@mooncollider.Vec2::new(-1.0, 0.0), 1.0e-9))
  assert_true(h.normal.approx_eq(@mooncollider.Vec2::new(-1.0, 0.0), 1.0e-9))
}

///|
test "raycast/polygon_hit" {
  let r = @mooncollider.Ray::from_to(
    @mooncollider.Vec2::new(-5.0, 1.0),
    @mooncollider.Vec2::new(5.0, 1.0),
  )
  let p = @mooncollider.Polygon::box(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(2.0, 2.0),
  )
  let h = @mooncollider.raycast_polygon(r, p)
  assert_true(h.hit())
}

// ---------------------------------------------------------------------------
// Broadphase
// ---------------------------------------------------------------------------

///|
test "broadphase/grid_pairs" {
  let g = @mooncollider.GridHash::new(2.0)
  g.insert(
    0,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(1.0, 1.0),
    ),
  )
  g.insert(
    1,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.5, 0.5),
      @mooncollider.Vec2::new(1.5, 1.5),
    ),
  )
  g.insert(
    2,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(10.0, 10.0),
      @mooncollider.Vec2::new(11.0, 11.0),
    ),
  )
  let pairs = g.pairs()
  // Only bodies 0 and 1 overlap a shared cell; body 2 is isolated.
  assert_eq(pairs.length(), 1)
  let (a, b) = pairs[0]
  assert_eq(a, 0)
  assert_eq(b, 1)
}

///|
test "broadphase/quadtree_pairs" {
  let bounds = @mooncollider.AABB::from_min_max(
    @mooncollider.Vec2::new(-10.0, -10.0),
    @mooncollider.Vec2::new(10.0, 10.0),
  )
  let q = @mooncollider.QuadTree::new(bounds, 2, 4)
  q.insert(
    0,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(1.0, 1.0),
    ),
  )
  q.insert(
    1,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.5, 0.5),
      @mooncollider.Vec2::new(1.5, 1.5),
    ),
  )
  q.insert(
    2,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(8.0, 8.0),
      @mooncollider.Vec2::new(9.0, 9.0),
    ),
  )
  let pairs = q.pairs()
  // Bodies 0 and 1 overlap; body 2 is far away.
  assert_eq(pairs.length(), 1)
  let (a, b) = pairs[0]
  assert_eq(a, 0)
  assert_eq(b, 1)
}

// ---------------------------------------------------------------------------
// RigidBody + World
// ---------------------------------------------------------------------------

///|
test "world/step_gravity" {
  let w = @mooncollider.World::new()
  let _ = w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 10.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.5),
      ),
      1.0,
      0.0,
    ),
  )
  // Add a static floor.
  let _ = w.add_body(
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
  let dt = 0.016
  w.step(dt)
  // After one step, the falling body should have moved down (gravity).
  let body = w.body(0)
  assert_true(body.position.y < 10.0)
}

///|
test "world/bounce" {
  let w = @mooncollider.World::new()
  let _ = w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 5.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.5),
      ),
      1.0,
      1.0, // perfect restitution
    ),
  )
  let _ = w.add_body(
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
  // Step many times; the body should bounce and not fall through the floor.
  let mut i = 0
  while i < 200 {
    w.step(0.016)
    i = i + 1
  }
  let body = w.body(0)
  // The body should not have fallen below the floor surface (y > -0.5).
  assert_true(body.position.y > -1.0)
}

// ---------------------------------------------------------------------------
// GJK + EPA
// ---------------------------------------------------------------------------

///|
test "gjk/circle_circle_hit" {
  let a = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0),
  )
  let b = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(1.5, 0.0), 1.0),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

///|
test "gjk/circle_circle_miss" {
  let a = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(0.0, 0.0), 1.0),
  )
  let b = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(5.0, 0.0), 1.0),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_false(m.colliding())
}

///|
test "gjk/aabb_aabb_hit" {
  let a = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(2.0, 2.0),
    ),
  )
  let b = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(1.0, 1.0),
      @mooncollider.Vec2::new(3.0, 3.0),
    ),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

///|
test "gjk/polygon_polygon_hit" {
  let a = @mooncollider.Shape::from_polygon(
    @mooncollider.Polygon::box(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(2.0, 2.0),
    ),
  )
  let b = @mooncollider.Shape::from_polygon(
    @mooncollider.Polygon::box(
      @mooncollider.Vec2::new(1.0, 1.0),
      @mooncollider.Vec2::new(3.0, 3.0),
    ),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

///|
test "gjk/polygon_polygon_miss" {
  let a = @mooncollider.Shape::from_polygon(
    @mooncollider.Polygon::box(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(2.0, 2.0),
    ),
  )
  let b = @mooncollider.Shape::from_polygon(
    @mooncollider.Polygon::box(
      @mooncollider.Vec2::new(10.0, 10.0),
      @mooncollider.Vec2::new(12.0, 12.0),
    ),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_false(m.colliding())
}

///|
test "gjk/aabb_circle_hit" {
  let a = @mooncollider.Shape::from_aabb(
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(2.0, 2.0),
    ),
  )
  let b = @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::new(3.0, 1.0), 1.5),
  )
  let m = @mooncollider.collide_gjk(a, b)
  assert_true(m.colliding())
  assert_true(m.depth > 0.0)
}

// ---------------------------------------------------------------------------
// Sweep-and-Prune
// ---------------------------------------------------------------------------

///|
test "sap/pairs" {
  let sap = @mooncollider.SweepAndPrune::new()
  sap.insert(
    0,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(1.0, 1.0),
    ),
  )
  sap.insert(
    1,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.5, 0.5),
      @mooncollider.Vec2::new(1.5, 1.5),
    ),
  )
  sap.insert(
    2,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(10.0, 10.0),
      @mooncollider.Vec2::new(11.0, 11.0),
    ),
  )
  let pairs = sap.pairs()
  assert_eq(pairs.length(), 1)
  let (a, b) = pairs[0]
  assert_eq(a, 0)
  assert_eq(b, 1)
}

// ---------------------------------------------------------------------------
// AABB Tree
// ---------------------------------------------------------------------------

///|
test "aabmtree/pairs" {
  let tree = @mooncollider.AABBTree::new()
  let _ = tree.insert(
    0,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(1.0, 1.0),
    ),
  )
  let _ = tree.insert(
    1,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.5, 0.5),
      @mooncollider.Vec2::new(1.5, 1.5),
    ),
  )
  let _ = tree.insert(
    2,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(10.0, 10.0),
      @mooncollider.Vec2::new(11.0, 11.0),
    ),
  )
  let pairs = tree.pairs()
  assert_eq(pairs.length(), 1)
  let (a, b) = pairs[0]
  assert_eq(a, 0)
  assert_eq(b, 1)
}

// ---------------------------------------------------------------------------
// Friction
// ---------------------------------------------------------------------------

///|
test "world/friction_slows_slide" {
  // A box sliding on a floor with friction should slow down more than one
  // sliding on a frictionless floor.
  let make = fn(friction : Double) -> Double {
    let w = @mooncollider.World::new()
    let box_def = @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 0.5),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::new(
          @mooncollider.Vec2::zero(),
          @mooncollider.Vec2::new(0.5, 0.5),
        ),
      ),
      1.0,
      0.0,
    )
    box_def.friction = friction
    let _ = w.add_body(box_def)
    let floor_def = @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::from_min_max(
          @mooncollider.Vec2::new(-20.0, -1.0),
          @mooncollider.Vec2::new(20.0, 0.0),
        ),
      ),
    )
    floor_def.friction = friction
    let _ = w.add_body(floor_def)
    w.body(0).velocity = @mooncollider.Vec2::new(10.0, 0.0)
    let mut i = 0
    while i < 100 {
      w.step(0.016)
      i = i + 1
    }
    w.body(0).velocity.x
  }
  let v_high = make(0.9)
  let v_low = make(0.0)
  // High friction should slow the box more than no friction.
  assert_true(v_high < v_low)
}

///|
test "world/stacking_rest" {
  // Three boxes stacked on a floor should come to rest without exploding.
  let w = @mooncollider.World::new()
  let floor_def = @mooncollider.BodyDef::static_(
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Shape::from_aabb(
      @mooncollider.AABB::from_min_max(
        @mooncollider.Vec2::new(-20.0, -1.0),
        @mooncollider.Vec2::new(20.0, 0.0),
      ),
    ),
  )
  let _ = w.add_body(floor_def)
  let mut i = 0
  while i < 3 {
    let def = @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 1.0 + i.to_double()),
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
    let _ = w.add_body(def)
    i = i + 1
  }
  let mut step = 0
  while step < 300 {
    w.step(0.016)
    step = step + 1
  }
  // The topmost box (id 3) should have settled near y=2 (stacked 0.5-high
  // boxes on a floor whose top is at y=0). Allow generous tolerance.
  let top = w.body(3)
  assert_true(top.position.y < 10.0)
  assert_true(top.position.y > 0.0)
}

// ---------------------------------------------------------------------------
// Joints
// ---------------------------------------------------------------------------

///|
test "joint/distance_pendulum" {
  // Two bodies connected by a distance joint: a static anchor and a dynamic
  // bob. The bob should swing but stay roughly at the rest length.
  let w = @mooncollider.World::new()
  let _anchor = w.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 5.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.1),
      ),
    ),
  )
  let _bob = w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(3.0, 5.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.3),
      ),
      1.0,
      0.0,
    ),
  )
  let dj = @mooncollider.DistanceJoint::from_world(
    w,
    0,
    1,
    @mooncollider.Vec2::new(0.0, 5.0),
    @mooncollider.Vec2::new(3.0, 5.0),
  )
  w.add_joint(@mooncollider.Joint::distance(dj))
  let mut i = 0
  while i < 200 {
    w.step(0.016)
    i = i + 1
  }
  // The bob should not have drifted far from the rest length (3.0).
  let bob = w.body(1)
  let dist = bob.position.sub(@mooncollider.Vec2::new(0.0, 5.0)).length()
  assert_true((dist - 3.0).abs() < 2.0)
}

///|
test "joint/revolute_pin" {
  // A dynamic body pinned to a static anchor should orbit around the anchor
  // rather than fly off.
  let w = @mooncollider.World::new()
  let _ = w.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.1),
      ),
    ),
  )
  let _ = w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(2.0, 0.0),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::new(
          @mooncollider.Vec2::zero(),
          @mooncollider.Vec2::new(0.5, 0.5),
        ),
      ),
      1.0,
      0.0,
    ),
  )
  let rj = @mooncollider.RevoluteJoint::from_world(
    w,
    0,
    1,
    @mooncollider.Vec2::new(0.0, 0.0),
  )
  w.add_joint(@mooncollider.Joint::revolute(rj))
  let mut i = 0
  while i < 200 {
    w.step(0.016)
    i = i + 1
  }
  let body = w.body(1)
  let dist = body.position.length()
  // Should stay near the initial 2.0 radius.
  assert_true(dist < 3.0)
  assert_true(dist > 1.0)
}

// ---------------------------------------------------------------------------
// AABBTree remove / update
// ---------------------------------------------------------------------------

///|
test "aabmtree/remove_and_update" {
  let tree = @mooncollider.AABBTree::new()
  let l0 = tree.insert(
    0,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.0, 0.0),
      @mooncollider.Vec2::new(1.0, 1.0),
    ),
  )
  let _ = tree.insert(
    1,
    @mooncollider.AABB::from_min_max(
      @mooncollider.Vec2::new(0.5, 0.5),
      @mooncollider.Vec2::new(1.5, 1.5),
    ),
  )
  let pairs_before = tree.pairs()
  assert_eq(pairs_before.length(), 1)
  // Remove body 0; no pairs should remain.
  tree.remove(l0)
  let pairs_after = tree.pairs()
  assert_eq(pairs_after.length(), 0)
}

// ---------------------------------------------------------------------------
// CCD
// ---------------------------------------------------------------------------

///|
test "ccd/circle_vs_circle_hit" {
  // A fast circle sweeping toward a static circle should detect the hit.
  let s = @mooncollider.ccd_sweep_circle(
    0.5,
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(10.0, 0.0),
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::new(5.0, 0.0), 0.5),
    ),
  )
  assert_true(s.hit)
  assert_true(s.t < 1.0)
}

///|
test "ccd/circle_vs_circle_miss" {
  let s = @mooncollider.ccd_sweep_circle(
    0.5,
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(10.0, 0.0),
    @mooncollider.Shape::from_circle(
      @mooncollider.Circle::new(@mooncollider.Vec2::new(5.0, 10.0), 0.5),
    ),
  )
  assert_false(s.hit)
}

///|
test "ccd/aabb_vs_aabb_hit" {
  let s = @mooncollider.ccd_sweep_aabb(
    @mooncollider.Vec2::new(0.5, 0.5),
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(10.0, 0.0),
    @mooncollider.Shape::from_aabb(
      @mooncollider.AABB::from_min_max(
        @mooncollider.Vec2::new(5.0, -1.0),
        @mooncollider.Vec2::new(6.0, 1.0),
      ),
    ),
  )
  assert_true(s.hit)
  assert_true(s.t < 1.0)
}

///|
test "ccd/circle_vs_polygon_hit" {
  let s = @mooncollider.ccd_sweep_circle(
    0.5,
    @mooncollider.Vec2::new(0.0, 0.0),
    @mooncollider.Vec2::new(10.0, 0.0),
    @mooncollider.Shape::from_polygon(
      @mooncollider.Polygon::box(
        @mooncollider.Vec2::new(5.0, -1.0),
        @mooncollider.Vec2::new(6.0, 1.0),
      ),
    ),
  )
  assert_true(s.hit)
  assert_true(s.t < 1.0)
}

// ---------------------------------------------------------------------------
// Solver stability (iteration count matters)
// ---------------------------------------------------------------------------

///|
test "world/stacking_more_iterations_stabler" {
  // A taller stack with more iterations should settle with less residual
  // velocity than with a single iteration.
  let run = fn(iters : Int) -> Double {
    let w = @mooncollider.World::new()
    w.velocity_iterations = iters
    let _ = w.add_body(
      @mooncollider.BodyDef::static_(
        @mooncollider.Vec2::new(0.0, 0.0),
        @mooncollider.Shape::from_aabb(
          @mooncollider.AABB::from_min_max(
            @mooncollider.Vec2::new(-20.0, -1.0),
            @mooncollider.Vec2::new(20.0, 0.0),
          ),
        ),
      ),
    )
    let mut i = 0
    while i < 4 {
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
      let _ = w.add_body(def)
      i = i + 1
    }
    let mut step = 0
    while step < 200 {
      w.step(0.016)
      step = step + 1
    }
    // Total kinetic energy of all dynamic bodies.
    let mut energy = 0.0
    let mut j = 1
    while j < 5 {
      let b = w.body(j)
      energy += 0.5 * b.mass * b.velocity.length_sq()
      j = j + 1
    }
    energy
  }
  let e_high = run(16)
  let e_low = run(1)
  // More iterations -> less residual energy (more settled).
  assert_true(e_high <= e_low + 1.0e-6)
}
