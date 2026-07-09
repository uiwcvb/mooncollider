///|
/// Continuous collision detection (CCD).
///
/// Discrete collision detection (the default in `World::step`) can miss
/// collisions when a body moves further than its own size in a single step
/// ("tunneling"). CCD sweeps the body along its velocity vector and finds the
/// earliest time of impact, then advances the body only that far.
///
/// This module provides a standalone `ccd_sweep` function for manual use and
/// a `World::step_ccd` variant that applies CCD to all dynamic bodies.

///|
/// Result of a CCD sweep: the time of impact `t` in [0, 1] along the sweep,
/// the hit point, and the surface normal (pointing from B to A, opposing A's
/// motion).
pub(all) struct CCDSweep {
  /// Time of impact in [0, 1]. 1.0 means no hit within the sweep.
  t : Double
  /// World-space hit point.
  point : Vec2
  /// Normal at the hit, pointing against the swept body's motion.
  normal : Vec2
  /// Did the sweep hit anything?
  hit : Bool
}

///|
/// A miss result.
pub fn CCDSweep::miss() -> CCDSweep {
  { t: 1.0, point: Vec2::zero(), normal: Vec2::zero(), hit: false }
}

///|
/// Sweep a circle from `start` to `start + delta` against a static shape `b`.
/// Returns the earliest time of impact in [0, 1], or a miss.
///
/// For circle-vs-circle and circle-vs-AABB this uses a closed-form ray cast
/// on the Minkowski-expanded shape. For polygons it falls back to a sampled
/// sub-step sweep.
pub fn ccd_sweep_circle(
  radius : Double,
  start : Vec2,
  delta : Vec2,
  b : Shape,
) -> CCDSweep {
  match b {
    Shape::Circle(c) => ccd_circle_vs_circle(radius, start, delta, c)
    Shape::AABB(box) => ccd_circle_vs_aabb(radius, start, delta, box)
    Shape::Polygon(_) => ccd_circle_vs_polygon_sampled(radius, start, delta, b)
  }
}

///|
/// Circle vs circle CCD via ray-vs-circle on the Minkowski difference (which
/// is a circle of radius r1+r2 centered at c2).
fn ccd_circle_vs_circle(
  radius : Double,
  start : Vec2,
  delta : Vec2,
  c : Circle,
) -> CCDSweep {
  let expanded = Circle::new(c.center, c.radius + radius)
  let ray = Ray::new(start, delta)
  let h = raycast_circle(ray, expanded)
  if h.hit() && h.t <= 1.0 {
    { t: h.t, point: h.point, normal: h.normal.neg(), hit: true }
  } else {
    CCDSweep::miss()
  }
}

///|
/// Circle vs AABB CCD via ray-vs-AABB on the Minkowski-expanded box.
fn ccd_circle_vs_aabb(
  radius : Double,
  start : Vec2,
  delta : Vec2,
  box : AABB,
) -> CCDSweep {
  let expanded = AABB::new(box.center, box.half.add(Vec2::new(radius, radius)))
  let ray = Ray::new(start, delta)
  let h = raycast_aabb(ray, expanded)
  if h.hit() && h.t <= 1.0 {
    { t: h.t, point: h.point, normal: h.normal.neg(), hit: true }
  } else {
    CCDSweep::miss()
  }
}

///|
/// Circle vs polygon CCD via sub-stepping: sample the sweep at N points and
/// test discrete collision. Less precise than a closed form but works for
/// any convex polygon.
fn ccd_circle_vs_polygon_sampled(
  radius : Double,
  start : Vec2,
  delta : Vec2,
  b : Shape,
) -> CCDSweep {
  let steps = 32
  let mut prev_t = 0.0
  for i = 1; i <= steps; i = i + 1 {
    let t = i.to_double() / steps.to_double()
    let center = start.add(delta.scale(t))
    let moving = Shape::Circle(Circle::new(center, radius))
    let m = collide(moving, b)
    if m.colliding() {
      // Binary-search refine in [prev_t, t].
      let mut lo = prev_t
      let mut hi = t
      let mut bi = 0
      while bi < 16 {
        bi = bi + 1
        let mid = (lo + hi) * 0.5
        let cm = start.add(delta.scale(mid))
        let mm = collide(Shape::Circle(Circle::new(cm, radius)), b)
        if mm.colliding() {
          hi = mid
        } else {
          lo = mid
        }
      }
      let point = start.add(delta.scale(hi))
      return { t: hi, point, normal: m.normal.neg(), hit: true }
    }
    prev_t = t
  }
  CCDSweep::miss()
}

///|
/// Sweep an AABB from `start_center` by `delta` against a static shape `b`.
/// Uses sub-stepping for all shape types.
pub fn ccd_sweep_aabb(
  half : Vec2,
  start_center : Vec2,
  delta : Vec2,
  b : Shape,
) -> CCDSweep {
  let steps = 32
  let mut prev_t = 0.0
  for i = 1; i <= steps; i = i + 1 {
    let t = i.to_double() / steps.to_double()
    let center = start_center.add(delta.scale(t))
    let moving = Shape::AABB(AABB::new(center, half))
    let m = collide(moving, b)
    if m.colliding() {
      let mut lo = prev_t
      let mut hi = t
      let mut bi = 0
      while bi < 16 {
        bi = bi + 1
        let mid = (lo + hi) * 0.5
        let cm = start_center.add(delta.scale(mid))
        let mm = collide(Shape::AABB(AABB::new(cm, half)), b)
        if mm.colliding() {
          hi = mid
        } else {
          lo = mid
        }
      }
      let point = start_center.add(delta.scale(hi))
      return { t: hi, point, normal: m.normal.neg(), hit: true }
    }
    prev_t = t
  }
  CCDSweep::miss()
}
