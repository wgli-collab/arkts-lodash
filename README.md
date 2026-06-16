# arkts-lodash

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-6.1.1(24)-blue)](https://developer.harmonyos.com/)
[![ArkTS](https://img.shields.io/badge/ArkTS-strict--mode-orange)](https://developer.huawei.com/consumer/cn/arkts/)

[lodash](https://github.com/lodash/lodash) v4.17.21 的 HarmonyOS ArkTS 移植版本。提供 **230+ 个实用工具函数**，涵盖 Array、Collection、Function、Lang、Math、Object、String、Util 八大类，全部通过 ArkTS strict-mode 编译。

## 特性

- 🔢 **230+ 函数** — 完整移植 lodash v4.17.21 核心 API
- 📐 **类型安全** — 纯 ArkTS strict-mode，0 个 `any`/`unknown`
- 🔧 **零依赖** — 纯算法实现，不依赖任何第三方库
- 📦 **模块化** — 按 lodash 原始分类组织，按需导入
- ✅ **Auditor 合规** — 通过 ArkTS strict-mode 规则检查

## 安装

```bash
ohpm install @ohos/arkts-lodash
```

或本地依赖：

```json5
// entry/oh-package.json5
{
  "dependencies": {
    "library": "file:../library"
  }
}
```

## 快速开始

```typescript
import { 
  chunk, debounce, get, cloneDeep, groupBy, 
  orderBy, uniq, merge, camelCase, throttle 
} from 'library';

// 数组操作
chunk(['a', 'b', 'c', 'd'], 2);
// → [['a', 'b'], ['c', 'd']]

uniq([2, 1, 2, 3, 1]);
// → [2, 1, 3]

// 集合操作
groupBy([6.1, 4.2, 6.3], Math.floor);
// → { '4': [4.2], '6': [6.1, 6.3] }

orderBy(
  [{ name: 'b', age: 30 }, { name: 'a', age: 20 }],
  ['age'], ['asc']
);
// → [{ name: 'a', age: 20 }, { name: 'b', age: 30 }]

// 对象操作
const obj = { a: [{ b: { c: 3 } }] };
get(obj, 'a[0].b.c');
// → 3

const cloned = cloneDeep({ a: { b: 1 } });
cloned.a.b = 2;
// obj.a.b still → 1

// 函数工具
const onResize = debounce(() => {
  console.log('resize done');
}, 300);

const onScroll = throttle(() => {
  console.log('scrolling');
}, 100);

// 字符串
camelCase('foo-bar');
// → 'fooBar'
```

## API 分类

| 分类 | 数量 | 核心函数 |
|------|:--:|------|
| **Array** | 60+ | chunk, compact, concat, difference*, drop*, fill, flatten*, fromPairs, head, indexOf, intersection*, join, last, nth, pull*, remove, slice, sortedIndex*, take*, union*, uniq*, without, xor*, zip* |
| **Collection** | 20+ | countBy, every, filter, find, findLast, flatMap*, forEach, groupBy, includes, invokeMap, keyBy, map, orderBy, partition, reduce, reduceRight, reject, sample, shuffle, size, some, sortBy |
| **Function** | 25+ | after, before, bind*, curry*, debounce, defer, delay, flow, flowRight, memoize, negate, once, overArgs, partial*, rearg, spread, throttle, wrap |
| **Lang** | 45+ | castArray, clone, cloneDeep, conformsTo, eq, gt, gte, is* (31 个类型检查), isEqual, isMatch, lt, lte, toArray, toInteger, toNumber, toString |
| **Math** | 15+ | add, ceil, clamp, divide, floor, inRange, max, maxBy, mean, meanBy, min, minBy, multiply, random, round, subtract, sum, sumBy |
| **Object** | 30+ | assign*, at, create, defaults*, findKey*, forIn*, forOwn*, functions*, get, has, invert, keys, keysIn, mapKeys, mapValues, merge*, omit*, pick*, result, set, transform, unset, update, values, valuesIn |
| **String** | 25+ | camelCase, capitalize, deburr, endsWith, escape, escapeRegExp, kebabCase, lowerCase, lowerFirst, pad*, parseInt, repeat, replace, snakeCase, split, startCase, startsWith, trim*, truncate, unescape, upperCase, upperFirst, words |
| **Util** | 15+ | attempt, constant, defaultTo, identity, method, methodOf, mixin, noop, nthArg, property, propertyOf, range, times, toPath, uniqueId |

## 项目结构

```
arkts-lodash/
├── library/                       # HAR 库模块
│   └── src/main/ets/
│       ├── Index.ets              # 桶导出 (230+ 函数 + 常用别名)
│       ├── types.ets              # 类型定义
│       ├── array_basic.ets        # chunk, compact, concat, drop*, fill, flatten*, ...
│       ├── array_search.ets       # findIndex*, indexOf, pull*, sortedIndex*, ...
│       ├── array_set.ets          # difference*, intersection*, union*, uniq*, xor*, zip*
│       ├── collection_core.ets    # forEach, map, filter, reduce*, find*, every, some, ...
│       ├── collection_group.ets   # countBy, groupBy, keyBy, partition, sortBy, shuffle, ...
│       ├── function_bind.ets      # bind, bindKey, curry*, partial*, rearg
│       ├── function_compose.ets   # flow, flowRight, over*, cond, conforms, matches*
│       ├── function_timing.ets    # debounce, throttle, defer, delay
│       ├── function_wrap.ets      # after, before, ary, unary, negate, once, memoize, ...
│       ├── lang_compare.ets       # eq, gt, lt, isEqual, isMatch, conformsTo
│       ├── lang_convert.ets       # castArray, toArray, toNumber, toString, clone*, ...
│       ├── lang_typecheck.ets     # isArray, isObject, isString, ... (31 个类型检查)
│       ├── math_basic.ets         # add, subtract, multiply, divide, ceil, floor, round, ...
│       ├── math_extremum.ets      # max, maxBy, min, minBy, clamp, inRange, random
│       ├── object_access.ets      # get, set, has, unset, update, at, result, invoke
│       ├── object_iterate.ets     # keys, keysIn, values, valuesIn, forOwn*, forIn*, ...
│       ├── object_transform.ets   # assign*, merge*, defaults*, omit*, pick*, mapKeys, ...
│       ├── string_case.ets        # camelCase, kebabCase, snakeCase, upperCase, ...
│       ├── string_escape.ets      # escape, escapeRegExp, unescape
│       ├── string_manip.ets       # endsWith, startsWith, pad*, trim*, truncate, words, ...
│       ├── util_misc.ets          # attempt, constant, identity, noop, range, times, ...
│       └── util_stubs.ets         # stubArray, stubFalse, stubObject, stubString, stubTrue
└── entry/                         # 测试入口模块
    └── src/main/ets/pages/
        └── Index.ets              # 测试用例
```

## 常用别名

遵循 lodash v4 约定，提供常用别名：

```typescript
import { each, first, extend, rest, entries } from 'library';
//            ↓      ↓       ↓       ↓       ↓
//         forEach  head   assign   tail   toPairs
```

## 与 lodash 的区别

| lodash (JavaScript) | arkts-lodash (ArkTS) |
|------|------|
| `_.chain()` + `_.prototype` 链式调用 | 不支持 — 函数式调用 |
| `_.template()` | 不支持 — ArkTS 无 HTML 模板 |
| `_.now()` | 直接用 `Date.now()` |
| `_.mixin()` 修改 `_` 全局 | 仅本地 `mixin()`，无全局 `_` |
| `Symbol` / `isSymbol` | 返回 `false` — ArkTS 无 Symbol |
| `isElement` | 返回 `false` — 无 DOM |
| `isEqual` 自动检测循环引用 | 当前不支持循环引用检测 |

## 质量保证

| 指标 | 值 |
|------|:--:|
| ArkTS strict-mode 编译 | ✅ BUILD SUCCESSFUL |
| API 数量 | 230+ |
| 源文件 | 25 `.ets` 文件 |

## 许可证

MIT — 与原 lodash 保持一致。

## 致谢

- [lodash](https://github.com/lodash/lodash) by John-David Dalton — 原创 JavaScript 工具库
- HarmonyOS 三方库迁移实验 Group B
