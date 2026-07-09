# MoonCollider Project Plan

This file is the recovery document for context compression. If the chat context is compressed, continue from here.

## Project identity

- Name: MoonCollider
- Full title: MoonCollider — 2D Game Physics and Collision Detection Library for MoonBit
- Chinese: MoonCollider：面向 MoonBit 的 2D 游戏物理与碰撞检测库
- Directory: `/mnt/d/bubuki/mooncollider`
- Language: MoonBit (wasm-gc preferred target)
- License: Apache-2.0
- Competition: 2026 MoonBit 国产基础软件生态开源大赛 / MoonBit 开源生态项目贡献赛

## Status: COMPLETE

All planned features implemented, tested, committed. Verification passes:
- `moon check` ✓
- `moon test` ✓ (30 tests, all pass)
- `moon info && git diff --exit-code` ✓ (clean)
- `moon fmt && git diff --exit-code` ✓ (clean)
- `moon run cmd/main` ✓ (bounce demo runs)

## What was built

### Library files (root package `bubuki/mooncollider`)
- `vec2.mbt` — Vec2 math (add/sub/scale/neg/dot/cross/length/normalize/perp/rotate/approx_eq)
- `shape.mbt` — AABB, Circle, Polygon (convex_hull/regular/box), Shape enum + dispatch
- `narrowphase.mbt` — all 9 shape-pair collisions (SAT for polygons) + Manifold + generic `collide()`
- `raycast.mbt` — ray vs AABB/Circle/Polygon + generic `raycast()`
- `broadphase.mbt` — GridHash (uniform grid) + QuadTree (loose quadtree)
- `body.mbt` — RigidBody + BodyDef (dynamic/static, mass, inertia, restitution, damping)
- `world.mbt` — World::step (integrate forces, broadphase, narrowphase, impulse + Baumgarte resolve)

### Tests
- `mooncollider_test.mbt` — 27 blackbox tests (public API): vec2, shapes, all narrowphase pairs, raycast, both broadphase, world gravity + bounce
- `mooncollider_wbtest.mbt` — 3 whitebox tests (internal helpers: cross3, closest_point_on_segment, point_in_polygon)

### Demo
- `cmd/main/` — bounce demo: ball under gravity bouncing on static floor, prints y/vy for 200 steps

### Docs / config
- `README.mbt.md` — full README with features, install, quick start, examples, verification
- `docs/design.md` — architecture, manifold convention, SAT, broadphase dedup, integration
- `docs/roadmap.md` — done + future (CCD, multi-contact, joints, sleeping, GJK/EPA)
- `.github/workflows/ci.yml` — CI: check/test/info-diff/fmt-diff/run
- `LICENSE` — Apache-2.0

## LOC
- ~2235 total (library + tests + demo)

## Toolchain

- Installed at: `~/.moon/bin/moon`
- Version: `moon 0.1.20260703 (6fbf8c3 2026-07-03)`
- Always prefix commands with: `PATH="$HOME/.moon/bin:$PATH"`

## MoonBit syntax reference (learned during build)

- Package root config: `moon.mod`; package config: `moon.pkg` (no `.json`)
- Import math: add `"moonbitlang/core/math"` to `moon.pkg`, call `@math.sin(x)` / `@math.cos(x)` / `@math.PI`
- `Double::abs(x)` is a method (builtin); `(x).sqrt()` is a method
- `Map` is builtin (prelude); empty literal `Map([])` (NOT `Map::new()` which is deprecated)
- `Map[K,V]` methods: `.get(k) -> V?`, `.set(k,v)`, `.contains(k)`, `.clear()`, `.each(fn(k,v){...})`
- `Array[T]` literal `[]`; `.push`, `.pop`, `.length`, `.make(n, v)`
- `pub(all) struct` = all fields + constructor visible; fields are immutable unless `mut`
- `pub enum` with payload: `Shape::AABB(AABB)`; construct via `Shape::AABB(x)` or match `(Shape::AABB(b), ...)`
- Derive: `derive(Eq, Debug)` (not Show — deprecated); `Hash` for hashmap keys
- For loop: `for i = 0; i < n; i = i + 1 { ... }`; while: `while cond { ... }`
- `not(x)` deprecated → use `!x`
- Float literal `1e-9` invalid → use `1.0e-9`
- `&mut` refs tricky; prefer returning values or passing `Array` (mutable reference type)
- `moon fmt` inserts `///|` before each `test` block; commit after fmt
- WSL mount: `git config core.filemode false` to avoid mode diffs

## Implementation order (completed)

1. ✓ Init project (moon new)
2. ✓ Vec2 + tests
3. ✓ Shape types (AABB, Circle, Polygon) + tests
4. ✓ AABB vs AABB / Circle vs Circle / AABB vs Circle + Manifold + tests
5. ✓ Polygon SAT + tests
6. ✓ Raycast (ray vs all shapes) + tests
7. ✓ Broadphase: uniform grid + tests
8. ✓ Broadphase: quadtree + tests
9. ✓ RigidBody + World::step + collision response + tests
10. ✓ Bounce demo
11. ✓ CI, README, docs, LICENSE
12. ✓ Full verification: moon check / test / info / fmt / run all pass
13. ✓ Whitebox tests for internal helpers
