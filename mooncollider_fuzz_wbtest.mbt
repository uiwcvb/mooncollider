// Adversarial fuzzing tests for MoonCollider.
//
// These tests throw randomized and degenerate geometry at every layer and
// assert that the library never produces NaN/Inf, never crashes, and never
// lets dynamic bodies tunnel through static bodies. Run with `moon test`.

///|
/// Check a double for NaN or Inf.
fn is_finite(d : Double) -> Bool {
  !d.is_nan() && d == d && d != 1.0e308 * 10.0 && d != -1.0e308 * 10.0
}

///|
/// Check a Vec2 for finiteness.
fn vec_finite(v : Vec2) -> Bool {
  is_finite(v.x) && is_finite(v.y)
}

///|
/// Assert every field of a rigid body is finite.
fn assert_body_finite(b : RigidBody) -> Unit raise {
  assert_true(vec_finite(b.position))
  assert_true(vec_finite(b.velocity))
  assert_true(vec_finite(b.force))
  assert_true(is_finite(b.angle))
  assert_true(is_finite(b.angular_velocity))
  assert_true(is_finite(b.mass))
  assert_true(is_finite(b.inv_mass))
  assert_true(is_finite(b.inertia))
  assert_true(is_finite(b.inv_inertia))
  assert_true(is_finite(b.restitution))
  assert_true(is_finite(b.friction))
  assert_true(vec_finite(b.aabb.center))
  assert_true(vec_finite(b.aabb.half))
}

///|
/// A deterministic PRNG for reproducible fuzzing. Uses a simple xorshift64
/// seeded by the int — we don't need cryptographic quality, just
/// reproducibility across platforms.
struct FuzzRng {
  mut state : UInt
}

///|
fn FuzzRng::new(seed : Int) -> FuzzRng {
  let s : UInt = if seed == 0 { 1U } else { seed.reinterpret_as_uint() }
  { state: s }
}

///|
fn FuzzRng::next(self : FuzzRng) -> UInt {
  // xorshift32
  let mut x = self.state
  x = x ^ (x << 13)
  x = x ^ (x >> 17)
  x = x ^ (x << 5)
  self.state = x
  x
}

///|
fn FuzzRng::double(self : FuzzRng) -> Double {
  let r = self.next()
  UInt::to_double(r) / 4294967296.0
}

///|
fn FuzzRng::int(self : FuzzRng, limit : Int) -> Int {
  let r = self.next()
  (r.reinterpret_as_int() % limit).abs()
}

///|
/// Generate a random double in [lo, hi].
fn rand_in(rng : FuzzRng, lo : Double, hi : Double) -> Double {
  lo + rng.double() * (hi - lo)
}

///|
/// Generate a random convex polygon, possibly degenerate (collinear points,
/// duplicate points, near-zero area). The polygon is always reduced through
/// `convex_hull` so the library must handle whatever comes out.
fn random_polygon(rng : FuzzRng) -> Polygon {
  let n = rng.int(8) + 3 // 3..10 points
  let pts : Array[Vec2] = []
  for i = 0; i < n; i = i + 1 {
    pts.push(Vec2::new(rand_in(rng, -5.0, 5.0), rand_in(rng, -5.0, 5.0)))
  }
  // Occasionally inject degeneracies.
  let degenerate = rng.int(4)
  if degenerate == 0 {
    // Duplicate a point.
    if pts.length() > 1 {
      pts[0] = pts[1]
    }
  } else if degenerate == 1 {
    // Collinear cluster.
    pts[0] = Vec2::new(0.0, 0.0)
    pts[1] = Vec2::new(1.0, 0.0)
    pts[2] = Vec2::new(2.0, 0.0)
  } else if degenerate == 2 {
    // Near-zero-area triangle.
    pts.push(Vec2::new(0.0, 0.0))
    pts.push(Vec2::new(1.0e-9, 0.0))
    pts.push(Vec2::new(0.0, 1.0e-9))
  }
  Polygon::convex_hull(pts)
}

///|
/// Generate a random shape (AABB / Circle / Polygon).
fn random_shape(rng : FuzzRng) -> Shape {
  match rng.int(3) {
    0 =>
      Shape::from_aabb(
        AABB::new(
          Vec2::new(rand_in(rng, -3.0, 3.0), rand_in(rng, -3.0, 3.0)),
          Vec2::new(rand_in(rng, 0.1, 2.0), rand_in(rng, 0.1, 2.0)),
        ),
      )
    1 =>
      Shape::from_circle(
        Circle::new(
          Vec2::new(rand_in(rng, -3.0, 3.0), rand_in(rng, -3.0, 3.0)),
          rand_in(rng, 0.1, 2.0),
        ),
      )
    _ => Shape::from_polygon(random_polygon(rng))
  }
}

// ---------------------------------------------------------------------------
// Fuzz: narrowphase never produces NaN/Inf
// ---------------------------------------------------------------------------

///|
test "fuzz/narrowphase_no_nan" {
  let rng = FuzzRng::new(42)
  for _iter = 0; _iter < 500; _iter = _iter + 1 {
    let a = random_shape(rng)
    let b = random_shape(rng)
    let m = collide(a, b)
    assert_true(vec_finite(m.normal))
    assert_true(is_finite(m.depth))
    assert_true(vec_finite(m.contact))
    assert_true(vec_finite(m.contact2))
    // Also test GJK path.
    let g = collide_gjk(a, b)
    assert_true(vec_finite(g.normal))
    assert_true(is_finite(g.depth))
    assert_true(vec_finite(g.contact))
  }
}

// ---------------------------------------------------------------------------
// Fuzz: raycast never produces NaN/Inf
// ---------------------------------------------------------------------------

///|
test "fuzz/raycast_no_nan" {
  let rng = FuzzRng::new(7)
  for _iter = 0; _iter < 500; _iter = _iter + 1 {
    let origin = Vec2::new(rand_in(rng, -10.0, 10.0), rand_in(rng, -10.0, 10.0))
    let dir = Vec2::new(rand_in(rng, -5.0, 5.0), rand_in(rng, -5.0, 5.0))
    let ray = Ray::new(origin, dir)
    let shape = random_shape(rng)
    let h = raycast(ray, shape)
    assert_true(is_finite(h.t))
    assert_true(vec_finite(h.point))
    assert_true(vec_finite(h.normal))
  }
}

// ---------------------------------------------------------------------------
// Fuzz: broadphase never crashes and pairs are deduplicated
// ---------------------------------------------------------------------------

///|
test "fuzz/broadphase_no_crash" {
  let rng = FuzzRng::new(99)
  // GridHash
  for _round = 0; _round < 10; _round = _round + 1 {
    let grid = GridHash::new(rand_in(rng, 0.5, 5.0))
    let n = rng.int(50) + 1
    for i = 0; i < n; i = i + 1 {
      grid.insert(
        i,
        AABB::new(
          Vec2::new(rand_in(rng, -10.0, 10.0), rand_in(rng, -10.0, 10.0)),
          Vec2::new(rand_in(rng, 0.1, 3.0), rand_in(rng, 0.1, 3.0)),
        ),
      )
    }
    let pairs = grid.pairs()
    // Verify no duplicate pairs.
    let seen : Map[(Int, Int), Unit] = Map([])
    for k = 0; k < pairs.length(); k = k + 1 {
      let key = pairs[k]
      assert_true(!seen.contains(key))
      seen.set(key, ())
    }
  }
  // QuadTree
  for _round = 0; _round < 10; _round = _round + 1 {
    let bounds = AABB::from_min_max(
      Vec2::new(-50.0, -50.0),
      Vec2::new(50.0, 50.0),
    )
    let q = QuadTree::new(bounds, rng.int(8) + 1, rng.int(6) + 1)
    let n = rng.int(50) + 1
    for i = 0; i < n; i = i + 1 {
      q.insert(
        i,
        AABB::new(
          Vec2::new(rand_in(rng, -10.0, 10.0), rand_in(rng, -10.0, 10.0)),
          Vec2::new(rand_in(rng, 0.1, 3.0), rand_in(rng, 0.1, 3.0)),
        ),
      )
    }
    let _ = q.pairs()
  }
  // SweepAndPrune
  for _round = 0; _round < 10; _round = _round + 1 {
    let sap = SweepAndPrune::new()
    let n = rng.int(50) + 1
    for i = 0; i < n; i = i + 1 {
      sap.insert(
        i,
        AABB::new(
          Vec2::new(rand_in(rng, -10.0, 10.0), rand_in(rng, -10.0, 10.0)),
          Vec2::new(rand_in(rng, 0.1, 3.0), rand_in(rng, 0.1, 3.0)),
        ),
      )
    }
    let _ = sap.pairs()
  }
  // AABBTree
  for _round = 0; _round < 10; _round = _round + 1 {
    let tree = AABBTree::new()
    let n = rng.int(50) + 1
    for i = 0; i < n; i = i + 1 {
      let _ = tree.insert(
        i,
        AABB::new(
          Vec2::new(rand_in(rng, -10.0, 10.0), rand_in(rng, -10.0, 10.0)),
          Vec2::new(rand_in(rng, 0.1, 3.0), rand_in(rng, 0.1, 3.0)),
        ),
      )
    }
    let _ = tree.pairs()
  }
}

// ---------------------------------------------------------------------------
// Fuzz: world simulation never diverges (no NaN, energy bounded)
// ---------------------------------------------------------------------------

///|
test "fuzz/world_no_diverge" {
  let rng = FuzzRng::new(2024)
  for _round = 0; _round < 20; _round = _round + 1 {
    let w = World::new()
    w.velocity_iterations = 4
    // Static floor.
    let _ = w.add_body(
      BodyDef::static_(
        Vec2::new(0.0, -10.0),
        Shape::from_aabb(
          AABB::from_min_max(Vec2::new(-100.0, -20.0), Vec2::new(100.0, -10.0)),
        ),
      ),
    )
    // Random dynamic bodies.
    let n = rng.int(15) + 5
    for i = 0; i < n; i = i + 1 {
      let def = BodyDef::dynamic(
        Vec2::new(rand_in(rng, -5.0, 5.0), rand_in(rng, 0.0, 10.0)),
        random_shape(rng),
        rand_in(rng, 0.5, 5.0),
        rand_in(rng, 0.0, 0.5),
      )
      def.friction = rand_in(rng, 0.0, 0.8)
      let _ = w.add_body(def)
    }
    // Track initial energy.
    let mut initial_energy = 0.0
    for i = 1; i <= n; i = i + 1 {
      let b = w.body(i)
      initial_energy += 0.5 * b.mass * b.velocity.length_sq()
      initial_energy += 0.5 *
        b.inertia *
        b.angular_velocity *
        b.angular_velocity
      // Potential energy proxy.
      initial_energy += b.mass * (b.position.y + 10.0) * 9.81
    }
    // Simulate 200 steps.
    let mut step = 0
    while step < 200 {
      w.step(0.016)
      step = step + 1
    }
    // Assert all bodies finite and energy not exploded.
    for i = 0; i <= n; i = i + 1 {
      let b = w.body(i)
      assert_body_finite(b)
    }
    let mut final_energy = 0.0
    for i = 1; i <= n; i = i + 1 {
      let b = w.body(i)
      final_energy += 0.5 * b.mass * b.velocity.length_sq()
      final_energy += 0.5 * b.inertia * b.angular_velocity * b.angular_velocity
      final_energy += b.mass * (b.position.y + 10.0) * 9.81
    }
    // Energy should not explode (allow 10x for solver noise + gravity input).
    assert_true(is_finite(final_energy))
    if initial_energy > 0.0 {
      assert_true(final_energy < initial_energy * 10.0 + 1000.0)
    }
  }
}

// ---------------------------------------------------------------------------
// Fuzz: no tunneling through static floor
// ---------------------------------------------------------------------------

///|
test "fuzz/no_tunnel_floor" {
  let rng = FuzzRng::new(555)
  for _round = 0; _round < 30; _round = _round + 1 {
    let w = World::new()
    let _ = w.add_body(
      BodyDef::static_(
        Vec2::new(0.0, 0.0),
        Shape::from_aabb(
          AABB::from_min_max(Vec2::new(-50.0, -10.0), Vec2::new(50.0, 0.0)),
        ),
      ),
    )
    let def = BodyDef::dynamic(
      Vec2::new(rand_in(rng, -3.0, 3.0), rand_in(rng, 1.0, 8.0)),
      Shape::from_circle(Circle::new(Vec2::zero(), rand_in(rng, 0.3, 1.0))),
      1.0,
      rand_in(rng, 0.0, 0.8),
    )
    let bid = w.add_body(def)
    let mut step = 0
    while step < 300 {
      w.step(0.016)
      step = step + 1
    }
    // Body must not have fallen through the floor (top at y=0).
    let b = w.body(bid)
    assert_true(b.position.y > -2.0)
  }
}

// ---------------------------------------------------------------------------
// Fuzz: convex_hull handles all degenerate inputs without panic
// ---------------------------------------------------------------------------

///|
test "fuzz/convex_hull_degenerate" {
  let rng = FuzzRng::new(31337)
  for _iter = 0; _iter < 200; _iter = _iter + 1 {
    let n = rng.int(10) + 1
    let pts : Array[Vec2] = []
    for i = 0; i < n; i = i + 1 {
      pts.push(Vec2::new(rand_in(rng, -5.0, 5.0), rand_in(rng, -5.0, 5.0)))
    }
    // Occasionally make all points identical.
    if rng.int(5) == 0 && n > 0 {
      for i = 0; i < n; i = i + 1 {
        pts[i] = pts[0]
      }
    }
    let p = Polygon::convex_hull(pts)
    // Verify normals are unit length, or zero for degenerate (collinear) hulls.
    for i = 0; i < p.normals.length(); i = i + 1 {
      let nrm = p.normals[i]
      let l = nrm.length()
      assert_true((l < 1.001 && l > 0.999) || l == 0.0)
    }
  }
}
