# MoonCollider Design Notes

## Goals

- Pure-logic 2D collision and physics for MoonBit; no rendering, no native deps.
- Run on every MoonBit target (wasm-gc, js, native).
- Cover the full pipeline: shapes, narrowphase, broadphase, solver, joints, CCD.
- Stable enough for stacking demos with 5+ boxes.

## Architecture

Five layers, each independently usable:

1. **Base layer** — `Vec2` math, `Shape` enum (AABB/Circle/Polygon), `RigidBody`.
2. **Narrowphase** — `collide()` dispatches all 9 shape pairs via SAT;
   `collide_gjk()` provides GJK+EPA for arbitrary convex shapes. Output:
   `Manifold` with normal, depth, and up to 2 contact points.
3. **Broadphase** — `GridHash` (uniform grid), `QuadTree` (loose quadtree),
   `SweepAndPrune` (sort-sweep), `AABBTree` (dynamic tree with remove/update).
4. **Solver** — `World::step` runs sequential-impulse: integrate forces →
   broadphase → narrowphase → velocity solve (12 iterations) → integrate
   positions → position solve (4 Baumgarte iterations).
5. **Constraints** — `Distance`, `Revolute`, `Weld` joints; CCD sweep for
   tunneling prevention.

## Key design decisions

- **2-point contact manifolds** for stable stacking (single-point causes
  pivoting).
- **AABB shapes do not rotate** — angular velocity is zeroed each step to
  prevent friction-induced phantom rotation. Use `Polygon::box` if you need
  rotating boxes.
- **Position correction re-evaluates penetration** from current positions
  each iteration, converging to a non-penetrating state.
- **CCD normal points from B toward A** (opposing the swept body's motion),
  consistent with raycast normals.

## References

- Box2D (MIT): solver architecture, Baumgarte, manifold generation.
- Real-Time Collision Detection (Ericson): SAT, GJK, EPA, CCD theory.

## Limitations

- No sleeping / islanding for large worlds.
- No serialization.
- CCD uses sub-stepping for polygon targets (closed-form for circle/AABB).
