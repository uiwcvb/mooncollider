// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
test "wb/cross3_sign" {
  // cross3(a, b, p) > 0 means p is to the left of a->b.
  let a = Vec2::new(0.0, 0.0)
  let b = Vec2::new(1.0, 0.0)
  let p = Vec2::new(0.5, 1.0)
  let c = cross3(a, b, p)
  assert_true(c > 0.0)
}

///|
test "wb/closest_point_on_segment" {
  let p = Vec2::new(0.5, 1.0)
  let p1 = Vec2::new(0.0, 0.0)
  let p2 = Vec2::new(2.0, 0.0)
  let cp = closest_point_on_segment(p, p1, p2)
  assert_true(cp.approx_eq(Vec2::new(0.5, 0.0), 1.0e-9))
}

///|
test "wb/point_in_polygon" {
  let p = Polygon::box(Vec2::new(0.0, 0.0), Vec2::new(2.0, 2.0))
  assert_true(point_in_polygon(Vec2::new(1.0, 1.0), p))
  assert_false(point_in_polygon(Vec2::new(3.0, 3.0), p))
}
