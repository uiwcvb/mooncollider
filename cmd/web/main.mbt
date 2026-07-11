// Web demo bindings: exposes a flat C-like API over MoonCollider's World
// so that JavaScript / Canvas can drive the real MoonBit physics engine.
// This is NOT a mock — `web_step` calls `World::step` which runs the full
// sequential-impulse solver, SAT narrowphase, broadphase, friction, joints.

///|
struct WorldHolder {
  mut w : @mooncollider.World
  mut drag_id : Int // -1 = not dragging
  mut drag_target : @mooncollider.Vec2
}

///|
let holder : WorldHolder = WorldHolder::new()

///|
fn WorldHolder::new() -> WorldHolder {
  {
    w: @mooncollider.World::new(),
    drag_id: -1,
    drag_target: @mooncollider.Vec2::zero(),
  }
}

///|
#external
type JSRef

///|
extern "js" fn js_global(name : String) -> JSRef =
  #|(name) => (globalThis[name] = globalThis[name] || {})

///|
extern "js" fn js_set(obj : JSRef, key : String, val : JSRef) -> Unit =
  #|(obj, key, val) => { obj[key] = val }

///|
extern "js" fn js_wrap0(f : () -> Unit) -> JSRef =
  #|(f) => () => f()

///|
extern "js" fn js_wrap0i(f : () -> Int) -> JSRef =
  #|(f) => () => f()

///|
extern "js" fn js_wrap1d(f : (Double) -> Unit) -> JSRef =
  #|(f) => (a) => f(a)

///|
extern "js" fn js_wrapid(f : (Int) -> Double) -> JSRef =
  #|(f) => (a) => f(a)

///|
extern "js" fn js_wrapii(f : (Int) -> Int) -> JSRef =
  #|(f) => (a) => f(a)

///|
extern "js" fn js_wrapiu(f : (Int) -> Unit) -> JSRef =
  #|(f) => (a) => f(a)

///|
extern "js" fn js_wrap4di(f : (Double, Double, Double, Double) -> Int) -> JSRef =
  #|(f) => (a, b, c, d) => f(a, b, c, d)

///|
extern "js" fn js_wrap5di(
  f : (Double, Double, Double, Double, Double) -> Int,
) -> JSRef =
  #|(f) => (a, b, c, d, e) => f(a, b, c, d, e)

///|
extern "js" fn js_wrap2du(f : (Double, Double) -> Unit) -> JSRef =
  #|(f) => (a, b) => f(a, b)

///|
extern "js" fn js_wrap3idu(f : (Int, Double, Double) -> Unit) -> JSRef =
  #|(f) => (a, b, c) => f(a, b, c)

///|
extern "js" fn js_wrap2di(f : (Double, Double) -> Int) -> JSRef =
  #|(f) => (a, b) => f(a, b)

///|
extern "js" fn js_wrap1i(f : (Int) -> Unit) -> JSRef =
  #|(f) => (a) => f(a)

///|
extern "js" fn js_wrap2d1i(f : (Int, Double, Double) -> Unit) -> JSRef =
  #|(f) => (a, b, c) => f(a, b, c)

///|
fn web_init() -> Unit {
  holder.w = @mooncollider.World::new()
  holder.drag_id = -1
}

///|
fn web_add_ball(x : Double, y : Double, radius : Double, mass : Double) -> Int {
  holder.w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(x, y),
      @mooncollider.Shape::from_circle(
        @mooncollider.Circle::new(@mooncollider.Vec2::zero(), radius),
      ),
      mass,
      0.6,
    ),
  )
}

///|
fn web_add_box(
  x : Double,
  y : Double,
  hw : Double,
  hh : Double,
  mass : Double,
) -> Int {
  holder.w.add_body(
    @mooncollider.BodyDef::dynamic(
      @mooncollider.Vec2::new(x, y),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::from_min_max(
          @mooncollider.Vec2::new(-hw, -hh),
          @mooncollider.Vec2::new(hw, hh),
        ),
      ),
      mass,
      0.4,
    ),
  )
}

///|
fn web_add_wall(x : Double, y : Double, hw : Double, hh : Double) -> Int {
  holder.w.add_body(
    @mooncollider.BodyDef::static_(
      @mooncollider.Vec2::new(x, y),
      @mooncollider.Shape::from_aabb(
        @mooncollider.AABB::from_min_max(
          @mooncollider.Vec2::new(-hw, -hh),
          @mooncollider.Vec2::new(hw, hh),
        ),
      ),
    ),
  )
}

///|
fn web_step(dt : Double) -> Unit {
  // Apply spring force for active drag (mouse joint)
  if holder.drag_id >= 0 {
    let b = holder.w.body(holder.drag_id)
    if not(b.is_static()) {
      let dx = holder.drag_target.x - b.position.x
      let dy = holder.drag_target.y - b.position.y
      // spring: F = k * displacement - c * velocity
      let k = 40.0 * b.mass
      let c = 10.0 * b.mass
      let fx = k * dx - c * b.velocity.x
      let fy = k * dy - c * b.velocity.y
      b.apply_force(@mooncollider.Vec2::new(fx, fy))
    }
  }
  holder.w.step(dt)
}

///|
fn web_body_count() -> Int {
  holder.w.body_count()
}

///|
fn web_get_x(id : Int) -> Double {
  holder.w.body(id).position.x
}

///|
fn web_get_y(id : Int) -> Double {
  holder.w.body(id).position.y
}

///|
fn web_get_vx(id : Int) -> Double {
  holder.w.body(id).velocity.x
}

///|
fn web_get_vy(id : Int) -> Double {
  holder.w.body(id).velocity.y
}

///|
fn web_get_angle(id : Int) -> Double {
  holder.w.body(id).angle
}

///|
fn web_get_radius(id : Int) -> Double {
  let b = holder.w.body(id)
  match b.world_shape() {
    @mooncollider.Shape::Circle(c) => c.radius
    _ => 0.0
  }
}

///|
fn web_get_half_w(id : Int) -> Double {
  let b = holder.w.body(id)
  match b.world_shape() {
    @mooncollider.Shape::AABB(a) => a.half.x
    _ => 0.0
  }
}

///|
fn web_get_half_h(id : Int) -> Double {
  let b = holder.w.body(id)
  match b.world_shape() {
    @mooncollider.Shape::AABB(a) => a.half.y
    _ => 0.0
  }
}

///|
fn web_get_type(id : Int) -> Int {
  // 0 = ball (circle), 1 = box (aabb), 2 = wall (static)
  let b = holder.w.body(id)
  if b.is_static() {
    2
  } else {
    match b.world_shape() {
      @mooncollider.Shape::Circle(_) => 0
      _ => 1
    }
  }
}

///|
fn web_clear() -> Unit {
  web_init()
}

///|
fn web_set_gravity(x : Double, y : Double) -> Unit {
  holder.w.set_gravity(@mooncollider.Vec2::new(x, y))
}

///|
fn web_apply_impulse(id : Int, ix : Double, iy : Double) -> Unit {
  holder.w.body(id).apply_linear_impulse(@mooncollider.Vec2::new(ix, iy))
}

///|
fn web_remove_body(id : Int) -> Unit {
  holder.w.remove_body(id)
}

///|
fn web_pick_body(x : Double, y : Double) -> Int {
  // Returns the topmost dynamic body containing (x,y), or -1.
  let n = holder.w.body_count()
  let mut found = -1
  for i = 0; i < n; i = i + 1 {
    let b = holder.w.body(i)
    if b.is_static() {
      continue
    }
    let s = b.world_shape()
    match s {
      @mooncollider.Shape::Circle(c) =>
        if c.contains(@mooncollider.Vec2::new(x, y)) {
          found = i
        }
      @mooncollider.Shape::AABB(a) =>
        if a.contains(@mooncollider.Vec2::new(x, y)) {
          found = i
        }
      _ => {
        let aabb = s.aabb()
        if aabb.contains(@mooncollider.Vec2::new(x, y)) {
          found = i
        }
      }
    }
  }
  found
}

///|
fn web_drag_start(id : Int, x : Double, y : Double) -> Unit {
  holder.drag_id = id
  holder.drag_target = @mooncollider.Vec2::new(x, y)
}

///|
fn web_drag_to(x : Double, y : Double) -> Unit {
  holder.drag_target = @mooncollider.Vec2::new(x, y)
}

///|
fn web_drop() -> Unit {
  holder.drag_id = -1
}

///|
fn register_all() -> Unit {
  let g = js_global("MoonCollider")
  js_set(g, "web_init", js_wrap0(web_init))
  js_set(g, "web_add_ball", js_wrap4di(web_add_ball))
  js_set(g, "web_add_box", js_wrap5di(web_add_box))
  js_set(g, "web_add_wall", js_wrap4di(web_add_wall))
  js_set(g, "web_step", js_wrap1d(web_step))
  js_set(g, "web_body_count", js_wrap0i(web_body_count))
  js_set(g, "web_get_x", js_wrapid(web_get_x))
  js_set(g, "web_get_y", js_wrapid(web_get_y))
  js_set(g, "web_get_vx", js_wrapid(web_get_vx))
  js_set(g, "web_get_vy", js_wrapid(web_get_vy))
  js_set(g, "web_get_angle", js_wrapid(web_get_angle))
  js_set(g, "web_get_radius", js_wrapid(web_get_radius))
  js_set(g, "web_get_half_w", js_wrapid(web_get_half_w))
  js_set(g, "web_get_half_h", js_wrapid(web_get_half_h))
  js_set(g, "web_get_type", js_wrapii(web_get_type))
  js_set(g, "web_clear", js_wrap0(web_clear))
  js_set(g, "web_set_gravity", js_wrap2du(web_set_gravity))
  js_set(g, "web_apply_impulse", js_wrap3idu(web_apply_impulse))
  js_set(g, "web_remove_body", js_wrapiu(web_remove_body))
  js_set(g, "web_pick_body", js_wrap2di(web_pick_body))
  js_set(g, "web_drag_start", js_wrap3idu(web_drag_start))
  js_set(g, "web_drag_to", js_wrap2du(web_drag_to))
  js_set(g, "web_drop", js_wrap0(web_drop))
}

///|
fn main {
  holder.w = @mooncollider.World::new()
  register_all()
}
