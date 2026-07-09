# MoonCollider Design Notes

## Goals

- Pure-logic 2D collision and physics for MoonBit; no rendering, no native deps.
- Run on every MoonBit target (wasm-gc, js, native).
- Small, readable, well-tested. Target ~3–5k LOC of library code.

## Architecture

```
vec2.mbt          ──┐
shape.mbt          ─┼─ geometry primitives shared by all layers
narrowphase.mbt    ─┤─ pairwise collision -> Manifold
raycast.mbt        ─┤─ ray vs shape -> RaycastHit
broadphase.mbt     ─┤─ GridHash / QuadTree -> candidate pairs
body.mbt           ─┤─ RigidBody kinematics + shape transform
world.mbt          ─┴─ World::step orchestrator
```

Each layer depends only on the layers below it. `vec2` and `shape` have no
dependencies on the rest. `narrowphase` and `raycast` depend on `shape`.
`broadphase` depends on `shape` (AABB only). `body` depends on `shape` and
`vec2`. `world` depends on everything.

## Key design choices

### Manifold convention

Every narrowphase function returns a `Manifold { normal, depth, contact }`
where `normal` **points from A to B**. This is the direction B should be
pushed along to separate the pair. `depth` is the penetration depth (>= 0;
0 means no collision). `contact` is a representative world-space contact
point, used for torque in the impulse solver.

### SAT for polygons

`collide_polygon_polygon` projects both polygons onto every edge normal of
both polygons. The axis with the smallest overlap is the separating axis;
if any axis has zero or negative overlap, the polygons don't collide. The
normal is re-oriented to point from A to B using the centroid vector.

### Broadphase pair dedup

Both `GridHash` and `QuadTree` return pairs with `a < b`, deduplicated via a
`Map[(Int, Int), Unit]`. This keeps the narrowphase from seeing the same
pair twice.

### Rigid body integration

`World::step(dt)`:
1. Integrate forces → velocities (gravity, accumulated force, damping).
2. Integrate velocities → positions, update AABBs.
3. Broadphase: insert all bodies into a `GridHash`, collect candidate pairs.
4. Narrowphase + resolve: for each pair, run `collide` and, if colliding,
   apply positional correction (Baumgarte) and an impulse at the contact.

Static bodies have `inv_mass = 0` and are skipped in integration; they still
participate in collision as immovable obstacles.

### Why not a full constraint solver

The impulse solver handles one contact per pair per step. This is enough for
bouncing balls, sliding boxes, and simple stacking. A full sequential-impulse
solver with multiple contacts and joints is a future extension (see roadmap).

## Limitations

- No continuous collision detection (tunneling possible at high speeds).
- One contact point per pair (no contact manifolds with two points).
- No joints or constraints beyond contact.
- No sleeping.
- Polygon-polygon collision assumes convex polygons.
