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

## Why this project

Competition official recommended directions include game engine bindings and game tooling. After scanning mooncakes.io, the following are already taken:

- game engine binding: MoonPhaserKit (Phaser3)
- pathfinding: wzx2007/moonpath
- linear algebra: Luna-Flow/linear-algebra
- 3D geometry: Luna-Flow/geometry3d
- animation engine: CAIMEOX/Motiva

Nobody has built a 2D collision detection or physics library for MoonBit. MoonCollider fills that gap.

It is a pure-logic library, no rendering, no native backend, no async. Works on wasm-gc and js backends.

## What it does (concrete)

A 2D game physics and collision toolkit:

1. Vector math: Vec2 add/sub/scale/dot/cross/normalize/length/rotate
2. Shapes: AABB (axis-aligned box), Circle, convex Polygon
3. Narrowphase collision:
   - AABB vs AABB
   - Circle vs Circle
   - AABB vs Circle
   - Polygon vs Polygon (SAT — Separating Axis Theorem)
   - AABB vs Polygon
4. Raycast: ray vs AABB, ray vs Circle, ray vs Polygon, hit point + normal + distance
5. Broadphase:
   - uniform grid hash
   - quadtree
6. Lightweight rigid body:
   - position, velocity, acceleration
   - gravity
   - collision response: bounce with restitution, penetration separation
7. World: step function that integrates bodies, runs broadphase + narrowphase, resolves collisions

Target code size: 3~5k LOC MoonBit (not counting tests).

## Competition facts

Official pages:
- GitLink: https://www.gitlink.org.cn/competitions/track1_2026MoonBit
- OSC2026: https://moonbitlang.github.io/OSC2026/

Requirements:
- MoonBit as main language
- public repo
- clear README
- runnable examples
- CI
- tests
- publish to mooncakes.io
- recommended 4~10k effective MoonBit LOC

CI hard requirements (from pre-acceptance feedback):
```bash
moon check
moon test
moon info && git diff --exit-code
```

CI soft / bonus:
```bash
moon fmt && git diff --exit-code
```

Do NOT use `moon fmt --deny-warn` or `moon info --deny-warn` — current toolchain (moon 0.1.20260703) does not support `--deny-warn` for those subcommands.

Judge will `moon add` the package and try to use it per README. Must produce reasonable results.

## Toolchain

Installed at: `~/.moon/bin/moon`
Version: `moon 0.1.20260703 (6fbf8c3 2026-07-03)`

Always prefix commands with:
```bash
PATH="$HOME/.moon/bin:$PATH"
```

## Directory layout (planned)

```
mooncollider/
  moon.mod
  moon.pkg
  mooncollider.mbt          # root library package
  mooncollider_test.mbt
  pkg.generated.mbti
  cmd/main/                 # runnable demo
    moon.pkg
    main.mbt
  examples/
    bounce/                 # gravity + bounce demo
    stacking/               # box stacking demo
    raycast/                # raycast visualization demo
  docs/
    design.md
    roadmap.md
  .github/workflows/ci.yml
  README.md
  README.mbt.md
  LICENSE
  .gitignore
```

## MoonBit syntax reference (learned from previous project)

- Package root config: `moon.mod` (not `moon.mod.json`)
- Package config: `moon.pkg` (not `moon.pkg.json`)
- Import syntax in moon.pkg:
  ```
  import {
    "bubuki/mooncollider"
  }
  ```
- Public struct with all fields visible: `pub(all) struct Foo { ... }`
- Public enum with all constructors visible: `pub(all) enum Foo { ... }`
- Derive: `derive(Eq, Debug)` — use `Debug` not `Show` (Show is deprecated)
- Struct literal needs trailing comma for single field: `{ value, }`
- Test syntax: `test "name" { ... }`
- Inspect: `inspect(value, content="expected")`
- Main: `fn main { ... }` (no parens needed)
- Mutable local: `let mut x = 0`
- While loop: `while i < n { ... }`
- For loop pattern: `for i = start, x = init; cond; { continue new_i, new_x }`
- Array: `Array[T]`, push/pop/length/index
- String concat: `+`
- Int to string: `to_string()`
- Format check: `moon fmt --check`
- Format write: `moon fmt`
- Info generate: `moon info`
- `moon fmt` reformats doc comments from `///| text` to `///|\n/// text`
- After `moon fmt`, import alias `@name` gets removed, package referenced by last path segment
- `git config core.filemode false` needed on WSL mounts to avoid mode diff noise

## Implementation order

1. Init project: moon.mod, moon.pkg, empty .mbt, cmd/main, moon check passes
2. Vec2 + tests
3. Shape types (AABB, Circle, Polygon) + tests
4. AABB vs AABB collision + manifold + tests
5. Circle vs Circle + tests
6. AABB vs Circle + tests
7. Polygon SAT + tests
8. Raycast (ray vs AABB/Circle/Polygon) + tests
9. Broadphase: uniform grid hash + tests
10. Broadphase: quadtree + tests
11. RigidBody + World::step + collision response + tests
12. Demos: bounce, stacking, raycast
13. CI, README, docs, LICENSE
14. Full verification: moon check / fmt / info / test / run all demos
15. Temp git repo CI simulation

## Abandoned previous project

MoonAct (deterministic actor simulation) was abandoned because:
- code too small (~800 LOC) for a "framework" track
- concept too narrow (only FIFO + drop/delay)
- abstract, hard to understand at a glance
- risk of collision with other actor/simulation submissions

Old moonact directory was deleted and replaced by mooncollider.
