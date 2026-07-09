// Web demo bindings: exposes a flat C-like API over MoonCollider's World
// so that JavaScript / Canvas can drive the real MoonBit physics engine.
// This is NOT a mock — `web_step` calls `World::step` which runs the full
// sequential-impulse solver, SAT narrowphase, broadphase, friction, joints.

///|
struct WorldHolder {
  mut w : @mooncollider.World
}

///|
let holder : WorldHolder = WorldHolder::new()

///|
fn WorldHolder::new() -> WorldHolder {
  { w: @mooncollider.World::new() }
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
fn web_init() -> Unit {
  holder.w = @mooncollider.World::new()
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
  // ponytail: no remove API on World yet; re-init if needed via web_clear
  ignore(id)
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
}

///|
fn main {
  holder.w = @mooncollider.World::new()
  register_all()
}
