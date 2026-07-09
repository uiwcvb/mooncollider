# MoonCollider

**A 2D game physics and collision detection library for [MoonBit](https://www.moonbitlang.com/).**

MoonCollider provides vector math, shape geometry, narrowphase collision
detection (SAT for convex polygons), raycasting, broadphase acceleration
(uniform grid hash + quadtree), and a lightweight rigid-body simulator with
gravity, impulses, and positional correction. It is pure logic — no
rendering, no native backend — so it runs on every MoonBit target (wasm-gc,
js, native).

## Features

- **Vector math** — `Vec2` with add/sub/scale/dot/cross/length/normalize/
  rotate/perp.
- **Shapes** — `AABB`, `Circle`, convex `Polygon` (with `convex_hull`,
  `regular`, `box` builders), and a `Shape` enum for generic dispatch.
- **Narrowphase** — pairwise collision with contact manifolds (normal, depth,
  contact point):
  - AABB vs AABB
  - Circle vs Circle
  - AABB vs Circle (including circle-center-inside-box)
  - Polygon vs Polygon (Separating Axis Theorem)
  - AABB vs Polygon
  - Circle vs Polygon (including center-inside-polygon)
  - Generic `collide(a, b)` dispatch over all 9 pairs
- **Raycast** — ray vs AABB / Circle / Polygon, returning parametric `t`,
  hit point, and surface normal.
- **Broadphase** — uniform spatial hash grid (`GridHash`) and loose quadtree
  (`QuadTree`), both producing candidate collision pairs.
- **Rigid body** — `RigidBody` with mass, inertia, restitution, damping,
  static/dynamic types; `World::step` integrates forces, runs broadphase +
  narrowphase, and resolves collisions with impulses + Baumgarte positional
  correction.

## Installation

```bash
moon add bubuki/mooncollider
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

## Run the demo

```bash
moon run cmd/main
```

Prints the height and velocity of a bouncing ball over 200 steps.

## Tests

```bash
moon test
```

The suite covers vector math, all shape operations, every narrowphase pair,
raycasting, both broadphase structures, and the rigid-body world (gravity,
bounce).

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
  raycast.mbt                  ray vs shape
  broadphase.mbt               GridHash + QuadTree
  body.mbt                     RigidBody + BodyDef
  world.mbt                    World::step + collision resolution
  mooncollider_test.mbt        blackbox tests (public API)
  cmd/main/                    runnable bounce demo
  docs/                        design notes + roadmap
```

## License

Apache-2.0.
