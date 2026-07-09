# MoonCollider Roadmap

## Done

- Vec2 math
- AABB / Circle / Polygon shapes (convex hull, regular, box builders)
- Narrowphase: all 9 shape-pair collisions via SAT + closest-point
- GJK + EPA generic convex collision
- Raycast: ray vs AABB / Circle / Polygon
- Broadphase: uniform grid hash + loose quadtree + sweep-and-prune + dynamic AABB tree
- RigidBody: mass, inertia, restitution, friction, damping, static/dynamic
- World::step: integration + broadphase + narrowphase + impulse + friction + Baumgarte resolution
- Bounce demo, stacking demo, raycast demo, batch collision example
- CI, README, tests (40 blackbox + whitebox)

## Future

- Continuous collision detection (CCD) to prevent tunneling at high speeds.
- Multi-contact manifolds (two contact points per pair) for stable stacking.
- Joints: revolute, prismatic, distance, weld.
- Islanding + sleeping for large worlds.
- Broadphase: dynamic AABB tree as a third option.
- Narrowphase: GJK + EPA for general convex shapes (currently SAT only).
- Broadphase: sweep-and-prune as a simple alternative.
- Serialization of world state.
- Optional spatial query API (point query, AABB query).
