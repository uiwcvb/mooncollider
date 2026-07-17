# MoonCollider

[![Website](https://img.shields.io/badge/website-mooncollider-58a6ff?style=flat-square)](https://uiwcvb.github.io/mooncollider/)
[![Live Demo](https://img.shields.io/badge/demo-interactive%20physics-3fb950?style=flat-square)](https://uiwcvb.github.io/mooncollider/#sandbox)
[![License](https://img.shields.io/badge/license-Apache--2.0-green?style=flat-square)](LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-0.1.20260703-orange?style=flat-square)](https://www.moonbitlang.com/)
[![Tests](https://img.shields.io/badge/tests-61%2F61-brightgreen?style=flat-square)](#tests)

**A 2D game physics and collision detection library for [MoonBit](https://www.moonbitlang.com/).**

MoonCollider provides vector math, shape geometry, narrowphase collision
detection (SAT + GJK/EPA), raycasting, four broadphase acceleration
structures, a sequential-impulse rigid-body solver with friction and
positional correction, joint constraints (distance/revolute/weld), and
continuous collision detection (CCD). It is pure logic — no rendering —
so it runs on every MoonBit target (wasm-gc, js, native).

## Features

- **Vector math** — `Vec2` with add/sub/scale/dot/cross/length/normalize/
  rotate/perp.
- **Shapes** — `AABB`, `Circle`, convex `Polygon` (with `convex_hull`,
  `regular`, `box` builders), and a `Shape` enum for generic dispatch.
- **Narrowphase** — pairwise collision with 2-point contact manifolds:
  - All 9 shape pairs (AABB/Circle/Polygon) via Separating Axis Theorem
  - `collide_gjk(a, b)` — GJK + EPA for arbitrary convex shapes via support functions
- **Raycast** — ray vs AABB / Circle / Polygon, returning parametric `t`,
  hit point, and surface normal.
- **Broadphase** — four options:
  - `GridHash` — uniform spatial hash grid
  - `QuadTree` — loose quadtree
  - `SweepAndPrune` — single-axis sort and sweep
  - `AABBTree` — dynamic AABB tree with insert/remove/update
- **Rigid body** — `RigidBody` with mass, inertia, restitution, friction,
  damping, static/dynamic types; `World::step` integrates forces, runs
  broadphase + narrowphase, and resolves collisions with sequential
  impulses, Coulomb friction, and Baumgarte positional correction.
- **Joints** — `Distance`, `Revolute`, and `Weld` constraints with soft
  Baumgarte bias.
- **CCD** — continuous collision detection via sweep tests (Circle/AABB)
  to prevent tunneling at high velocities.
- **Body removal** — `World::remove_body(id)` marks bodies inactive;
  inactive bodies are skipped in all simulation phases.

## Installation

```bash
moon add uiwcvb/mooncollider
```

## Quick start

```moonbit nocheck
///|
fn main {
  let world = @mooncollider.World::new()
  // A dynamic circle (the ball).
  let _ = world.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(0.0, 10.0),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 0.5),
      ),
      1.0, // mass
      0.8, // restitution (bounciness)
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
  // Step the simulation.
  for i = 0; i < 200; i = i + 1 {
    world.step(0.016)
  }
}
```

## Using individual pieces

### Collision detection without a world

```moonbit nocheck
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
if m.colliding() {
  // m.normal points from a to b; m.depth is the penetration.
}
```

### Raycasting

```moonbit nocheck
let ray = @mooncollider.Ray::from_to(
  @mooncollider.Vec2::new(-5.0, 0.0),
  @mooncollider.Vec2::new(5.0, 0.0),
)
let hit = @mooncollider.raycast(
  ray,
  @mooncollider.Shape::from_circle(
    @mooncollider.Circle::new(@mooncollider.Vec2::zero(), 1.0),
  ),
)
if hit.hit() {
  // hit.point, hit.normal, hit.t
}
```

### Broadphase

```moonbit nocheck
let grid = @mooncollider.GridHash::new(2.0)
grid.insert(0, aabb_a)
grid.insert(1, aabb_b)
let pairs = grid.pairs() // Array[(Int, Int)], each (a, b) with a < b
```

## Run the demos

```bash
moon run cmd/main        # bouncing ball under gravity
moon run cmd/stacking    # column of boxes settling into a stack
moon run cmd/raycast     # rays cast at a scene of shapes
moon run cmd/pendulum    # distance-joint pendulum
moon run cmd/ccd_stress  # CCD tunneling comparison
moon run cmd/perf        # performance benchmarks
moon run examples/pairs  # batch collision queries without a world
```

## Tests

```bash
moon test
```

The suite covers vector math, all shape operations, every narrowphase pair,
GJK+EPA, raycasting, all four broadphase structures, the rigid-body world
(gravity, bounce, friction, stacking), joints, CCD, plus adversarial fuzz
testing (random shape storms, degenerate geometry, NaN/Inf detection, energy
divergence checks) and cross-platform determinism snapshots.

## Website

An interactive physics sandbox powered by the real MoonCollider engine
(compiled to JavaScript) is at **<https://uiwcvb.github.io/mooncollider/>**.
Click to add balls/boxes, drag to throw, toggle gravity.

## Verification

The project passes the MoonBit competition hard requirements:

```bash
moon check
moon test
moon info && git diff --exit-code
```

And the soft bonus:

```bash
moon fmt && git diff --exit-code
```

## Project layout

```
mooncollider/
  moon.mod / moon.pkg          module + package config
  vec2.mbt                     2D vector math
  shape.mbt                    AABB, Circle, Polygon, Shape
  narrowphase.mbt              collision detection + Manifold
  gjk.mbt                      GJK + EPA generic convex collision
  raycast.mbt                  ray vs shape
  broadphase.mbt               GridHash + QuadTree
  broadphase_sap.mbt           SweepAndPrune + AABBTree
  body.mbt                     RigidBody + BodyDef
  world.mbt                    World::step + collision resolution
  joints.mbt                   Distance / Revolute / Weld joints
  ccd.mbt                      continuous collision detection
  mooncollider_test.mbt        blackbox tests (public API)
  mooncollider_wbtest.mbt      whitebox tests (internal helpers)
  mooncollider_fuzz_wbtest.mbt adversarial fuzz testing
  cmd/main/                    bounce demo
  cmd/stacking/                stacking demo
  cmd/raycast/                 raycast demo
  cmd/pendulum/                pendulum demo
  cmd/ccd_stress/              CCD tunneling comparison
  cmd/perf/                    performance benchmarks
  cmd/web/                     JS bindings for the website sandbox
  examples/pairs/              batch collision query example
  docs/                        website + design notes
```

## License

Apache-2.0.

## References

This project implements well-known physics algorithms from scratch in MoonBit.
No source code was ported from the following references; they were used as
algorithmic guidance only:

- **Box2D** by Erin Catto — sequential-impulse solver, Baumgarte position
  correction, contact manifold generation, joint constraints.
  - Source: <https://github.com/erincatto/box2d>
  - License: MIT (GitHub repository)
  - Reference scope: solver architecture, collision response theory

- **Real-Time Collision Detection** by Christer Ericson (Morgan Kaufmann,
  2004) — SAT, GJK, EPA, closest-point algorithms, sweeping.
  - Source: Book (ISBN 978-1558607323)
  - License: Published book (proprietary text; algorithms are public domain
    mathematics)
  - Reference scope: narrowphase algorithms (SAT, GJK, EPA), CCD sweep theory
