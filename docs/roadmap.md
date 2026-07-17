# MoonCollider Roadmap

## Done

- Vec2 math
- Shapes: AABB, Circle, convex Polygon (convex_hull, regular, box)
- Narrowphase: all 9 shape pairs via SAT, 2-point contact manifolds
- GJK + EPA for arbitrary convex shapes
- Raycast: ray vs AABB/Circle/Polygon
- Broadphase: GridHash, QuadTree, SweepAndPrune, AABBTree (with remove/update)
- Rigid body: mass, inertia, restitution, friction, damping
- Sequential-impulse solver: 12 velocity iterations, 4 position iterations
- Baumgarte position correction (re-evaluates penetration per iteration)
- AABB bodies zero angular velocity (no phantom rotation)
- Joints: Distance, Revolute, Weld
- CCD: circle/AABB sweep (closed-form + sub-stepping for polygons)
- Body removal: World::remove_body with alive flag
- Fuzz testing: random shapes, degenerate geometry, NaN/Inf, energy divergence
- Determinism: cross-platform snapshot tests
- Web demo: interactive sandbox driven by real MoonCollider engine (JS target)
- Published to mooncakes.io as uiwcvb/mooncollider@0.1.0

## Future

- Sleeping / islanding for large worlds
- Serialization of world state
- Spatial query API (point query, AABB query, shape cast)
- Closed-form CCD for polygon targets
- Contact persistence / warm starting
- Soft constraints (frequency/damping ratio) for joints
