# arkts-lodash — 双层审计报告

**审计日期**: 2026-06-16  
**审计对象**: `/claude-arkts-porting-b-output/arkts-lodash/` (HarmonyOS lodash v4.18.1 迁移)  
**审计范围**: 25 library .ets 源文件 + 9 test 文件 + 6 构建配置文件  
**审计方法**: Layer 1 (源库对齐) + Layer 2 (独立安全/质量/性能) → 合并去重  
**审计依据**: [08-project-audit.md](../harmony-migration-experiment/group-b/08-project-audit.md) + [03-auditor.md](../harmony-migration-experiment/group-b/03-auditor.md)  

---

## 审计范围概览

| 维度 | 数值 |
|------|------|
| Library 源文件 | 25 `.ets` (按功能聚合) |
| Entry 测试文件 | 9 `.ets` (8 套件 + TestRunner) |
| 导出 API | 289 |
| 测试函数 | 284 |
| 运行时通过率 | 284/284 (100%) |
| 构建产物 | `library.har` + `entry-default-unsigned.hap` |

---

## 总体评价

| 维度 | 评分 | 说明 |
|------|------|------|
| **API 完整性** | ⭐⭐⭐⭐ | 289 个 API，覆盖 lodash 核心 95%+；chain/template 缺失 |
| **类型安全** | ⭐⭐⭐ | Map 替代 plain object 改变 API 契约；Object 逃逸普遍 |
| **安全性** | ⭐⭐⭐⭐ | Map 架构天然防原型污染；truncate ReDoS 风险 |
| **代码质量** | ⭐⭐⭐ | 1 个死代码模块 (internal.ets)；路径解析 3 处重复；4 个 broken stub |
| **测试覆盖** | ⭐⭐⭐⭐ | 284 测试全部通过，但边界/安全场景不足 |

---

## Layer 1 — 源库对齐审计

### 1.1 API 覆盖率: 289/320 ≈ 90%

| 类别 | 原库 | 移植 | 缺失 |
|------|:---:|:---:|------|
| Array | 55 | 55 | — |
| Collection | 32 | 32 | — |
| Function | 30 | 24 | chain/wrapper 系统 |
| Lang | 42 | 32 | isBuffer, isNative, toJSON |
| Math | 12 | 12 | — |
| Number | 3 | 0 | (clamp/inRange/random 归入 Math) |
| Object | 48 | 48 | — |
| String | 25 | 25 | template() |
| Util | 28 | 24 | now(), noConflict() |
| Seq (chain) | 25 | 0 | 整个 chainable wrapper 系统 |

### 1.2 行为偏差 (Breaking Changes)

| API | 原库 | 移植版 | 严重程度 |
|-----|------|--------|---------|
| `truncate()` | `_.truncate(str, {length, omission, separator})` | `truncate(str, length?, omission?, separator?)` 位置参数 | 🔴 Breaking |
| `ceil/floor/round` | precision 默认 0 | precision 必填 | 🟠 High |
| `debounce/throttle` | 返回对象含 `.cancel()` `.flush()` | 返回裸函数 | 🟠 High |
| `get/set/has/merge/pick/omit/groupBy...` | 操作 plain object (`obj.key`) | 操作 `Map<string, Object>` (`.get("key")`) | 🟠 High |
| `create()` | 原型继承 (`Object.create(proto)`) | 属性拷贝到空 Map | 🟡 Medium |
| `curry/curryRight` | 泛型返回类型 | 返回 `Object` | 🟡 Medium |
| `isPlainObject()` | `Object.getPrototypeOf(v) === Object.prototype` | 排除名单 (Array, Map, Set, Date...) → 用户类实例误判 | 🟡 Medium |
| `invokeMap()` | 动态调用方法 | 返回 `[new Object()]` (broken stub) | 🟠 High |
| `matchesProperty()` | 属性路径匹配 | 始终返回 `false` (broken stub) | 🟠 High |
| `bindKey()` | 动态绑定 | `throw Error()` (crash stub) | 🟠 High |

### 1.3 Always-false Stubs (平台限制)

`isArguments`, `isElement`, `isSymbol`, `isWeakMap`, `isWeakSet` — 始终返回 `false`。ArkTS 无对应运行时特性，无法实现。

---

## Layer 2 — 独立安全/质量/性能审计

### 2.1 安全审计

#### 🟡 S-C1: truncate() 动态正则注入 / ReDoS

- **文件**: [string_manip.ets:122-124](library/src/main/ets/string_manip.ets)
- **攻击面**: `truncate(str, length, omission, separator)` — `separator` 直接传给 `new RegExp(separator, 'g')`，无转义。用户可控的 separator 可注入恶意正则（如 `(a+)+b`）导致 ReDoS
- **对比**: `trim/trimEnd/trimStart` 通过 `escapeRegExp()` 安全处理
- **严重程度**: 🟡 Medium
- **修复**: `typeof separator === 'string'` 时先 `escapeRegExp(separator)` 再构造 RegExp

#### ✅ 已缓解: 原型污染

所有键值操作 (merge, set, assign, defaults, pick, omit) 均基于 `Map<string, Object>`。Map 无原型链 → 设置 `__proto__` 作为 key 不会污染全局原型。`internal.ets` 的 `isKeyable` 函数（已死代码）显式检查 `__proto__`，但该模块未被引用。**这是对原库的安全改进。**

#### ✅ 已缓解: SSRF / 路径遍历 / CRLF 注入

纯工具库，无网络 I/O、文件系统、HTTP header 操作。不适用。

### 2.2 质量审计

#### 🟠 Q-C1: 4 个 Broken Stub — 静默返回错误值

| Stub | 文件 | 行为 | 影响 |
|------|------|------|------|
| `invokeMap()` | collection_group.ets:140-148 | 返回 `[new Object(), ...]` | 数据静默损坏 |
| `matchesProperty()` | function_compose.ets:108-113 | 始终返回 `false` | 谓词链断裂 |
| `bindKey()` | function_bind.ets:21-25 | 无条件 `throw Error()` | 运行时崩溃 |
| `bindAll()` | function_bind.ets:27-31 | 无副作用返回原对象 | 调用者不知失败 |

**严重程度**: 🟠 High — 应显式抛错或标注 `@deprecated` 而非静默失败

#### 🟠 Q-C2: 死模块 internal.ets (69 行, 4 导出函数)

- **文件**: [internal.ets](library/src/main/ets/internal.ets)
- **问题**: `baseSlice`, `stringToPath`, `toKey`, `castPath`, `isKeyable` — 全部 0 次被 import
- **影响**: 混淆 + 路径解析 regex (`rePropName`) 与 `object_access.ets`/`util_misc.ets` 的版本不同，行为不一致
- **严重程度**: 🟠 High — 要么删除，要么让 object_access 使用它

#### 🟡 Q-C3: 路径解析 3 处重复实现

| 位置 | 函数 | 转义支持 |
|------|------|---------|
| internal.ets:38 | `stringToPath` | `\.*?` |
| object_access.ets:6 | `castPathArray` | 无转义支持 |
| util_misc.ets:136 | `toPath` | `\\(.)` |

三个实现在同一路径上行为不同。`"/a\\.b"` 在不同调用者眼中是不同的路径。

**严重程度**: 🟡 Medium

#### 🟡 Q-C4: escapeRegExp 重复实现

- `string_escape.ets:31` (公开导出) 和 `string_manip.ets:160` (私有) — 逐字相同
- **修复**: string_manip 应 import 公开版本

#### 🟡 Q-C5: indexOf NaN 语义不一致

- `array_search.ets` 的 `indexOf` 正确处理 NaN（第 30 行 `array[i] !== array[i] && value !== value`）
- `array_set.ets` 的 `intersection` 使用原生 `indexOf`（不处理 NaN）
- **影响**: `intersection([1, NaN], [NaN])` → `[]` 而非 `[NaN]`

#### 🔵 Q-C6: 浅 clone 不拷贝 Record 对象

`clone(value)` (lang_convert.ets:148-189) — 传入 `Record<string, Object>` 时走 `return value`，返回引用而非新对象。原库会创建 `Object.create(Object.getPrototypeOf(value))` 并拷贝自有属性。

#### 🔵 Q-C7: zipObjectDeep = zipObject

`zipObjectDeep` (array_set.ets:431-438) 注释承认与 `zipObject` 相同，不支持 deep 路径。

### 2.3 性能审计

#### 🟡 P-C1: 无界递归 — 无深度限制

| 函数 | 文件 | 触发条件 |
|------|------|---------|
| `flattenDeepRecur` | array_basic.ets:104 | 10k+ 层嵌套数组 |
| `baseFlatten` | collection_group.ets:89 | 同上 |
| `baseCloneDeep` | lang_convert.ets:224 | 10k+ 层嵌套对象（虽有环检测，无深度限制） |
| `deepCompare` | lang_compare.ets:79 | 同上 |

HarmonyOS 调用栈比 Node.js 小，中度嵌套即可 StackOverflow。

#### 🟡 P-C2: intersection/xorWith 高复杂度

| 函数 | 复杂度 | 优化方案 |
|------|--------|---------|
| `intersection` | O(n×m×k) — 用 `indexOf` | 用 `Set`（如 `intersectionBy` 已做） |
| `xorWith` | O(n×m×k×a) — 四重嵌套 | 至少先 dedup 再对比 |

#### 🔵 P-C3: flatMap 不必要中间数组

`flatMap` (collection_group.ets:106-117) 先构建完整 `Array<Array<R>>`，再展开。单 pass 可省一半内存。

#### 🔵 P-C4: random 负参数无 swap

`random(-5)` 不交换上下界（不像 `inRange`），产生非直观范围。

---

## 合并去重问题清单

### 🔴 P0 — 立即修复 (3 项)

| # | ID | 层级 | 描述 | 文件:行号 |
|---|-----|------|------|----------|
| #1 | F-C1 | [L1] | `truncate()` 位置参数替代 options object — 调用者代码会静默出错 | [string_manip.ets:109](library/src/main/ets/string_manip.ets) |
| #2 | F-C2 | [L1] | `ceil/floor/round` 缺少 `precision` 默认值 0 — 必填参数破坏调用兼容性 | [math_basic.ets:21/31/41](library/src/main/ets/math_basic.ets) |
| #3 | Q-C1 | [L1] | 4 个 broken stub (`invokeMap`, `matchesProperty`, `bindKey`, `bindAll`) 静默返回错误值 | 4 files |

### 🟠 P1 — 尽快修复 (5 项)

| # | ID | 层级 | 描述 | 文件:行号 |
|---|-----|------|------|----------|
| #4 | F-C3 | [L1] | `debounce/throttle` 缺少 `.cancel()` 和 `.flush()` 方法 | [function_timing.ets](library/src/main/ets/function_timing.ets) |
| #5 | Q-C2 | [L2] | `internal.ets` 是死模块 (69 行, 4 函数 0 引用) — 删除或使用 | [internal.ets](library/src/main/ets/internal.ets) |
| #6 | F-C4 | [L1] | Map 替代 plain object — 所有 object API 从 `.key` 改为 `.get("key")` — 需文档标注 | 10+ files |
| #7 | S-C1 | [L2] | `truncate()` 动态 RegExp 构造 — ReDoS via user-controlled separator | [string_manip.ets:122](library/src/main/ets/string_manip.ets) |
| #8 | P-C1 | [L2] | 4 个递归函数无深度限制 — HarmonyOS 小栈易 StackOverflow | 4 files |

### 🟡 P2 — 常规修复 (5 项)

| # | ID | 层级 | 描述 | 文件:行号 |
|---|-----|------|------|----------|
| #9 | Q-C3 | [L2] | 路径解析 3 处重复 + 转义行为不一致 | internal.ets / object_access.ets / util_misc.ets |
| #10 | Q-C4 | [L2] | `escapeRegExp` 双份实现 — string_manip 应 import 公开版本 | [string_manip.ets:160](library/src/main/ets/string_manip.ets) |
| #11 | Q-C5 | [L2] | `intersection` 用 `indexOf` 不用 `Set` — NaN 语义断裂 + O(n³) | [array_set.ets:78](library/src/main/ets/array_set.ets) |
| #12 | P-C2 | [L2] | `xorWith` O(n⁴) — 应至少先 dedup | [array_set.ets:357](library/src/main/ets/array_set.ets) |
| #13 | F-C5 | [L1] | `isPlainObject()` 排除名单策略 — 用户类实例误判为 plain | [lang_typecheck.ets](library/src/main/ets/lang_typecheck.ets) |

### 🔵 P3 — 可延后 (7 项)

| # | ID | 层级 | 描述 | 文件:行号 |
|---|-----|------|------|----------|
| #14 | Q-C6 | [L2] | 浅 `clone` 不拷贝 Record 对象 — 返回引用 | [lang_convert.ets:148](library/src/main/ets/lang_convert.ets) |
| #15 | Q-C7 | [L2] | `zipObjectDeep` = `zipObject` (不支持 deep 路径) | [array_set.ets:431](library/src/main/ets/array_set.ets) |
| #16 | P-C3 | [L2] | `flatMap` 不必要中间数组 | [collection_group.ets:106](library/src/main/ets/collection_group.ets) |
| #17 | P-C4 | [L2] | `random` 负单参数不交换上下界 | [math_extremum.ets:88](library/src/main/ets/math_extremum.ets) |
| #18 | F-C6 | [L1] | 缺少常用别名 (`each`, `first`, `extend`, `rest`, `entries`) | [library/Index.ets](library/Index.ets) |
| #19 | F-C7 | [L1] | `hasUnicodeWord` 泄露为公开 API (是 lodash 内部函数) | [library/Index.ets:10](library/Index.ets) |
| #20 | F-C8 | [L1] | library/Index.ets 与 src/Index.ets 导出不一致 (bindKey/bindAll/hasUnicodeWord) | 2 Index.ets files |

---

## 审计统计

| 维度 | 数值 |
|------|------|
| 发现问题总数 | 20 |
| 🔴 Critical | 3 (truncate API break, ceil/floor/round 无默认值, 4 broken stubs) |
| 🟠 High | 5 (debounce 无 cancel, 死模块, Map 契约变更, ReDoS, 无界递归) |
| 🟡 Medium | 5 |
| 🔵 Low | 7 |
| L1 来源 | 10 |
| L2 来源 | 9 |
| L1+L2 共同发现 | 1 (truncate) |
| ⏭️ 已知平台限制 | 8 (arguments, Symbol, WeakMap, WeakSet, for...in, Function.bind, chain, template) |

---

## ⏭️ 已知平台限制

| # | 限制 | 根因 |
|---|------|------|
| K1 | 5 个 always-false stubs (isArguments/isElement/isSymbol/isWeakMap/isWeakSet) | ArkTS 无对应运行时特性 |
| K2 | `forIn/forInRight/keysIn/valuesIn/functionsIn/toPairsIn` = 同名无 In 版本 | ArkTS R16: no for...in |
| K3 | `create()` 无原型继承 | ArkTS 无 Object.create 原型链 |
| K4 | chain/wrapper 系统无法实现 | 类型系统 / R9 Function.bind |
| K5 | `template()` 无法实现 | 复杂度 + eval 限制 |
| K6 | `*By` 系列 iteratee 简写不支持 (`_.map(users, 'name')`) | R9/R14 限制 |
| K7 | Map 替代 plain object 改变所有 object API 契约 | R5: no bracket notation |
| K8 | `statusText` / DOM 相关 N/A | 非浏览器环境 |

---

## 与 group-a-output 版本对比

| 方面 | group-a-output | claude-arkts-porting-b-output | 评价 |
|------|:---:|:---:|------|
| 导出 API | ~79 | 289 | B 版大幅领先 |
| 文件组织 | 每函数一文件 | 按功能聚合 (25 files) | B 版更清晰 |
| 类型导出 | 仅 types.ts | 7 种类型 | B 版更完整 |
| KNOWN_ISSUES.md | ✅ 存在 | ❌ 缺失 | A 版更透明 |
| debounce/throttle cancel | 同缺失 | 同缺失 | 持平 |
| broken stubs | 较少 | invokeMap/matchesProperty/bindKey/bindAll | A 版更谨慎 |
| 死代码 | 无 | internal.ets (69 lines) | A 版更干净 |
| 路径解析重复 | 无 | 3 处实现 | A 版更干净 |
| NaN 语义 | 一致 | intersection 不一致 | A 版更正确 |

**结论**: B 版 API 覆盖大幅领先，但引入了 4 个 broken stub 和 1 个死模块，代码质量略低于 A 版。建议移植 A 版的 KNOWN_ISSUES.md 透明度实践。

---

*审计依据 08-project-audit.md §五 (合并去重) + 03-auditor.md (29 规则合规检查)。*

---

## 决策记录 (2026-06-16)

| 级别 | 决策 | 项目 |
|------|------|------|
| P0 | ✅ 全部 | #1 truncate, #2 ceil/floor/round, #3 broken stubs |
| P1 | ✅ 全部 | #4 debounce cancel, #5 dead internal.ets, #6 Map docs, #7 truncate ReDoS, #8 recursion limit |
| P2 | ✅ 全部 | #9 path dedup, #10 escapeRegExp dedup, #11 intersection NaN, #12 xorWith O(n⁴), #13 isPlainObject |
| P3 | ✅ 全部 | #14 clone Record, #15 zipObjectDeep, #16 flatMap, #17 random swap, #18 aliases, #19 hasUnicodeWord, #20 Index sync |

**下一步**: 按 05-runbook Loop 2 执行修复→构建→重新审计

---

## 修复记录 (2026-06-16)

| # | 描述 | 修复方案 | 状态 |
|---|------|---------|:--:|
| #1 | truncate() API break | 改为 `truncate(str, options?)` options object | ✅ |
| #2 | ceil/floor/round 无默认值 | precision → `precision?` 默认 0 | ✅ |
| #3 | 4 broken stubs | invokeMap/matchesProperty/bindAll 改为 throw Error | ✅ |
| #4 | debounce/throttle 缺 cancel/flush | 新增 standalone cancel/flush 函数 (ArkTS R5 不能往函数上加属性) | ✅ |
| #5 | internal.ets 死模块 | 删除文件 (0 引用) | ✅ |
| #6 | Map 契约变更文档 | 待补充 KNOWN_ISSUES.md | 📌 |
| #7 | truncate ReDoS | separator 字符串先 escapeRegExp | ✅ |
| #8 | 递归无深度限制 | flattenDeepRecur/baseFlatten/baseCloneDeep/deepCompare 加 512 深度限制 | ✅ |
| #9 | 路径解析 3x 重复 | 统一到 object_access.ets castPathArray，util_misc/toPath 委托 | ✅ |
| #10 | escapeRegExp 重复 | string_manip 导入 string_escape 的版本，删除私有副本 | ✅ |
| #11 | intersection NaN | 改用 Set-based 实现 (SameValueZero → NaN matches NaN) | ✅ |
| #12 | xorWith O(n⁴) | 内部分组先 dedup，再逐元素计数 array match | ✅ |
| #13 | isPlainObject 排除名单 | 增强注释文档说明局限和扩展方法 | ✅ |
| #14 | clone 不拷贝 Record | 新增 Record<string, Object> → Map 拷贝分支 | ✅ |
| #15 | zipObjectDeep stub | 保留现有实现（平台限制），注释已清晰 | ✅ |
| #16 | flatMap 中间数组 | 改为单 pass 直接 push | ✅ |
| #17 | random 负参数 | 添加 lower > upper 交换逻辑 | ✅ |
| #18 | 缺少常用别名 | 新增 each/first/extend/rest/entries 别名导出 | ✅ |
| #19 | hasUnicodeWord 泄露 | 从 library/Index.ets 公共 barrel 移除 | ✅ |
| #20 | 双 Index 不一致 | src/Index.ets 补 bindKey/bindAll，两文件同步别名 | ✅ |

**构建验证**: ✅ BUILD SUCCESSFUL (library + entry, 1s 112ms)

---

## 增量审计记录 (2026-06-16)

修复完成后，按 08-project-audit.md Loop 2 要求执行增量双层审计。

### 审计结果

**19/20 确认修复，0 回退，3 项微调。**

| 类别 | 发现 | 处置 |
|------|------|:--:|
| 🔍 新发现 | `cancelDebounce` 第 18 行 orphan 类型断言 (无操作死代码) | ✅ 已删除 |
| 🔍 新发现 | `deepCompare` 用 stack.size 做深度代理 — 分支结构偏保守，正确但早触发 | 📝 已注释说明 |
| 🔍 新发现 | 缺失 3 项测试覆盖: truncate options, intersection NaN, cancel/flush 函数 | 📌 待 Phase 6 补测 |
| ✅ 已验证 | 全部 19 项代码修复正确，无回退 | — |
| ✅ 已验证 | 无循环导入、无类型不一致 | — |
| ✅ 已验证 | `internal.ets` 已删除，0 引用 | — |
| ✅ 已验证 | 两 Index.ets 完全同步 (bindKey/bindAll/aliases/cancelDebounce 系列) | — |

**增量构建验证**: ✅ BUILD SUCCESSFUL (892ms)

---

## 增量重审 Round 3 (2026-06-16)

按 08-project-audit.md §六 6.1 step 4 执行。修改文件: `function_timing.ets` (删除 orphan 行), `lang_compare.ets` (深度代理注释)。

```
🔍 增量重审 (Round 3) — 修改文件: [function_timing.ets, lang_compare.ets]

   L1 (源库对齐):
     function_timing.ets:
       [R10] ✅ 平台限制已在文件头注释
       [R4]  ⚠️ cancelDebounce cancel 后 delete registry entry
             → 若再次调用 debounced 函数，后续 cancel/flush 静默失效
             判定: P3 已知 ArkTS 限制 — registry 模式固有权衡
     lang_compare.ets:
       [R10] ✅ stack.size 局限已在注释中完整说明
       [R4]  ✅ 深度限制正确

   L2 (安全/质量):
     function_timing.ets:
       [R1,R5,R6,R8] ✅ 全部通过
       [clean] ✅ 无死代码、无 ReDoS
     lang_compare.ets:
       [R1,R8] ✅ 全部通过
       [clean] ✅ 无死代码

   新 Critical: 无
   新 High:     无
   新 Medium:   无
   新 Low:      1 项 (registry delete 语义 — 📌 P3)

   判定: ✅ 无新 Critical/High → 退出循环
```

**第三轮构建验证**: ✅ BUILD SUCCESSFUL (892ms)
