(() => {
  function _M0TP46uiwcvb12mooncollider3cmd3web13CurrentHolder(param0) {
    this.v = param0;
  }
  const _M0FPB12random__seed = () => {
    if (globalThis.crypto?.getRandomValues) {
      const array = new Uint32Array(1);
      globalThis.crypto.getRandomValues(array);
      return array[0] | 0; // Convert to signed 32
    } else {
      return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
    }
  };
  function _M0TPB6Hasher(param0) {
    this.acc = param0;
  }
  const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
  class $PanicError extends Error {}
  function $panic() {
    throw new $PanicError();
  }
  function $make_array_len_and_init(a, b) {
    const arr = new Array(a);
    arr.fill(b);
    return arr;
  }
  function _M0TPB3MapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(param0, param1, param2, param3, param4, param5, param6) {
    this.entries = param0;
    this.size = param1;
    this.capacity = param2;
    this.capacity_mask = param3;
    this.grow_at = param4;
    this.head = param5;
    this.tail = param6;
  }
  function _M0TPB3MapGUiiEuE(param0, param1, param2, param3, param4, param5, param6) {
    this.entries = param0;
    this.size = param1;
    this.capacity = param2;
    this.capacity_mask = param3;
    this.grow_at = param4;
    this.head = param5;
    this.tail = param6;
  }
  function $bound_check(arr, index) {
    if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
  }
  function _M0TPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(param0, param1, param2, param3, param4, param5) {
    this.prev = param0;
    this.next = param1;
    this.psl = param2;
    this.hash = param3;
    this.key = param4;
    this.value = param5;
  }
  function _M0TPB5EntryGUiiEuE(param0, param1, param2, param3, param4, param5) {
    this.prev = param0;
    this.next = param1;
    this.psl = param2;
    this.hash = param3;
    this.key = param4;
    this.value = param5;
  }
  function _M0DTPC16option6OptionGRPB5ArrayGiEE4None() {}
  _M0DTPC16option6OptionGRPB5ArrayGiEE4None.prototype.$tag = 0;
  const _M0DTPC16option6OptionGRPB5ArrayGiEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGiEE4None();
  function _M0DTPC16option6OptionGRPB5ArrayGiEE4Some(param0) {
    this._0 = param0;
  }
  _M0DTPC16option6OptionGRPB5ArrayGiEE4Some.prototype.$tag = 1;
  function _M0TP26uiwcvb12mooncollider4Vec2(param0, param1) {
    this.x = param0;
    this.y = param1;
  }
  function _M0TP26uiwcvb12mooncollider5World(param0, param1, param2, param3, param4, param5, param6) {
    this.gravity = param0;
    this.bodies = param1;
    this.joints = param2;
    this.grid_cell_size = param3;
    this.velocity_iterations = param4;
    this.position_correction = param5;
    this.slop = param6;
  }
  function _M0TPB8MutLocalGdE(param0) {
    this.val = param0;
  }
  function _M0TP26uiwcvb12mooncollider4AABB(param0, param1) {
    this.center = param0;
    this.half = param1;
  }
  function _M0TP26uiwcvb12mooncollider6Circle(param0, param1) {
    this.center = param0;
    this.radius = param1;
  }
  function _M0TP26uiwcvb12mooncollider7Polygon(param0, param1) {
    this.vertices = param0;
    this.normals = param1;
  }
  function _M0DTP26uiwcvb12mooncollider5Shape4AABB(param0) {
    this._0 = param0;
  }
  _M0DTP26uiwcvb12mooncollider5Shape4AABB.prototype.$tag = 0;
  function _M0DTP26uiwcvb12mooncollider5Shape6Circle(param0) {
    this._0 = param0;
  }
  _M0DTP26uiwcvb12mooncollider5Shape6Circle.prototype.$tag = 1;
  function _M0DTP26uiwcvb12mooncollider5Shape7Polygon(param0) {
    this._0 = param0;
  }
  _M0DTP26uiwcvb12mooncollider5Shape7Polygon.prototype.$tag = 2;
  function _M0TP26uiwcvb12mooncollider9RigidBody(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19) {
    this.id = param0;
    this.body_type = param1;
    this.position = param2;
    this.angle = param3;
    this.velocity = param4;
    this.angular_velocity = param5;
    this.force = param6;
    this.torque = param7;
    this.mass = param8;
    this.inv_mass = param9;
    this.inertia = param10;
    this.inv_inertia = param11;
    this.restitution = param12;
    this.friction = param13;
    this.linear_damping = param14;
    this.angular_damping = param15;
    this.shape = param16;
    this.aabb = param17;
    this.gravity_scale = param18;
    this.alive = param19;
  }
  function _M0TP26uiwcvb12mooncollider8Manifold(param0, param1, param2, param3) {
    this.normal = param0;
    this.depth = param1;
    this.contact = param2;
    this.contact2 = param3;
  }
  function _M0TPB8MutLocalGiE(param0) {
    this.val = param0;
  }
  function _M0TPB8MutLocalGRP26uiwcvb12mooncollider4Vec2E(param0) {
    this.val = param0;
  }
  function _M0TP26uiwcvb12mooncollider7Contact(param0, param1, param2, param3, param4, param5) {
    this.a = param0;
    this.b = param1;
    this.normal = param2;
    this.contact_point = param3;
    this.restitution = param4;
    this.friction = param5;
  }
  function _M0TP26uiwcvb12mooncollider13RevoluteJoint(param0, param1, param2, param3) {
    this.a = param0;
    this.b = param1;
    this.local_anchor_a = param2;
    this.local_anchor_b = param3;
  }
  function _M0TP26uiwcvb12mooncollider7CellKey(param0, param1) {
    this.cx = param0;
    this.cy = param1;
  }
  function _M0TP26uiwcvb12mooncollider8GridHash(param0, param1) {
    this.cell_size = param0;
    this.cells = param1;
  }
  function _M0TPB9ArrayViewGURP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEEE(param0, param1, param2) {
    this.buf = param0;
    this.start = param1;
    this.end = param2;
  }
  function _M0TPB9ArrayViewGUUiiEuEE(param0, param1, param2) {
    this.buf = param0;
    this.start = param1;
    this.end = param2;
  }
  function _M0TP26uiwcvb12mooncollider7BodyDef(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9) {
    this.body_type = param0;
    this.position = param1;
    this.angle = param2;
    this.shape = param3;
    this.mass = param4;
    this.restitution = param5;
    this.friction = param6;
    this.linear_damping = param7;
    this.angular_damping = param8;
    this.gravity_scale = param9;
  }
  function _M0TP46uiwcvb12mooncollider3cmd3web9WorldSlot(param0, param1, param2) {
    this.w = param0;
    this.drag_id = param1;
    this.drag_target = param2;
  }
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__global = (name) => (globalThis[name] = globalThis[name] || {});
  const _M0FP46uiwcvb12mooncollider3cmd3web7js__set = (obj, key, val) => { obj[key] = val };
  const _M0FP46uiwcvb12mooncollider3cmd3web9js__wrap0 = (f) => () => f();
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap1i = (f) => (a) => f(a);
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap0i = (f) => () => f();
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap1d = (f) => (a) => f(a);
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid = (f) => (a) => f(a);
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapii = (f) => (a) => f(a);
  const _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapiu = (f) => (a) => f(a);
  const _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap4di = (f) => (a, b, c, d) => f(a, b, c, d);
  const _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap5di = (f) => (a, b, c, d, e) => f(a, b, c, d, e);
  const _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap2du = (f) => (a, b) => f(a, b);
  const _M0FP46uiwcvb12mooncollider3cmd3web12js__wrap3idu = (f) => (a, b, c) => f(a, b, c);
  const _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap2di = (f) => (a, b) => f(a, b);
  const _M0FP46uiwcvb12mooncollider3cmd3web5slots = [];
  const _M0FP46uiwcvb12mooncollider3cmd3web7current = new _M0TP46uiwcvb12mooncollider3cmd3web13CurrentHolder(0);
  const _M0FPB4seed = _M0FPB12random__seed();
  function _M0FPB4rotl(x, r) {
    return x << r | (x >>> (32 - r | 0) | 0);
  }
  function _M0FPB13consume4__acc(acc, input) {
    return Math.imul(_M0FPB4rotl((acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0, 17), 668265263) | 0;
  }
  function _M0MPB6Hasher8consume4(self, input) {
    self.acc = _M0FPB13consume4__acc(self.acc, input);
  }
  function _M0MPB6Hasher13combine__uint(self, value) {
    self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
    _M0MPB6Hasher8consume4(self, value);
  }
  function _M0MPB6Hasher12combine__int(self, value) {
    _M0MPB6Hasher13combine__uint(self, value);
  }
  function _M0MPB6Hasher7combineGRP26uiwcvb12mooncollider7CellKeyE(self, value) {
    _M0IP26uiwcvb12mooncollider7CellKeyPB4Hash13hash__combine(value, self);
  }
  function _M0MPB6Hasher7combineGUiiEE(self, value) {
    _M0IPC15tuple6Tuple2PB4Hash13hash__combineGiiE(value, self);
  }
  function _M0MPB6Hasher7combineGiE(self, value) {
    _M0IPC13int3IntPB4Hash13hash__combine(value, self);
  }
  function _M0IPC15tuple6Tuple2PB4Hash13hash__combineGiiE(self, hasher) {
    const _a = self._0;
    const _b = self._1;
    _M0MPB6Hasher7combineGiE(hasher, _a);
    _M0MPB6Hasher7combineGiE(hasher, _b);
  }
  function _M0IPC15tuple6Tuple2PB2Eq5equalGiiE(self, other) {
    return self._0 === other._0 && self._1 === other._1;
  }
  function _M0MPB6Hasher14Hasher_2einner(seed) {
    return new _M0TPB6Hasher((seed >>> 0) + (374761393 >>> 0) | 0);
  }
  function _M0MPB6Hasher6Hasher(seed$46$opt) {
    let seed;
    if (seed$46$opt === undefined) {
      seed = _M0FPB4seed;
    } else {
      const _Some = seed$46$opt;
      seed = _Some;
    }
    return _M0MPB6Hasher14Hasher_2einner(seed);
  }
  function _M0FPB14avalanche__acc(acc) {
    let acc$2 = acc;
    acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
    acc$2 = Math.imul(acc$2, -2048144777) | 0;
    acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
    acc$2 = Math.imul(acc$2, -1028477379) | 0;
    acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
    return acc$2;
  }
  function _M0FPB13finalize__acc(acc) {
    return _M0FPB14avalanche__acc(acc);
  }
  function _M0MPB6Hasher8finalize(self) {
    return _M0FPB13finalize__acc(self.acc);
  }
  function _M0IP016_24default__implPB4Hash4hashGRP26uiwcvb12mooncollider7CellKeyE(self) {
    const h = _M0MPB6Hasher6Hasher(undefined);
    _M0MPB6Hasher7combineGRP26uiwcvb12mooncollider7CellKeyE(h, self);
    return _M0MPB6Hasher8finalize(h);
  }
  function _M0IP016_24default__implPB4Hash4hashGUiiEE(self) {
    const h = _M0MPB6Hasher6Hasher(undefined);
    _M0MPB6Hasher7combineGUiiEE(h, self);
    return _M0MPB6Hasher8finalize(h);
  }
  function _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self, value) {
    _M0MPB7JSArray4push(self, value);
  }
  function _M0MPC15array5Array4pushGiE(self, value) {
    _M0MPB7JSArray4push(self, value);
  }
  function _M0MPC16option6Option6unwrapGRPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEEE(self) {
    if (self === undefined) {
      return $panic();
    } else {
      const _Some = self;
      return _Some;
    }
  }
  function _M0FPB21calc__grow__threshold(capacity) {
    if (16 === 0) {
      $panic();
    }
    return (Math.imul(capacity, 13) | 0) / 16 | 0;
  }
  function _M0MPC13int3Int20next__power__of__two(self) {
    if (self >= 0) {
      if (self <= 1) {
        return 1;
      }
      if (self > 1073741824) {
        return 1073741824;
      }
      return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
    } else {
      return $panic();
    }
  }
  function _M0FPB8new__mapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(capacity) {
    const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
    const _bind = capacity$2 - 1 | 0;
    const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
    const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
    const _bind$4 = undefined;
    return new _M0TPB3MapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
  }
  function _M0FPB8new__mapGUiiEuE(capacity) {
    const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
    const _bind = capacity$2 - 1 | 0;
    const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
    const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
    const _bind$4 = undefined;
    return new _M0TPB3MapGUiiEuE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
  }
  function _M0FPB21capacity__for__length(length) {
    let capacity = _M0MPC13int3Int20next__power__of__two(length);
    if (length > _M0FPB21calc__grow__threshold(capacity)) {
      capacity = Math.imul(capacity, 2) | 0;
    }
    return capacity;
  }
  function _M0MPC13int3Int3max(self, other) {
    return self > other ? self : other;
  }
  function _M0MPB3Map20add__entry__to__tailGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, entry) {
    const _bind = self.tail;
    if (_bind === -1) {
      self.head = entry;
    } else {
      const _tmp = self.entries;
      $bound_check(_tmp, _bind);
      _M0MPC16option6Option6unwrapGRPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEEE(_tmp[_bind]).next = entry;
    }
    self.tail = idx;
    const _tmp = self.entries;
    $bound_check(_tmp, idx);
    _tmp[idx] = entry;
    self.size = self.size + 1 | 0;
  }
  function _M0MPB3Map20add__entry__to__tailGUiiEuE(self, idx, entry) {
    const _bind = self.tail;
    if (_bind === -1) {
      self.head = entry;
    } else {
      const _tmp = self.entries;
      $bound_check(_tmp, _bind);
      _M0MPC16option6Option6unwrapGRPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEEE(_tmp[_bind]).next = entry;
    }
    self.tail = idx;
    const _tmp = self.entries;
    $bound_check(_tmp, idx);
    _tmp[idx] = entry;
    self.size = self.size + 1 | 0;
  }
  function _M0MPB3Map10set__entryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, entry, new_idx) {
    const _tmp = self.entries;
    $bound_check(_tmp, new_idx);
    _tmp[new_idx] = entry;
    const _bind = entry.next;
    if (_bind === undefined) {
      self.tail = new_idx;
      return;
    } else {
      const _Some = _bind;
      const _next = _Some;
      _next.prev = new_idx;
      return;
    }
  }
  function _M0MPB3Map10set__entryGUiiEuE(self, entry, new_idx) {
    const _tmp = self.entries;
    $bound_check(_tmp, new_idx);
    _tmp[new_idx] = entry;
    const _bind = entry.next;
    if (_bind === undefined) {
      self.tail = new_idx;
      return;
    } else {
      const _Some = _bind;
      const _next = _Some;
      _next.prev = new_idx;
      return;
    }
  }
  function _M0MPB3Map10push__awayGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, entry) {
    let _tmp = entry.psl + 1 | 0;
    let _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
    let _tmp$3 = entry;
    while (true) {
      const psl = _tmp;
      const idx$2 = _tmp$2;
      const entry$2 = _tmp$3;
      const _tmp$4 = self.entries;
      $bound_check(_tmp$4, idx$2);
      const _bind = _tmp$4[idx$2];
      if (_bind === undefined) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, entry$2, idx$2);
        return;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (psl > _curr_entry.psl) {
          entry$2.psl = psl;
          _M0MPB3Map10set__entryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, entry$2, idx$2);
          _tmp = _curr_entry.psl + 1 | 0;
          _tmp$2 = (idx$2 + 1 | 0) & self.capacity_mask;
          _tmp$3 = _curr_entry;
          continue;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = (idx$2 + 1 | 0) & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map10push__awayGUiiEuE(self, idx, entry) {
    let _tmp = entry.psl + 1 | 0;
    let _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
    let _tmp$3 = entry;
    while (true) {
      const psl = _tmp;
      const idx$2 = _tmp$2;
      const entry$2 = _tmp$3;
      const _tmp$4 = self.entries;
      $bound_check(_tmp$4, idx$2);
      const _bind = _tmp$4[idx$2];
      if (_bind === undefined) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGUiiEuE(self, entry$2, idx$2);
        return;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (psl > _curr_entry.psl) {
          entry$2.psl = psl;
          _M0MPB3Map10set__entryGUiiEuE(self, entry$2, idx$2);
          _tmp = _curr_entry.psl + 1 | 0;
          _tmp$2 = (idx$2 + 1 | 0) & self.capacity_mask;
          _tmp$3 = _curr_entry;
          continue;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = (idx$2 + 1 | 0) & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map20rehash__place__entryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, outer) {
    const hash = outer.hash;
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, outer);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr = _Some;
        if (psl > _curr.psl) {
          _M0MPB3Map10push__awayGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, _curr);
          outer.psl = psl;
          outer.prev = self.tail;
          _M0MPB3Map20add__entry__to__tailGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, outer);
          return undefined;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map20rehash__place__entryGUiiEuE(self, outer) {
    const hash = outer.hash;
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGUiiEuE(self, idx, outer);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr = _Some;
        if (psl > _curr.psl) {
          _M0MPB3Map10push__awayGUiiEuE(self, idx, _curr);
          outer.psl = psl;
          outer.prev = self.tail;
          _M0MPB3Map20add__entry__to__tailGUiiEuE(self, idx, outer);
          return undefined;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map4growGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self) {
    const old_head = self.head;
    const new_capacity = self.capacity << 1;
    self.entries = $make_array_len_and_init(new_capacity, undefined);
    self.capacity = new_capacity;
    self.capacity_mask = new_capacity - 1 | 0;
    self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
    self.size = 0;
    self.head = undefined;
    self.tail = -1;
    let _tmp = old_head;
    while (true) {
      const x = _tmp;
      if (x === undefined) {
        return;
      } else {
        const _Some = x;
        const _e = _Some;
        const next_in_chain = _e.next;
        _e.next = undefined;
        _M0MPB3Map20rehash__place__entryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, _e);
        _tmp = next_in_chain;
        continue;
      }
    }
  }
  function _M0MPB3Map4growGUiiEuE(self) {
    const old_head = self.head;
    const new_capacity = self.capacity << 1;
    self.entries = $make_array_len_and_init(new_capacity, undefined);
    self.capacity = new_capacity;
    self.capacity_mask = new_capacity - 1 | 0;
    self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
    self.size = 0;
    self.head = undefined;
    self.tail = -1;
    let _tmp = old_head;
    while (true) {
      const x = _tmp;
      if (x === undefined) {
        return;
      } else {
        const _Some = x;
        const _e = _Some;
        const next_in_chain = _e.next;
        _e.next = undefined;
        _M0MPB3Map20rehash__place__entryGUiiEuE(self, _e);
        _tmp = next_in_chain;
        continue;
      }
    }
  }
  function _M0MPB3Map15set__with__hashGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, key, value, hash) {
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, entry);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (_curr_entry.hash === hash && _M0IP26uiwcvb12mooncollider7CellKeyPB2Eq5equal(_curr_entry.key, key)) {
          _curr_entry.value = value;
          return undefined;
        }
        if (psl > _curr_entry.psl) {
          if (self.size >= self.grow_at) {
            _M0MPB3Map4growGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self);
            _tmp = 0;
            _tmp$2 = hash & self.capacity_mask;
            continue;
          }
          _M0MPB3Map10push__awayGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, _curr_entry);
          const _bind$2 = self.tail;
          const _bind$3 = undefined;
          const entry = new _M0TPB5EntryGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(_bind$2, _bind$3, psl, hash, key, value);
          _M0MPB3Map20add__entry__to__tailGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, idx, entry);
          return undefined;
        }
        _tmp = psl + 1 | 0;
        _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
        continue;
      }
    }
  }
  function _M0MPB3Map15set__with__hashGUiiEuE(self, key, value, hash) {
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGUiiEuE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGUiiEuE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGUiiEuE(self, idx, entry);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (_curr_entry.hash === hash && _M0IPC15tuple6Tuple2PB2Eq5equalGiiE(_curr_entry.key, key)) {
          _curr_entry.value = value;
          return undefined;
        }
        if (psl > _curr_entry.psl) {
          if (self.size >= self.grow_at) {
            _M0MPB3Map4growGUiiEuE(self);
            _tmp = 0;
            _tmp$2 = hash & self.capacity_mask;
            continue;
          }
          _M0MPB3Map10push__awayGUiiEuE(self, idx, _curr_entry);
          const _bind$2 = self.tail;
          const _bind$3 = undefined;
          const entry = new _M0TPB5EntryGUiiEuE(_bind$2, _bind$3, psl, hash, key, value);
          _M0MPB3Map20add__entry__to__tailGUiiEuE(self, idx, entry);
          return undefined;
        }
        _tmp = psl + 1 | 0;
        _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
        continue;
      }
    }
  }
  function _M0MPB3Map3setGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, key, value) {
    _M0MPB3Map15set__with__hashGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, key, value, _M0IP016_24default__implPB4Hash4hashGRP26uiwcvb12mooncollider7CellKeyE(key));
  }
  function _M0MPB3Map3setGUiiEuE(self, key, value) {
    _M0MPB3Map15set__with__hashGUiiEuE(self, key, value, _M0IP016_24default__implPB4Hash4hashGUiiEE(key));
  }
  function _M0MPB3Map3MapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(arr, capacity) {
    const length = arr.end - arr.start | 0;
    let capacity$2;
    if (capacity === undefined) {
      capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
    } else {
      const _Some = capacity;
      const _capacity = _Some;
      capacity$2 = _M0MPC13int3Int3max(_capacity, _M0FPB21capacity__for__length(length));
    }
    const m = _M0FPB8new__mapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(capacity$2);
    const _bind = arr.end - arr.start | 0;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind) {
        const e = arr.buf[arr.start + _ | 0];
        _M0MPB3Map3setGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(m, e._0, e._1);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return m;
  }
  function _M0MPB3Map3MapGUiiEuE(arr, capacity) {
    const length = arr.end - arr.start | 0;
    let capacity$2;
    if (capacity === undefined) {
      capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
    } else {
      const _Some = capacity;
      const _capacity = _Some;
      capacity$2 = _M0MPC13int3Int3max(_capacity, _M0FPB21capacity__for__length(length));
    }
    const m = _M0FPB8new__mapGUiiEuE(capacity$2);
    const _bind = arr.end - arr.start | 0;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind) {
        const e = arr.buf[arr.start + _ | 0];
        _M0MPB3Map3setGUiiEuE(m, e._0, e._1);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return m;
  }
  function _M0MPB3Map3getGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, key) {
    const hash = _M0IP016_24default__implPB4Hash4hashGRP26uiwcvb12mooncollider7CellKeyE(key);
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const i = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        return _M0DTPC16option6OptionGRPB5ArrayGiEE4None__;
      } else {
        const _Some = _bind;
        const _entry = _Some;
        if (_entry.hash === hash && _M0IP26uiwcvb12mooncollider7CellKeyPB2Eq5equal(_entry.key, key)) {
          return new _M0DTPC16option6OptionGRPB5ArrayGiEE4Some(_entry.value);
        }
        if (i > _entry.psl) {
          return _M0DTPC16option6OptionGRPB5ArrayGiEE4None__;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
        continue;
      }
    }
  }
  function _M0MPB3Map8containsGUiiEuE(self, key) {
    const hash = _M0IP016_24default__implPB4Hash4hashGUiiEE(key);
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const i = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        return false;
      } else {
        const _Some = _bind;
        const _entry = _Some;
        if (_entry.hash === hash && _M0IPC15tuple6Tuple2PB2Eq5equalGiiE(_entry.key, key)) {
          return true;
        }
        if (i > _entry.psl) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = (idx + 1 | 0) & self.capacity_mask;
        continue;
      }
    }
  }
  function _M0MPB3Map4eachGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self, f) {
    let _tmp = self.head;
    while (true) {
      const x = _tmp;
      if (x === undefined) {
        return;
      } else {
        const _Some = x;
        const _x = _Some;
        const _key = _x.key;
        const _value = _x.value;
        const _next = _x.next;
        f(_key, _value);
        _tmp = _next;
        continue;
      }
    }
  }
  function _M0IPC13int3IntPB4Hash13hash__combine(self, hasher) {
    _M0MPB6Hasher12combine__int(hasher, self);
  }
  function _M0MPC16double6Double7to__int(self) {
    return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
  }
  function _M0MPC16double6Double5floor(_tmp) {
    return Math.floor(_tmp);
  }
  function _M0MPC16double6Double7is__nan(self) {
    return self !== self;
  }
  function _M0MPC16double6Double3max(self, other) {
    return _M0MPC16double6Double7is__nan(self) ? other : _M0MPC16double6Double7is__nan(other) ? self : self > other ? self : other;
  }
  function _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self, index) {
    const len = self.length;
    return index >= 0 && index < len ? self[index] : $panic();
  }
  function _M0MPC15array5Array2atGiE(self, index) {
    const len = self.length;
    return index >= 0 && index < len ? self[index] : $panic();
  }
  function _M0MPC15array5Array3setGRP26uiwcvb12mooncollider4Vec2E(self, index, value) {
    const len = self.length;
    if (index >= 0 && index < len) {
      self[index] = value;
      return;
    } else {
      $panic();
      return;
    }
  }
  function _M0MPC15array5Array4makeGRP26uiwcvb12mooncollider4Vec2E(len, elem) {
    const arr = new Array(len);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        arr[i] = elem;
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return arr;
  }
  function _M0FPC14math3sin(_tmp) {
    return Math.sin(_tmp);
  }
  function _M0FPC14math3cos(_tmp) {
    return Math.cos(_tmp);
  }
  function _M0IP26uiwcvb12mooncollider7CellKeyPB2Eq5equal(_x_899, _x_900) {
    return _x_899.cx === _x_900.cx && _x_899.cy === _x_900.cy;
  }
  function _M0IP26uiwcvb12mooncollider7CellKeyPB4Hash13hash__combine(_x_895, _x_896) {
    _M0IPC13int3IntPB4Hash13hash__combine(_x_895.cx, _x_896);
    _M0IPC13int3IntPB4Hash13hash__combine(_x_895.cy, _x_896);
  }
  function _M0MP26uiwcvb12mooncollider4Vec23new(x, y) {
    return new _M0TP26uiwcvb12mooncollider4Vec2(x, y);
  }
  function _M0MP26uiwcvb12mooncollider5World3new() {
    return new _M0TP26uiwcvb12mooncollider5World(_M0MP26uiwcvb12mooncollider4Vec23new(0, -9.81), [], [], 2, 12, 0.4, 0.005);
  }
  function _M0MP26uiwcvb12mooncollider5World12set__gravity(self, g) {
    self.gravity = g;
  }
  function _M0MP26uiwcvb12mooncollider4Vec25cross(self, other) {
    return self.x * other.y - self.y * other.x;
  }
  function _M0MP26uiwcvb12mooncollider4Vec23dot(self, other) {
    return self.x * other.x + self.y * other.y;
  }
  function _M0FP26uiwcvb12mooncollider16polygon__inertia(p, mass) {
    const n = p.vertices.length;
    if (n < 3) {
      return 0;
    }
    const numerator = new _M0TPB8MutLocalGdE(0);
    const denominator = new _M0TPB8MutLocalGdE(0);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, i);
        const _tmp$2 = p.vertices;
        if (n === 0) {
          $panic();
        }
        const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(_tmp$2, (i + 1 | 0) % n | 0);
        const cross = Math.abs(_M0MP26uiwcvb12mooncollider4Vec25cross(a, b));
        numerator.val = numerator.val + cross * (_M0MP26uiwcvb12mooncollider4Vec23dot(a, a) + _M0MP26uiwcvb12mooncollider4Vec23dot(a, b) + _M0MP26uiwcvb12mooncollider4Vec23dot(b, b));
        denominator.val = denominator.val + cross;
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (denominator.val === 0) {
      return 0;
    }
    return mass * numerator.val / (6 * denominator.val);
  }
  function _M0MP26uiwcvb12mooncollider4AABB6height(self) {
    return self.half.y * 2;
  }
  function _M0MP26uiwcvb12mooncollider4AABB5width(self) {
    return self.half.x * 2;
  }
  function _M0FP26uiwcvb12mooncollider16compute__inertia(shape, mass) {
    let p;
    _L: {
      let b;
      _L$2: {
        let c;
        _L$3: {
          switch (shape.$tag) {
            case 1: {
              const _Circle = shape;
              const _c = _Circle._0;
              c = _c;
              break _L$3;
            }
            case 0: {
              const _AABB = shape;
              const _b = _AABB._0;
              b = _b;
              break _L$2;
            }
            default: {
              const _Polygon = shape;
              const _p = _Polygon._0;
              p = _p;
              break _L;
            }
          }
        }
        return 0.5 * mass * c.radius * c.radius;
      }
      const w = _M0MP26uiwcvb12mooncollider4AABB5width(b);
      const h = _M0MP26uiwcvb12mooncollider4AABB6height(b);
      return mass * (w * w + h * h) / 12;
    }
    return _M0FP26uiwcvb12mooncollider16polygon__inertia(p, mass);
  }
  function _M0MP26uiwcvb12mooncollider4AABB3new(center, half) {
    return new _M0TP26uiwcvb12mooncollider4AABB(center, half);
  }
  function _M0MP26uiwcvb12mooncollider6Circle3new(center, radius) {
    return new _M0TP26uiwcvb12mooncollider6Circle(center, radius);
  }
  function _M0MP26uiwcvb12mooncollider4Vec26length(self) {
    return Math.sqrt(self.x * self.x + self.y * self.y);
  }
  function _M0MP26uiwcvb12mooncollider4Vec24zero() {
    return new _M0TP26uiwcvb12mooncollider4Vec2(0, 0);
  }
  function _M0MP26uiwcvb12mooncollider4Vec29normalize(self) {
    const l = _M0MP26uiwcvb12mooncollider4Vec26length(self);
    return l === 0 ? _M0MP26uiwcvb12mooncollider4Vec24zero() : new _M0TP26uiwcvb12mooncollider4Vec2(self.x / l, self.y / l);
  }
  function _M0MP26uiwcvb12mooncollider4Vec23sub(self, other) {
    return new _M0TP26uiwcvb12mooncollider4Vec2(self.x - other.x, self.y - other.y);
  }
  function _M0MP26uiwcvb12mooncollider7Polygon19from__vertices__ccw(vertices) {
    const n = vertices.length;
    const normals = _M0MPC15array5Array4makeGRP26uiwcvb12mooncollider4Vec2E(n, _M0MP26uiwcvb12mooncollider4Vec24zero());
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(vertices, i);
        if (n === 0) {
          $panic();
        }
        const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(vertices, (i + 1 | 0) % n | 0);
        const edge = _M0MP26uiwcvb12mooncollider4Vec23sub(b, a);
        const normal = _M0MP26uiwcvb12mooncollider4Vec29normalize(_M0MP26uiwcvb12mooncollider4Vec23new(edge.y, -edge.x));
        _M0MPC15array5Array3setGRP26uiwcvb12mooncollider4Vec2E(normals, i, normal);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return new _M0TP26uiwcvb12mooncollider7Polygon(vertices, normals);
  }
  function _M0MP26uiwcvb12mooncollider4Vec23add(self, other) {
    return new _M0TP26uiwcvb12mooncollider4Vec2(self.x + other.x, self.y + other.y);
  }
  function _M0MP26uiwcvb12mooncollider4Vec26rotate(self, angle) {
    const c = _M0FPC14math3cos(angle);
    const s = _M0FPC14math3sin(angle);
    return new _M0TP26uiwcvb12mooncollider4Vec2(self.x * c - self.y * s, self.x * s + self.y * c);
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(self) {
    let p;
    _L: {
      let c;
      _L$2: {
        let b;
        _L$3: {
          const _bind = self.shape;
          switch (_bind.$tag) {
            case 0: {
              const _AABB = _bind;
              const _b = _AABB._0;
              b = _b;
              break _L$3;
            }
            case 1: {
              const _Circle = _bind;
              const _c = _Circle._0;
              c = _c;
              break _L$2;
            }
            default: {
              const _Polygon = _bind;
              const _p = _Polygon._0;
              p = _p;
              break _L;
            }
          }
        }
        return new _M0DTP26uiwcvb12mooncollider5Shape4AABB(_M0MP26uiwcvb12mooncollider4AABB3new(_M0MP26uiwcvb12mooncollider4Vec23add(b.center, self.position), b.half));
      }
      return new _M0DTP26uiwcvb12mooncollider5Shape6Circle(_M0MP26uiwcvb12mooncollider6Circle3new(_M0MP26uiwcvb12mooncollider4Vec23add(c.center, self.position), c.radius));
    }
    const n = p.vertices.length;
    const verts = [];
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const v = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, i);
        const rotated = _M0MP26uiwcvb12mooncollider4Vec26rotate(v, self.angle);
        _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(verts, _M0MP26uiwcvb12mooncollider4Vec23add(rotated, self.position));
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return new _M0DTP26uiwcvb12mooncollider5Shape7Polygon(_M0MP26uiwcvb12mooncollider7Polygon19from__vertices__ccw(verts));
  }
  function _M0MP26uiwcvb12mooncollider4Vec25scale(self, s) {
    return new _M0TP26uiwcvb12mooncollider4Vec2(self.x * s, self.y * s);
  }
  function _M0MP26uiwcvb12mooncollider4AABB14from__min__max(min, max) {
    const center = _M0MP26uiwcvb12mooncollider4Vec25scale(_M0MP26uiwcvb12mooncollider4Vec23add(min, max), 0.5);
    const half = _M0MP26uiwcvb12mooncollider4Vec25scale(_M0MP26uiwcvb12mooncollider4Vec23sub(max, min), 0.5);
    return new _M0TP26uiwcvb12mooncollider4AABB(center, half);
  }
  function _M0MP26uiwcvb12mooncollider7Polygon4aabb(self) {
    const n = self.vertices.length;
    if (n === 0) {
      return _M0MP26uiwcvb12mooncollider4AABB3new(_M0MP26uiwcvb12mooncollider4Vec24zero(), _M0MP26uiwcvb12mooncollider4Vec24zero());
    }
    const lo_x = new _M0TPB8MutLocalGdE(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.vertices, 0).x);
    const hi_x = new _M0TPB8MutLocalGdE(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.vertices, 0).x);
    const lo_y = new _M0TPB8MutLocalGdE(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.vertices, 0).y);
    const hi_y = new _M0TPB8MutLocalGdE(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.vertices, 0).y);
    let _tmp = 1;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const p = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.vertices, i);
        if (p.x < lo_x.val) {
          lo_x.val = p.x;
        }
        if (p.x > hi_x.val) {
          hi_x.val = p.x;
        }
        if (p.y < lo_y.val) {
          lo_y.val = p.y;
        }
        if (p.y > hi_y.val) {
          hi_y.val = p.y;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _M0MP26uiwcvb12mooncollider4AABB14from__min__max(_M0MP26uiwcvb12mooncollider4Vec23new(lo_x.val, lo_y.val), _M0MP26uiwcvb12mooncollider4Vec23new(hi_x.val, hi_y.val));
  }
  function _M0MP26uiwcvb12mooncollider5Shape4aabb(self) {
    let p;
    _L: {
      let c;
      _L$2: {
        switch (self.$tag) {
          case 0: {
            const _AABB = self;
            const _b = _AABB._0;
            return _b;
          }
          case 1: {
            const _Circle = self;
            const _c = _Circle._0;
            c = _c;
            break _L$2;
          }
          default: {
            const _Polygon = self;
            const _p = _Polygon._0;
            p = _p;
            break _L;
          }
        }
      }
      return _M0MP26uiwcvb12mooncollider4AABB3new(c.center, _M0MP26uiwcvb12mooncollider4Vec23new(c.radius, c.radius));
    }
    return _M0MP26uiwcvb12mooncollider7Polygon4aabb(p);
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody12update__aabb(self) {
    const world_shape = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(self);
    self.aabb = _M0MP26uiwcvb12mooncollider5Shape4aabb(world_shape);
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody9from__def(id, def) {
    let mass;
    let inv_mass;
    _L: {
      const _bind = def.body_type;
      if (_bind === 0) {
        mass = 0;
        inv_mass = 0;
        break _L;
      } else {
        const m = def.mass > 0 ? def.mass : 1;
        mass = m;
        inv_mass = 1 / m;
        break _L;
      }
    }
    let inertia;
    let inv_inertia;
    _L$2: {
      const _bind = def.body_type;
      if (_bind === 0) {
        inertia = 0;
        inv_inertia = 0;
        break _L$2;
      } else {
        const i = _M0FP26uiwcvb12mooncollider16compute__inertia(def.shape, mass);
        if (i > 0) {
          inertia = i;
          inv_inertia = 1 / i;
          break _L$2;
        } else {
          inertia = 0;
          inv_inertia = 0;
          break _L$2;
        }
      }
    }
    const body = new _M0TP26uiwcvb12mooncollider9RigidBody(id, def.body_type, def.position, def.angle, _M0MP26uiwcvb12mooncollider4Vec24zero(), 0, _M0MP26uiwcvb12mooncollider4Vec24zero(), 0, mass, inv_mass, inertia, inv_inertia, def.restitution, def.friction, def.linear_damping, def.angular_damping, def.shape, _M0MP26uiwcvb12mooncollider4AABB3new(_M0MP26uiwcvb12mooncollider4Vec24zero(), _M0MP26uiwcvb12mooncollider4Vec24zero()), def.gravity_scale, true);
    _M0MP26uiwcvb12mooncollider9RigidBody12update__aabb(body);
    return body;
  }
  function _M0MP26uiwcvb12mooncollider5World9add__body(self, def) {
    const id = self.bodies.length;
    const body = _M0MP26uiwcvb12mooncollider9RigidBody9from__def(id, def);
    _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, body);
    return id;
  }
  function _M0MP26uiwcvb12mooncollider5World4body(self, id) {
    return _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, id);
  }
  function _M0MP26uiwcvb12mooncollider5World11body__count(self) {
    return self.bodies.length;
  }
  function _M0MP26uiwcvb12mooncollider5World12remove__body(self, id) {
    if (id >= 0 && id < self.bodies.length) {
      _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, id).alive = false;
      return;
    } else {
      return;
    }
  }
  function _M0MP26uiwcvb12mooncollider4AABB3max(self) {
    return _M0MP26uiwcvb12mooncollider4Vec23add(self.center, self.half);
  }
  function _M0MP26uiwcvb12mooncollider4AABB3min(self) {
    return _M0MP26uiwcvb12mooncollider4Vec23sub(self.center, self.half);
  }
  function _M0MP26uiwcvb12mooncollider8Manifold4new2(normal, depth, contact, contact2) {
    return new _M0TP26uiwcvb12mooncollider8Manifold(normal, depth, contact, contact2);
  }
  function _M0MP26uiwcvb12mooncollider8Manifold4none() {
    return new _M0TP26uiwcvb12mooncollider8Manifold(_M0MP26uiwcvb12mooncollider4Vec24zero(), 0, _M0MP26uiwcvb12mooncollider4Vec24zero(), _M0MP26uiwcvb12mooncollider4Vec24zero());
  }
  function _M0FP26uiwcvb12mooncollider19collide__aabb__aabb(a, b) {
    const a_lo = _M0MP26uiwcvb12mooncollider4AABB3min(a);
    const a_hi = _M0MP26uiwcvb12mooncollider4AABB3max(a);
    const b_lo = _M0MP26uiwcvb12mooncollider4AABB3min(b);
    const b_hi = _M0MP26uiwcvb12mooncollider4AABB3max(b);
    const ox = a_hi.x < b_hi.x ? a_hi.x - b_lo.x : b_hi.x - a_lo.x;
    const oy = a_hi.y < b_hi.y ? a_hi.y - b_lo.y : b_hi.y - a_lo.y;
    if (ox <= 0 || oy <= 0) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    if (ox < oy) {
      const nx = a.center.x < b.center.x ? 1 : -1;
      const contact_x = a.center.x < b.center.x ? a_hi.x : a_lo.x;
      const y_hi = a_hi.y < b_hi.y ? a_hi.y : b_hi.y;
      const y_lo = a_lo.y > b_lo.y ? a_lo.y : b_lo.y;
      const c1 = _M0MP26uiwcvb12mooncollider4Vec23new(contact_x, y_lo);
      const c2 = _M0MP26uiwcvb12mooncollider4Vec23new(contact_x, y_hi);
      return _M0MP26uiwcvb12mooncollider8Manifold4new2(_M0MP26uiwcvb12mooncollider4Vec23new(nx, 0), ox, c1, c2);
    } else {
      const ny = a.center.y < b.center.y ? 1 : -1;
      const contact_y = a.center.y < b.center.y ? a_hi.y : a_lo.y;
      const x_hi = a_hi.x < b_hi.x ? a_hi.x : b_hi.x;
      const x_lo = a_lo.x > b_lo.x ? a_lo.x : b_lo.x;
      const c1 = _M0MP26uiwcvb12mooncollider4Vec23new(x_lo, contact_y);
      const c2 = _M0MP26uiwcvb12mooncollider4Vec23new(x_hi, contact_y);
      return _M0MP26uiwcvb12mooncollider8Manifold4new2(_M0MP26uiwcvb12mooncollider4Vec23new(0, ny), oy, c1, c2);
    }
  }
  function _M0MP26uiwcvb12mooncollider8Manifold3new(normal, depth, contact) {
    return new _M0TP26uiwcvb12mooncollider8Manifold(normal, depth, contact, _M0MP26uiwcvb12mooncollider4Vec24zero());
  }
  function _M0MP26uiwcvb12mooncollider4Vec210length__sq(self) {
    return self.x * self.x + self.y * self.y;
  }
  function _M0FP26uiwcvb12mooncollider21collide__aabb__circle(a, b) {
    const lo = _M0MP26uiwcvb12mooncollider4AABB3min(a);
    const hi = _M0MP26uiwcvb12mooncollider4AABB3max(a);
    const cx = b.center.x < lo.x ? lo.x : b.center.x > hi.x ? hi.x : b.center.x;
    const cy = b.center.y < lo.y ? lo.y : b.center.y > hi.y ? hi.y : b.center.y;
    const closest = _M0MP26uiwcvb12mooncollider4Vec23new(cx, cy);
    const d = _M0MP26uiwcvb12mooncollider4Vec23sub(b.center, closest);
    const dist_sq = _M0MP26uiwcvb12mooncollider4Vec210length__sq(d);
    if (dist_sq >= b.radius * b.radius) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const dist = Math.sqrt(dist_sq);
    let normal;
    if (dist > 0) {
      normal = _M0MP26uiwcvb12mooncollider4Vec25scale(d, 1 / dist);
    } else {
      const dx_lo = Math.abs(b.center.x - lo.x);
      const dx_hi = Math.abs(b.center.x - hi.x);
      const dy_lo = Math.abs(b.center.y - lo.y);
      const dy_hi = Math.abs(b.center.y - hi.y);
      const m = dx_lo;
      const best = new _M0TPB8MutLocalGiE(0);
      if (dx_hi < m) {
        best.val = 1;
      }
      if (dy_lo < m) {
        best.val = 2;
      }
      if (dy_hi < m) {
        best.val = 3;
      }
      const _bind = best.val;
      switch (_bind) {
        case 0: {
          normal = _M0MP26uiwcvb12mooncollider4Vec23new(-1, 0);
          break;
        }
        case 1: {
          normal = _M0MP26uiwcvb12mooncollider4Vec23new(1, 0);
          break;
        }
        case 2: {
          normal = _M0MP26uiwcvb12mooncollider4Vec23new(0, -1);
          break;
        }
        default: {
          normal = _M0MP26uiwcvb12mooncollider4Vec23new(0, 1);
        }
      }
    }
    const depth = b.radius - dist;
    const contact = closest;
    return _M0MP26uiwcvb12mooncollider8Manifold3new(normal, depth, contact);
  }
  function _M0FP26uiwcvb12mooncollider15polygon__center(p) {
    const n = p.vertices.length;
    if (n === 0) {
      return _M0MP26uiwcvb12mooncollider4Vec24zero();
    }
    const sx = new _M0TPB8MutLocalGdE(0);
    const sy = new _M0TPB8MutLocalGdE(0);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        sx.val = sx.val + _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, i).x;
        sy.val = sy.val + _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, i).y;
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _M0MP26uiwcvb12mooncollider4Vec23new(sx.val / (n + 0), sy.val / (n + 0));
  }
  function _M0FP26uiwcvb12mooncollider7project(p, axis) {
    const n = p.vertices.length;
    const lo = new _M0TPB8MutLocalGdE(_M0MP26uiwcvb12mooncollider4Vec23dot(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, 0), axis));
    const hi = new _M0TPB8MutLocalGdE(lo.val);
    let _tmp = 1;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const v = _M0MP26uiwcvb12mooncollider4Vec23dot(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(p.vertices, i), axis);
        if (v < lo.val) {
          lo.val = v;
        }
        if (v > hi.val) {
          hi.val = v;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: lo.val, _1: hi.val };
  }
  function _M0FP26uiwcvb12mooncollider9sat__axes(a, b) {
    const n = a.normals.length;
    const best_depth = new _M0TPB8MutLocalGdE(1e+30);
    const best_axis = new _M0TPB8MutLocalGRP26uiwcvb12mooncollider4Vec2E(_M0MP26uiwcvb12mooncollider4Vec24zero());
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const axis = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(a.normals, i);
        let pa;
        let qa;
        _L: {
          const _bind = _M0FP26uiwcvb12mooncollider7project(a, axis);
          const _pa = _bind._0;
          const _qa = _bind._1;
          pa = _pa;
          qa = _qa;
          break _L;
        }
        let pb;
        let qb;
        _L$2: {
          const _bind = _M0FP26uiwcvb12mooncollider7project(b, axis);
          const _pb = _bind._0;
          const _qb = _bind._1;
          pb = _pb;
          qb = _qb;
          break _L$2;
        }
        const overlap = qa < qb ? qa - pb : qb - pa;
        if (overlap <= 0) {
          return undefined;
        }
        if (overlap < best_depth.val) {
          best_depth.val = overlap;
          best_axis.val = axis;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: best_depth.val, _1: best_axis.val };
  }
  function _M0MP26uiwcvb12mooncollider7Polygon4size(self) {
    return self.vertices.length;
  }
  function _M0MP26uiwcvb12mooncollider4Vec23neg(self) {
    return new _M0TP26uiwcvb12mooncollider4Vec2(-self.x, -self.y);
  }
  function _M0FP26uiwcvb12mooncollider25collide__polygon__polygon(a, b) {
    if (_M0MP26uiwcvb12mooncollider7Polygon4size(a) === 0 || _M0MP26uiwcvb12mooncollider7Polygon4size(b) === 0) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const r1 = _M0FP26uiwcvb12mooncollider9sat__axes(a, b);
    let d1;
    _L: {
      if (r1 === undefined) {
        return _M0MP26uiwcvb12mooncollider8Manifold4none();
      } else {
        const _Some = r1;
        const _d1 = _Some;
        d1 = _d1;
        break _L;
      }
    }
    const r2 = _M0FP26uiwcvb12mooncollider9sat__axes(b, a);
    let d2;
    _L$2: {
      if (r2 === undefined) {
        return _M0MP26uiwcvb12mooncollider8Manifold4none();
      } else {
        const _Some = r2;
        const _d2 = _Some;
        d2 = _d2;
        break _L$2;
      }
    }
    const best = d1._0 < d2._0 ? d1 : d2;
    const best_normal = new _M0TPB8MutLocalGRP26uiwcvb12mooncollider4Vec2E(best._1);
    const dir = _M0MP26uiwcvb12mooncollider4Vec23sub(_M0FP26uiwcvb12mooncollider15polygon__center(b), _M0FP26uiwcvb12mooncollider15polygon__center(a));
    if (_M0MP26uiwcvb12mooncollider4Vec23dot(dir, best_normal.val) < 0) {
      best_normal.val = _M0MP26uiwcvb12mooncollider4Vec23neg(best_normal.val);
    }
    const contact = _M0MP26uiwcvb12mooncollider4Vec23add(_M0FP26uiwcvb12mooncollider15polygon__center(a), _M0MP26uiwcvb12mooncollider4Vec25scale(best_normal.val, best._0));
    return _M0MP26uiwcvb12mooncollider8Manifold3new(best_normal.val, best._0, contact);
  }
  function _M0MP26uiwcvb12mooncollider7Polygon3box(min, max) {
    const vertices = [_M0MP26uiwcvb12mooncollider4Vec23new(min.x, min.y), _M0MP26uiwcvb12mooncollider4Vec23new(max.x, min.y), _M0MP26uiwcvb12mooncollider4Vec23new(max.x, max.y), _M0MP26uiwcvb12mooncollider4Vec23new(min.x, max.y)];
    return _M0MP26uiwcvb12mooncollider7Polygon19from__vertices__ccw(vertices);
  }
  function _M0FP26uiwcvb12mooncollider22collide__aabb__polygon(a, b) {
    if (_M0MP26uiwcvb12mooncollider7Polygon4size(b) === 0) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const a_poly = _M0MP26uiwcvb12mooncollider7Polygon3box(_M0MP26uiwcvb12mooncollider4AABB3min(a), _M0MP26uiwcvb12mooncollider4AABB3max(a));
    return _M0FP26uiwcvb12mooncollider25collide__polygon__polygon(a_poly, b);
  }
  function _M0FP26uiwcvb12mooncollider23collide__circle__circle(a, b) {
    const d = _M0MP26uiwcvb12mooncollider4Vec23sub(b.center, a.center);
    const r = a.radius + b.radius;
    const dist_sq = _M0MP26uiwcvb12mooncollider4Vec210length__sq(d);
    if (dist_sq >= r * r) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const dist = Math.sqrt(dist_sq);
    const normal = dist > 0 ? _M0MP26uiwcvb12mooncollider4Vec25scale(d, 1 / dist) : _M0MP26uiwcvb12mooncollider4Vec23new(0, 1);
    const depth = r - dist;
    const contact = _M0MP26uiwcvb12mooncollider4Vec23add(a.center, _M0MP26uiwcvb12mooncollider4Vec25scale(normal, a.radius));
    return _M0MP26uiwcvb12mooncollider8Manifold3new(normal, depth, contact);
  }
  function _M0FP26uiwcvb12mooncollider27closest__point__on__segment(p, p1, p2) {
    const edge = _M0MP26uiwcvb12mooncollider4Vec23sub(p2, p1);
    const len_sq = _M0MP26uiwcvb12mooncollider4Vec210length__sq(edge);
    if (len_sq === 0) {
      return p1;
    }
    const t = _M0MP26uiwcvb12mooncollider4Vec23dot(_M0MP26uiwcvb12mooncollider4Vec23sub(p, p1), edge) / len_sq;
    const tc = t < 0 ? 0 : t > 1 ? 1 : t;
    return _M0MP26uiwcvb12mooncollider4Vec23add(p1, _M0MP26uiwcvb12mooncollider4Vec25scale(edge, tc));
  }
  function _M0FP26uiwcvb12mooncollider6cross3(a, b, p) {
    return _M0MP26uiwcvb12mooncollider4Vec25cross(_M0MP26uiwcvb12mooncollider4Vec23sub(b, a), _M0MP26uiwcvb12mooncollider4Vec23sub(p, a));
  }
  function _M0FP26uiwcvb12mooncollider18point__in__polygon(p, poly) {
    const n = poly.vertices.length;
    if (n < 3) {
      return false;
    }
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(poly.vertices, i);
        const _tmp$2 = poly.vertices;
        if (n === 0) {
          $panic();
        }
        const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(_tmp$2, (i + 1 | 0) % n | 0);
        const c = _M0FP26uiwcvb12mooncollider6cross3(a, b, p);
        if (c < 0) {
          return false;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return true;
  }
  function _M0FP26uiwcvb12mooncollider24collide__circle__polygon(a, b) {
    if (_M0MP26uiwcvb12mooncollider7Polygon4size(b) === 0) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const best_dist_sq = new _M0TPB8MutLocalGdE(1e+30);
    const best_point = new _M0TPB8MutLocalGRP26uiwcvb12mooncollider4Vec2E(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(b.vertices, 0));
    const n = b.vertices.length;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        const p1 = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(b.vertices, i);
        const _tmp$2 = b.vertices;
        if (n === 0) {
          $panic();
        }
        const p2 = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(_tmp$2, (i + 1 | 0) % n | 0);
        const cp = _M0FP26uiwcvb12mooncollider27closest__point__on__segment(a.center, p1, p2);
        const d = _M0MP26uiwcvb12mooncollider4Vec210length__sq(_M0MP26uiwcvb12mooncollider4Vec23sub(a.center, cp));
        if (d < best_dist_sq.val) {
          best_dist_sq.val = d;
          best_point.val = cp;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const to_circle = _M0MP26uiwcvb12mooncollider4Vec23sub(a.center, best_point.val);
    const dist = Math.sqrt(best_dist_sq.val);
    const inside = _M0FP26uiwcvb12mooncollider18point__in__polygon(a.center, b);
    if (!inside && dist >= a.radius) {
      return _M0MP26uiwcvb12mooncollider8Manifold4none();
    }
    const normal = inside ? (dist > 0 ? _M0MP26uiwcvb12mooncollider4Vec25scale(to_circle, 1 / dist) : _M0MP26uiwcvb12mooncollider4Vec23new(0, 1)) : dist > 0 ? _M0MP26uiwcvb12mooncollider4Vec25scale(to_circle, -1 / dist) : _M0MP26uiwcvb12mooncollider4Vec23new(0, 1);
    const depth = inside ? a.radius + dist : a.radius - dist;
    return _M0MP26uiwcvb12mooncollider8Manifold3new(normal, depth, best_point.val);
  }
  function _M0MP26uiwcvb12mooncollider8Manifold9colliding(self) {
    return self.depth > 0;
  }
  function _M0FP26uiwcvb12mooncollider7collide(a, b) {
    let a$2;
    let b$2;
    _L: {
      let a$3;
      let b$3;
      _L$2: {
        let a$4;
        let b$4;
        _L$3: {
          let a$5;
          let b$5;
          _L$4: {
            let a$6;
            let b$6;
            _L$5: {
              let a$7;
              let b$7;
              _L$6: {
                let a$8;
                let b$8;
                _L$7: {
                  let a$9;
                  let b$9;
                  _L$8: {
                    let a$10;
                    let b$10;
                    _L$9: {
                      switch (a.$tag) {
                        case 0: {
                          const _AABB = a;
                          const _a = _AABB._0;
                          switch (b.$tag) {
                            case 0: {
                              const _AABB$2 = b;
                              const _b = _AABB$2._0;
                              a$10 = _a;
                              b$10 = _b;
                              break _L$9;
                            }
                            case 1: {
                              const _Circle = b;
                              const _b$2 = _Circle._0;
                              a$8 = _a;
                              b$8 = _b$2;
                              break _L$7;
                            }
                            default: {
                              const _Polygon = b;
                              const _b$3 = _Polygon._0;
                              a$5 = _a;
                              b$5 = _b$3;
                              break _L$4;
                            }
                          }
                        }
                        case 1: {
                          const _Circle$2 = a;
                          const _a$2 = _Circle$2._0;
                          switch (b.$tag) {
                            case 1: {
                              const _Circle$3 = b;
                              const _b$4 = _Circle$3._0;
                              a$9 = _a$2;
                              b$9 = _b$4;
                              break _L$8;
                            }
                            case 0: {
                              const _AABB$3 = b;
                              const _b$5 = _AABB$3._0;
                              a$7 = _a$2;
                              b$7 = _b$5;
                              break _L$6;
                            }
                            default: {
                              const _Polygon$2 = b;
                              const _b$6 = _Polygon$2._0;
                              a$3 = _a$2;
                              b$3 = _b$6;
                              break _L$2;
                            }
                          }
                        }
                        default: {
                          const _Polygon$3 = a;
                          const _a$3 = _Polygon$3._0;
                          switch (b.$tag) {
                            case 2: {
                              const _Polygon$4 = b;
                              const _b$7 = _Polygon$4._0;
                              a$6 = _a$3;
                              b$6 = _b$7;
                              break _L$5;
                            }
                            case 0: {
                              const _AABB$4 = b;
                              const _b$8 = _AABB$4._0;
                              a$4 = _a$3;
                              b$4 = _b$8;
                              break _L$3;
                            }
                            default: {
                              const _Circle$4 = b;
                              const _b$9 = _Circle$4._0;
                              a$2 = _a$3;
                              b$2 = _b$9;
                              break _L;
                            }
                          }
                        }
                      }
                    }
                    return _M0FP26uiwcvb12mooncollider19collide__aabb__aabb(a$10, b$10);
                  }
                  return _M0FP26uiwcvb12mooncollider23collide__circle__circle(a$9, b$9);
                }
                return _M0FP26uiwcvb12mooncollider21collide__aabb__circle(a$8, b$8);
              }
              const m = _M0FP26uiwcvb12mooncollider21collide__aabb__circle(b$7, a$7);
              return _M0MP26uiwcvb12mooncollider8Manifold9colliding(m) ? _M0MP26uiwcvb12mooncollider8Manifold3new(_M0MP26uiwcvb12mooncollider4Vec23neg(m.normal), m.depth, m.contact) : m;
            }
            return _M0FP26uiwcvb12mooncollider25collide__polygon__polygon(a$6, b$6);
          }
          return _M0FP26uiwcvb12mooncollider22collide__aabb__polygon(a$5, b$5);
        }
        const m = _M0FP26uiwcvb12mooncollider22collide__aabb__polygon(b$4, a$4);
        return _M0MP26uiwcvb12mooncollider8Manifold9colliding(m) ? _M0MP26uiwcvb12mooncollider8Manifold3new(_M0MP26uiwcvb12mooncollider4Vec23neg(m.normal), m.depth, m.contact) : m;
      }
      return _M0FP26uiwcvb12mooncollider24collide__circle__polygon(a$3, b$3);
    }
    const m = _M0FP26uiwcvb12mooncollider24collide__circle__polygon(b$2, a$2);
    return _M0MP26uiwcvb12mooncollider8Manifold9colliding(m) ? _M0MP26uiwcvb12mooncollider8Manifold3new(_M0MP26uiwcvb12mooncollider4Vec23neg(m.normal), m.depth, m.contact) : m;
  }
  function _M0FP26uiwcvb12mooncollider13make__contact(a, b, m, point) {
    return new _M0TP26uiwcvb12mooncollider7Contact(a, b, m.normal, point, a.restitution < b.restitution ? a.restitution : b.restitution, Math.sqrt(a.friction * a.friction + b.friction * b.friction));
  }
  function _M0FP26uiwcvb12mooncollider13world__anchor(body, local_anchor) {
    return _M0MP26uiwcvb12mooncollider4Vec23add(body.position, _M0MP26uiwcvb12mooncollider4Vec26rotate(local_anchor, body.angle));
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody10is__static(self) {
    const _bind = self.body_type;
    if (_bind === 0) {
      return true;
    } else {
      return false;
    }
  }
  function _M0FP26uiwcvb12mooncollider15solve__distance(j, bodies) {
    const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.a);
    const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.b);
    if (a.inv_mass + b.inv_mass === 0) {
      return undefined;
    }
    const pa = _M0FP26uiwcvb12mooncollider13world__anchor(a, j.local_anchor_a);
    const pb = _M0FP26uiwcvb12mooncollider13world__anchor(b, j.local_anchor_b);
    const delta = _M0MP26uiwcvb12mooncollider4Vec23sub(pb, pa);
    const dist = _M0MP26uiwcvb12mooncollider4Vec26length(delta);
    if (dist < 1e-09) {
      return undefined;
    }
    const n = _M0MP26uiwcvb12mooncollider4Vec25scale(delta, 1 / dist);
    const ra = _M0MP26uiwcvb12mooncollider4Vec23sub(pa, a.position);
    const rb = _M0MP26uiwcvb12mooncollider4Vec23sub(pb, b.position);
    const va = _M0MP26uiwcvb12mooncollider4Vec23add(a.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x));
    const vb = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x));
    const rv = _M0MP26uiwcvb12mooncollider4Vec23sub(vb, va);
    const c = dist - j.length;
    const bias = -0.1 * c * j.stiffness;
    const ra_cross_n = _M0MP26uiwcvb12mooncollider4Vec25cross(ra, n);
    const rb_cross_n = _M0MP26uiwcvb12mooncollider4Vec25cross(rb, n);
    const inv_mass_sum = a.inv_mass + b.inv_mass + ra_cross_n * ra_cross_n * a.inv_inertia + rb_cross_n * rb_cross_n * b.inv_inertia;
    if (inv_mass_sum === 0) {
      return undefined;
    }
    const lambda = -(_M0MP26uiwcvb12mooncollider4Vec23dot(rv, n) + bias) / inv_mass_sum;
    const impulse = _M0MP26uiwcvb12mooncollider4Vec25scale(n, lambda);
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(a)) {
      a.velocity = _M0MP26uiwcvb12mooncollider4Vec23sub(a.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, a.inv_mass));
      a.angular_velocity = a.angular_velocity - _M0MP26uiwcvb12mooncollider4Vec25cross(ra, impulse) * a.inv_inertia;
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
      b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, b.inv_mass));
      b.angular_velocity = b.angular_velocity + _M0MP26uiwcvb12mooncollider4Vec25cross(rb, impulse) * b.inv_inertia;
      return;
    } else {
      return;
    }
  }
  function _M0FP26uiwcvb12mooncollider21solve__revolute__axis(a, b, ra, rb, c, axis) {
    const ra_cross = _M0MP26uiwcvb12mooncollider4Vec25cross(ra, axis);
    const rb_cross = _M0MP26uiwcvb12mooncollider4Vec25cross(rb, axis);
    const inv_mass_sum = a.inv_mass + b.inv_mass + ra_cross * ra_cross * a.inv_inertia + rb_cross * rb_cross * b.inv_inertia;
    if (inv_mass_sum === 0) {
      return undefined;
    }
    const lambda = -c / inv_mass_sum;
    const impulse = _M0MP26uiwcvb12mooncollider4Vec25scale(axis, lambda);
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(a)) {
      a.velocity = _M0MP26uiwcvb12mooncollider4Vec23sub(a.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, a.inv_mass));
      a.angular_velocity = a.angular_velocity - _M0MP26uiwcvb12mooncollider4Vec25cross(ra, impulse) * a.inv_inertia;
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
      b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, b.inv_mass));
      b.angular_velocity = b.angular_velocity + _M0MP26uiwcvb12mooncollider4Vec25cross(rb, impulse) * b.inv_inertia;
      return;
    } else {
      return;
    }
  }
  function _M0FP26uiwcvb12mooncollider15solve__revolute(j, bodies) {
    const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.a);
    const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.b);
    if (a.inv_mass + b.inv_mass === 0) {
      return undefined;
    }
    const pa = _M0FP26uiwcvb12mooncollider13world__anchor(a, j.local_anchor_a);
    const pb = _M0FP26uiwcvb12mooncollider13world__anchor(b, j.local_anchor_b);
    const ra = _M0MP26uiwcvb12mooncollider4Vec23sub(pa, a.position);
    const rb = _M0MP26uiwcvb12mooncollider4Vec23sub(pb, b.position);
    const va = _M0MP26uiwcvb12mooncollider4Vec23add(a.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x));
    const vb = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x));
    const rv = _M0MP26uiwcvb12mooncollider4Vec23sub(vb, va);
    const bias = _M0MP26uiwcvb12mooncollider4Vec25scale(_M0MP26uiwcvb12mooncollider4Vec23sub(pb, pa), 0.1);
    _M0FP26uiwcvb12mooncollider21solve__revolute__axis(a, b, ra, rb, rv.x + bias.x, _M0MP26uiwcvb12mooncollider4Vec23new(1, 0));
    const va2 = _M0MP26uiwcvb12mooncollider4Vec23add(a.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x));
    const vb2 = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x));
    const rv2 = _M0MP26uiwcvb12mooncollider4Vec23sub(vb2, va2);
    _M0FP26uiwcvb12mooncollider21solve__revolute__axis(a, b, ra, rb, rv2.y + bias.y, _M0MP26uiwcvb12mooncollider4Vec23new(0, 1));
  }
  function _M0FP26uiwcvb12mooncollider11solve__weld(j, bodies) {
    const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.a);
    const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.b);
    if (a.inv_mass + b.inv_mass === 0) {
      return undefined;
    }
    _M0FP26uiwcvb12mooncollider15solve__revolute(new _M0TP26uiwcvb12mooncollider13RevoluteJoint(j.a, j.b, j.local_anchor_a, j.local_anchor_b), bodies);
    const a2 = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.a);
    const b2 = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(bodies, j.b);
    const rel_angle = b2.angle - a2.angle - j.ref_angle;
    const c = rel_angle * 0.1 + (b2.angular_velocity - a2.angular_velocity);
    const inv_mass_sum = a2.inv_inertia + b2.inv_inertia;
    if (inv_mass_sum === 0) {
      return undefined;
    }
    const lambda = -c / inv_mass_sum;
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(a2)) {
      a2.angular_velocity = a2.angular_velocity - lambda * a2.inv_inertia;
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b2)) {
      b2.angular_velocity = b2.angular_velocity + lambda * b2.inv_inertia;
      return;
    } else {
      return;
    }
  }
  function _M0FP26uiwcvb12mooncollider12solve__joint(joint, bodies) {
    let j;
    _L: {
      let j$2;
      _L$2: {
        let j$3;
        _L$3: {
          switch (joint.$tag) {
            case 0: {
              const _Distance = joint;
              const _j = _Distance._0;
              j$3 = _j;
              break _L$3;
            }
            case 1: {
              const _Revolute = joint;
              const _j$2 = _Revolute._0;
              j$2 = _j$2;
              break _L$2;
            }
            default: {
              const _Weld = joint;
              const _j$3 = _Weld._0;
              j = _j$3;
              break _L;
            }
          }
        }
        _M0FP26uiwcvb12mooncollider15solve__distance(j$3, bodies);
        return;
      }
      _M0FP26uiwcvb12mooncollider15solve__revolute(j$2, bodies);
      return;
    }
    _M0FP26uiwcvb12mooncollider11solve__weld(j, bodies);
  }
  function _M0FP26uiwcvb12mooncollider11cell__index(v, cell_size) {
    const q = v / cell_size;
    return _M0MPC16double6Double7to__int(_M0MPC16double6Double5floor(q));
  }
  function _M0MP26uiwcvb12mooncollider8GridHash6insert(self, id, box) {
    const lo = _M0MP26uiwcvb12mooncollider4AABB3min(box);
    const hi = _M0MP26uiwcvb12mooncollider4AABB3max(box);
    const x0 = _M0FP26uiwcvb12mooncollider11cell__index(lo.x, self.cell_size);
    const x1 = _M0FP26uiwcvb12mooncollider11cell__index(hi.x, self.cell_size);
    const y0 = _M0FP26uiwcvb12mooncollider11cell__index(lo.y, self.cell_size);
    const y1 = _M0FP26uiwcvb12mooncollider11cell__index(hi.y, self.cell_size);
    let _tmp = x0;
    while (true) {
      const cx = _tmp;
      if (cx <= x1) {
        let _tmp$2 = y0;
        while (true) {
          const cy = _tmp$2;
          if (cy <= y1) {
            const key = new _M0TP26uiwcvb12mooncollider7CellKey(cx, cy);
            let arr;
            _L: {
              _L$2: {
                const _bind = _M0MPB3Map3getGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self.cells, key);
                if (_bind.$tag === 1) {
                  const _Some = _bind;
                  const _arr = _Some._0;
                  arr = _arr;
                  break _L$2;
                } else {
                  const arr$2 = [];
                  _M0MPC15array5Array4pushGiE(arr$2, id);
                  _M0MPB3Map3setGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self.cells, key, arr$2);
                }
                break _L;
              }
              _M0MPC15array5Array4pushGiE(arr, id);
            }
            _tmp$2 = cy + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _tmp = cx + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
  function _M0MP26uiwcvb12mooncollider8GridHash3new(cell_size) {
    const _bind = [];
    return new _M0TP26uiwcvb12mooncollider8GridHash(cell_size, _M0MPB3Map3MapGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(new _M0TPB9ArrayViewGURP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEEE(_bind, 0, 0), undefined));
  }
  function _M0MP26uiwcvb12mooncollider8GridHash5pairs(self) {
    const result = [];
    const _bind = [];
    const seen = _M0MPB3Map3MapGUiiEuE(new _M0TPB9ArrayViewGUUiiEuEE(_bind, 0, 0), undefined);
    _M0MPB3Map4eachGRP26uiwcvb12mooncollider7CellKeyRPB5ArrayGiEE(self.cells, (_k, arr) => {
      const n = arr.length;
      let _tmp = 0;
      while (true) {
        const i = _tmp;
        if (i < n) {
          let _tmp$2 = i + 1 | 0;
          while (true) {
            const j = _tmp$2;
            if (j < n) {
              const a = _M0MPC15array5Array2atGiE(arr, i);
              const b = _M0MPC15array5Array2atGiE(arr, j);
              let lo;
              let hi;
              _L: {
                if (a < b) {
                  lo = a;
                  hi = b;
                  break _L;
                } else {
                  lo = b;
                  hi = a;
                  break _L;
                }
              }
              const pk = { _0: lo, _1: hi };
              if (!_M0MPB3Map8containsGUiiEuE(seen, pk)) {
                _M0MPB3Map3setGUiiEuE(seen, pk, undefined);
                _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(result, { _0: lo, _1: hi });
              }
              _tmp$2 = j + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _tmp = i + 1 | 0;
          continue;
        } else {
          return;
        }
      }
    });
    return result;
  }
  function _M0MP26uiwcvb12mooncollider8Manifold20has__second__contact(self) {
    return _M0MP26uiwcvb12mooncollider4Vec210length__sq(self.contact2) > 0;
  }
  function _M0MP26uiwcvb12mooncollider5World28positional__correct__contact(self, c) {
    const sa = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(c.a);
    const sb = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(c.b);
    const m = _M0FP26uiwcvb12mooncollider7collide(sa, sb);
    if (!_M0MP26uiwcvb12mooncollider8Manifold9colliding(m)) {
      return undefined;
    }
    const inv_sum = c.a.inv_mass + c.b.inv_mass;
    if (inv_sum === 0) {
      return undefined;
    }
    const correction = _M0MPC16double6Double3max(m.depth - self.slop, 0) / inv_sum * self.position_correction;
    const delta = _M0MP26uiwcvb12mooncollider4Vec25scale(m.normal, correction);
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(c.a)) {
      c.a.position = _M0MP26uiwcvb12mooncollider4Vec23sub(c.a.position, _M0MP26uiwcvb12mooncollider4Vec25scale(delta, c.a.inv_mass));
      _M0MP26uiwcvb12mooncollider9RigidBody12update__aabb(c.a);
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(c.b)) {
      c.b.position = _M0MP26uiwcvb12mooncollider4Vec23add(c.b.position, _M0MP26uiwcvb12mooncollider4Vec25scale(delta, c.b.inv_mass));
      _M0MP26uiwcvb12mooncollider9RigidBody12update__aabb(c.b);
      return;
    } else {
      return;
    }
  }
  function _M0MP26uiwcvb12mooncollider5World14solve__contact(self, c) {
    const a = c.a;
    const b = c.b;
    const ra = _M0MP26uiwcvb12mooncollider4Vec23sub(c.contact_point, a.position);
    const rb = _M0MP26uiwcvb12mooncollider4Vec23sub(c.contact_point, b.position);
    const va = _M0MP26uiwcvb12mooncollider4Vec23add(a.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x));
    const vb = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x));
    const rv = _M0MP26uiwcvb12mooncollider4Vec23sub(vb, va);
    const vel_along_normal = _M0MP26uiwcvb12mooncollider4Vec23dot(rv, c.normal);
    if (vel_along_normal > 0) {
      return undefined;
    }
    const ra_cross_n = _M0MP26uiwcvb12mooncollider4Vec25cross(ra, c.normal);
    const rb_cross_n = _M0MP26uiwcvb12mooncollider4Vec25cross(rb, c.normal);
    const inv_mass_sum = a.inv_mass + b.inv_mass + ra_cross_n * ra_cross_n * a.inv_inertia + rb_cross_n * rb_cross_n * b.inv_inertia;
    if (inv_mass_sum === 0) {
      return undefined;
    }
    const j = -(1 + c.restitution) * vel_along_normal / inv_mass_sum;
    const impulse = _M0MP26uiwcvb12mooncollider4Vec25scale(c.normal, j);
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(a)) {
      a.velocity = _M0MP26uiwcvb12mooncollider4Vec23sub(a.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, a.inv_mass));
      a.angular_velocity = a.angular_velocity - _M0MP26uiwcvb12mooncollider4Vec25cross(ra, impulse) * a.inv_inertia;
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
      b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, b.inv_mass));
      b.angular_velocity = b.angular_velocity + _M0MP26uiwcvb12mooncollider4Vec25cross(rb, impulse) * b.inv_inertia;
    }
    const va2 = _M0MP26uiwcvb12mooncollider4Vec23add(a.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-a.angular_velocity * ra.y, a.angular_velocity * ra.x));
    const vb2 = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec23new(-b.angular_velocity * rb.y, b.angular_velocity * rb.x));
    const rv2 = _M0MP26uiwcvb12mooncollider4Vec23sub(vb2, va2);
    const tangent = _M0MP26uiwcvb12mooncollider4Vec23sub(rv2, _M0MP26uiwcvb12mooncollider4Vec25scale(c.normal, _M0MP26uiwcvb12mooncollider4Vec23dot(rv2, c.normal)));
    const tangent_len = _M0MP26uiwcvb12mooncollider4Vec26length(tangent);
    if (tangent_len < 1e-09) {
      return undefined;
    }
    const tangent_dir = _M0MP26uiwcvb12mooncollider4Vec25scale(tangent, 1 / tangent_len);
    const ra_cross_t = _M0MP26uiwcvb12mooncollider4Vec25cross(ra, tangent_dir);
    const rb_cross_t = _M0MP26uiwcvb12mooncollider4Vec25cross(rb, tangent_dir);
    const inv_mass_sum_t = a.inv_mass + b.inv_mass + ra_cross_t * ra_cross_t * a.inv_inertia + rb_cross_t * rb_cross_t * b.inv_inertia;
    if (inv_mass_sum_t === 0) {
      return undefined;
    }
    const jt = new _M0TPB8MutLocalGdE(-_M0MP26uiwcvb12mooncollider4Vec23dot(rv2, tangent_dir) / inv_mass_sum_t);
    const max_friction = Math.abs(j) * c.friction;
    if (Math.abs(jt.val) > max_friction) {
      jt.val = jt.val > 0 ? max_friction : -max_friction;
    }
    const friction_impulse = _M0MP26uiwcvb12mooncollider4Vec25scale(tangent_dir, jt.val);
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(a)) {
      a.velocity = _M0MP26uiwcvb12mooncollider4Vec23sub(a.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(friction_impulse, a.inv_mass));
      a.angular_velocity = a.angular_velocity - _M0MP26uiwcvb12mooncollider4Vec25cross(ra, friction_impulse) * a.inv_inertia;
    }
    if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
      b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(friction_impulse, b.inv_mass));
      b.angular_velocity = b.angular_velocity + _M0MP26uiwcvb12mooncollider4Vec25cross(rb, friction_impulse) * b.inv_inertia;
      return;
    } else {
      return;
    }
  }
  function _M0MP26uiwcvb12mooncollider5World4step(self, dt) {
    if (dt <= 0) {
      return undefined;
    }
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < self.bodies.length) {
        _L: {
          const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, i);
          if (_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b) || !b.alive) {
            break _L;
          }
          b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(self.gravity, b.gravity_scale * dt));
          b.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(b.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(b.force, b.inv_mass * dt));
          b.angular_velocity = b.angular_velocity + b.inv_inertia * b.torque * dt;
          const damp = _M0MPC16double6Double3max(1 - b.linear_damping * dt, 0);
          b.velocity = _M0MP26uiwcvb12mooncollider4Vec25scale(b.velocity, damp);
          const adamp = _M0MPC16double6Double3max(1 - b.angular_damping * dt, 0);
          b.angular_velocity = b.angular_velocity * adamp;
          b.force = _M0MP26uiwcvb12mooncollider4Vec24zero();
          b.torque = 0;
          break _L;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const grid = _M0MP26uiwcvb12mooncollider8GridHash3new(self.grid_cell_size);
    let _tmp$2 = 0;
    while (true) {
      const i = _tmp$2;
      if (i < self.bodies.length) {
        if (_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, i).alive) {
          _M0MP26uiwcvb12mooncollider8GridHash6insert(grid, i, _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, i).aabb);
        }
        _tmp$2 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const pairs = _M0MP26uiwcvb12mooncollider8GridHash5pairs(grid);
    const contacts = [];
    let _tmp$3 = 0;
    while (true) {
      const k = _tmp$3;
      if (k < pairs.length) {
        _L: {
          let a_id;
          let b_id;
          _L$2: {
            const _bind = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(pairs, k);
            const _a_id = _bind._0;
            const _b_id = _bind._1;
            a_id = _a_id;
            b_id = _b_id;
            break _L$2;
          }
          const a = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, a_id);
          const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, b_id);
          if (!a.alive || !b.alive) {
            break _L;
          }
          const sa = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(a);
          const sb = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
          const m = _M0FP26uiwcvb12mooncollider7collide(sa, sb);
          if (_M0MP26uiwcvb12mooncollider8Manifold9colliding(m)) {
            _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(contacts, _M0FP26uiwcvb12mooncollider13make__contact(a, b, m, m.contact));
            if (_M0MP26uiwcvb12mooncollider8Manifold20has__second__contact(m)) {
              _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(contacts, _M0FP26uiwcvb12mooncollider13make__contact(a, b, m, m.contact2));
            }
          }
          break _L;
        }
        _tmp$3 = k + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const iters = self.velocity_iterations > 0 ? self.velocity_iterations : 1;
    let _tmp$4 = 0;
    while (true) {
      const _iter = _tmp$4;
      if (_iter < iters) {
        let _tmp$5 = 0;
        while (true) {
          const ci = _tmp$5;
          if (ci < contacts.length) {
            _M0MP26uiwcvb12mooncollider5World14solve__contact(self, _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(contacts, ci));
            _tmp$5 = ci + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        let _tmp$6 = 0;
        while (true) {
          const ji = _tmp$6;
          if (ji < self.joints.length) {
            _M0FP26uiwcvb12mooncollider12solve__joint(_M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.joints, ji), self.bodies);
            _tmp$6 = ji + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _tmp$4 = _iter + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    let _tmp$5 = 0;
    while (true) {
      const i = _tmp$5;
      if (i < self.bodies.length) {
        _L: {
          const b = _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(self.bodies, i);
          if (_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b) || !b.alive) {
            break _L;
          }
          const _bind = b.shape;
          if (_bind.$tag === 0) {
            b.angular_velocity = 0;
          }
          b.position = _M0MP26uiwcvb12mooncollider4Vec23add(b.position, _M0MP26uiwcvb12mooncollider4Vec25scale(b.velocity, dt));
          b.angle = b.angle + b.angular_velocity * dt;
          _M0MP26uiwcvb12mooncollider9RigidBody12update__aabb(b);
          break _L;
        }
        _tmp$5 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const pos_iters = 4;
    let _tmp$6 = 0;
    while (true) {
      const _pi = _tmp$6;
      if (_pi < pos_iters) {
        let _tmp$7 = 0;
        while (true) {
          const ci = _tmp$7;
          if (ci < contacts.length) {
            _M0MP26uiwcvb12mooncollider5World28positional__correct__contact(self, _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(contacts, ci));
            _tmp$7 = ci + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _tmp$6 = _pi + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
  function _M0MP26uiwcvb12mooncollider4AABB8contains(self, p) {
    const lo = _M0MP26uiwcvb12mooncollider4AABB3min(self);
    const hi = _M0MP26uiwcvb12mooncollider4AABB3max(self);
    return p.x >= lo.x && (p.x <= hi.x && (p.y >= lo.y && p.y <= hi.y));
  }
  function _M0MP26uiwcvb12mooncollider6Circle8contains(self, p) {
    const d = _M0MP26uiwcvb12mooncollider4Vec23sub(p, self.center);
    return _M0MP26uiwcvb12mooncollider4Vec210length__sq(d) <= self.radius * self.radius;
  }
  function _M0MP26uiwcvb12mooncollider5Shape10from__aabb(aabb) {
    return new _M0DTP26uiwcvb12mooncollider5Shape4AABB(aabb);
  }
  function _M0MP26uiwcvb12mooncollider5Shape12from__circle(c) {
    return new _M0DTP26uiwcvb12mooncollider5Shape6Circle(c);
  }
  function _M0MP26uiwcvb12mooncollider7BodyDef7dynamic(position, shape, mass, restitution) {
    return new _M0TP26uiwcvb12mooncollider7BodyDef(1, position, 0, shape, mass, restitution, 0.2, 0.1, 0.1, 1);
  }
  function _M0MP26uiwcvb12mooncollider7BodyDef8static__(position, shape) {
    return new _M0TP26uiwcvb12mooncollider7BodyDef(0, position, 0, shape, 0, 0, 0.4, 0, 0, 0);
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody12apply__force(self, f) {
    self.force = _M0MP26uiwcvb12mooncollider4Vec23add(self.force, f);
  }
  function _M0MP26uiwcvb12mooncollider9RigidBody22apply__linear__impulse(self, impulse) {
    if (self.inv_mass === 0) {
      return undefined;
    }
    self.velocity = _M0MP26uiwcvb12mooncollider4Vec23add(self.velocity, _M0MP26uiwcvb12mooncollider4Vec25scale(impulse, self.inv_mass));
  }
  function _M0MP46uiwcvb12mooncollider3cmd3web9WorldSlot3new() {
    return new _M0TP46uiwcvb12mooncollider3cmd3web9WorldSlot(_M0MP26uiwcvb12mooncollider5World3new(), -1, _M0MP26uiwcvb12mooncollider4Vec24zero());
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web4slot() {
    while (true) {
      if (_M0FP46uiwcvb12mooncollider3cmd3web5slots.length <= _M0FP46uiwcvb12mooncollider3cmd3web7current.v) {
        _M0MPC15array5Array4pushGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(_M0FP46uiwcvb12mooncollider3cmd3web5slots, _M0MP46uiwcvb12mooncollider3cmd3web9WorldSlot3new());
        continue;
      } else {
        break;
      }
    }
    return _M0MPC15array5Array2atGRP46uiwcvb12mooncollider3cmd3web9WorldSlotE(_M0FP46uiwcvb12mooncollider3cmd3web5slots, _M0FP46uiwcvb12mooncollider3cmd3web7current.v);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web15web__use__world(id) {
    _M0FP46uiwcvb12mooncollider3cmd3web7current.v = id;
    _M0FP46uiwcvb12mooncollider3cmd3web4slot();
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web9web__init() {
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().w = _M0MP26uiwcvb12mooncollider5World3new();
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_id = -1;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web14web__add__ball(x, y, radius, mass) {
    return _M0MP26uiwcvb12mooncollider5World9add__body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, _M0MP26uiwcvb12mooncollider7BodyDef7dynamic(_M0MP26uiwcvb12mooncollider4Vec23new(x, y), _M0MP26uiwcvb12mooncollider5Shape12from__circle(_M0MP26uiwcvb12mooncollider6Circle3new(_M0MP26uiwcvb12mooncollider4Vec24zero(), radius)), mass, 0.6));
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web13web__add__box(x, y, hw, hh, mass) {
    return _M0MP26uiwcvb12mooncollider5World9add__body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, _M0MP26uiwcvb12mooncollider7BodyDef7dynamic(_M0MP26uiwcvb12mooncollider4Vec23new(x, y), _M0MP26uiwcvb12mooncollider5Shape10from__aabb(_M0MP26uiwcvb12mooncollider4AABB14from__min__max(_M0MP26uiwcvb12mooncollider4Vec23new(-hw, -hh), _M0MP26uiwcvb12mooncollider4Vec23new(hw, hh))), mass, 0.4));
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web14web__add__wall(x, y, hw, hh) {
    return _M0MP26uiwcvb12mooncollider5World9add__body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, _M0MP26uiwcvb12mooncollider7BodyDef8static__(_M0MP26uiwcvb12mooncollider4Vec23new(x, y), _M0MP26uiwcvb12mooncollider5Shape10from__aabb(_M0MP26uiwcvb12mooncollider4AABB14from__min__max(_M0MP26uiwcvb12mooncollider4Vec23new(-hw, -hh), _M0MP26uiwcvb12mooncollider4Vec23new(hw, hh)))));
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web9web__step(dt) {
    if (_M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_id >= 0) {
      const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_id);
      if (!_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
        const dx = _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_target.x - b.position.x;
        const dy = _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_target.y - b.position.y;
        const k = 40 * b.mass;
        const c = 10 * b.mass;
        const fx = k * dx - c * b.velocity.x;
        const fy = k * dy - c * b.velocity.y;
        _M0MP26uiwcvb12mooncollider9RigidBody12apply__force(b, _M0MP26uiwcvb12mooncollider4Vec23new(fx, fy));
      }
    }
    _M0MP26uiwcvb12mooncollider5World4step(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, dt);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web16web__body__count() {
    return _M0MP26uiwcvb12mooncollider5World11body__count(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web11web__get__x(id) {
    return _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id).position.x;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web11web__get__y(id) {
    return _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id).position.y;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web12web__get__vx(id) {
    return _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id).velocity.x;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web12web__get__vy(id) {
    return _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id).velocity.y;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web15web__get__angle(id) {
    return _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id).angle;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web16web__get__radius(id) {
    const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id);
    let c;
    _L: {
      const _bind = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
      if (_bind.$tag === 1) {
        const _Circle = _bind;
        const _c = _Circle._0;
        c = _c;
        break _L;
      } else {
        return 0;
      }
    }
    return c.radius;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web17web__get__half__w(id) {
    const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id);
    let a;
    _L: {
      const _bind = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
      if (_bind.$tag === 0) {
        const _AABB = _bind;
        const _a = _AABB._0;
        a = _a;
        break _L;
      } else {
        return 0;
      }
    }
    return a.half.x;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web17web__get__half__h(id) {
    const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id);
    let a;
    _L: {
      const _bind = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
      if (_bind.$tag === 0) {
        const _AABB = _bind;
        const _a = _AABB._0;
        a = _a;
        break _L;
      } else {
        return 0;
      }
    }
    return a.half.y;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web14web__get__type(id) {
    const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id);
    if (_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
      return 2;
    } else {
      const _bind = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
      if (_bind.$tag === 1) {
        return 0;
      } else {
        return 1;
      }
    }
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web10web__clear() {
    _M0FP46uiwcvb12mooncollider3cmd3web9web__init();
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web17web__set__gravity(x, y) {
    _M0MP26uiwcvb12mooncollider5World12set__gravity(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, _M0MP26uiwcvb12mooncollider4Vec23new(x, y));
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web19web__apply__impulse(id, ix, iy) {
    _M0MP26uiwcvb12mooncollider9RigidBody22apply__linear__impulse(_M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id), _M0MP26uiwcvb12mooncollider4Vec23new(ix, iy));
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web17web__remove__body(id) {
    _M0MP26uiwcvb12mooncollider5World12remove__body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, id);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web15web__pick__body(x, y) {
    const n = _M0MP26uiwcvb12mooncollider5World11body__count(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w);
    const found = new _M0TPB8MutLocalGiE(-1);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < n) {
        _L: {
          const b = _M0MP26uiwcvb12mooncollider5World4body(_M0FP46uiwcvb12mooncollider3cmd3web4slot().w, i);
          if (_M0MP26uiwcvb12mooncollider9RigidBody10is__static(b)) {
            break _L;
          }
          const s = _M0MP26uiwcvb12mooncollider9RigidBody12world__shape(b);
          let a;
          _L$2: {
            _L$3: {
              let c;
              _L$4: {
                _L$5: {
                  switch (s.$tag) {
                    case 1: {
                      const _Circle = s;
                      const _c = _Circle._0;
                      c = _c;
                      break _L$5;
                    }
                    case 0: {
                      const _AABB = s;
                      const _a = _AABB._0;
                      a = _a;
                      break _L$3;
                    }
                    default: {
                      const aabb = _M0MP26uiwcvb12mooncollider5Shape4aabb(s);
                      if (_M0MP26uiwcvb12mooncollider4AABB8contains(aabb, _M0MP26uiwcvb12mooncollider4Vec23new(x, y))) {
                        found.val = i;
                      }
                    }
                  }
                  break _L$4;
                }
                if (_M0MP26uiwcvb12mooncollider6Circle8contains(c, _M0MP26uiwcvb12mooncollider4Vec23new(x, y))) {
                  found.val = i;
                }
              }
              break _L$2;
            }
            if (_M0MP26uiwcvb12mooncollider4AABB8contains(a, _M0MP26uiwcvb12mooncollider4Vec23new(x, y))) {
              found.val = i;
            }
          }
          break _L;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return found.val;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web16web__drag__start(id, x, y) {
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_id = id;
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_target = _M0MP26uiwcvb12mooncollider4Vec23new(x, y);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web13web__drag__to(x, y) {
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_target = _M0MP26uiwcvb12mooncollider4Vec23new(x, y);
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web9web__drop() {
    _M0FP46uiwcvb12mooncollider3cmd3web4slot().drag_id = -1;
  }
  function _M0FP46uiwcvb12mooncollider3cmd3web13register__all() {
    const g = _M0FP46uiwcvb12mooncollider3cmd3web10js__global("MoonCollider");
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_init", _M0FP46uiwcvb12mooncollider3cmd3web9js__wrap0(_M0FP46uiwcvb12mooncollider3cmd3web9web__init));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_use_world", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap1i(_M0FP46uiwcvb12mooncollider3cmd3web15web__use__world));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_add_ball", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap4di(_M0FP46uiwcvb12mooncollider3cmd3web14web__add__ball));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_add_box", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap5di(_M0FP46uiwcvb12mooncollider3cmd3web13web__add__box));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_add_wall", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap4di(_M0FP46uiwcvb12mooncollider3cmd3web14web__add__wall));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_step", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap1d(_M0FP46uiwcvb12mooncollider3cmd3web9web__step));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_body_count", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrap0i(_M0FP46uiwcvb12mooncollider3cmd3web16web__body__count));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_x", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web11web__get__x));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_y", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web11web__get__y));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_vx", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web12web__get__vx));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_vy", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web12web__get__vy));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_angle", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web15web__get__angle));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_radius", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web16web__get__radius));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_half_w", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web17web__get__half__w));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_half_h", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapid(_M0FP46uiwcvb12mooncollider3cmd3web17web__get__half__h));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_get_type", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapii(_M0FP46uiwcvb12mooncollider3cmd3web14web__get__type));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_clear", _M0FP46uiwcvb12mooncollider3cmd3web9js__wrap0(_M0FP46uiwcvb12mooncollider3cmd3web10web__clear));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_set_gravity", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap2du(_M0FP46uiwcvb12mooncollider3cmd3web17web__set__gravity));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_apply_impulse", _M0FP46uiwcvb12mooncollider3cmd3web12js__wrap3idu(_M0FP46uiwcvb12mooncollider3cmd3web19web__apply__impulse));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_remove_body", _M0FP46uiwcvb12mooncollider3cmd3web10js__wrapiu(_M0FP46uiwcvb12mooncollider3cmd3web17web__remove__body));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_pick_body", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap2di(_M0FP46uiwcvb12mooncollider3cmd3web15web__pick__body));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_drag_start", _M0FP46uiwcvb12mooncollider3cmd3web12js__wrap3idu(_M0FP46uiwcvb12mooncollider3cmd3web16web__drag__start));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_drag_to", _M0FP46uiwcvb12mooncollider3cmd3web11js__wrap2du(_M0FP46uiwcvb12mooncollider3cmd3web13web__drag__to));
    _M0FP46uiwcvb12mooncollider3cmd3web7js__set(g, "web_drop", _M0FP46uiwcvb12mooncollider3cmd3web9js__wrap0(_M0FP46uiwcvb12mooncollider3cmd3web9web__drop));
  }
  (() => {
    _M0FP46uiwcvb12mooncollider3cmd3web4slot();
    _M0FP46uiwcvb12mooncollider3cmd3web13register__all();
  })();
})();
//# sourceMappingURL=web.js.map
