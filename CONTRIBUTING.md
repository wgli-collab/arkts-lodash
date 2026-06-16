# Contributing

Contributions are welcome — bug reports, feature requests, documentation improvements, and code contributions.

## Getting Started

1. Clone the repo and open it in DevEco Studio
2. The library source is in `library/src/main/ets/`
3. The demo app is in `entry/`

## Development

### Project Structure

```
arkts-lodash/
├── library/                       # The arkts-lodash library (HAR)
│   └── src/main/ets/
│       ├── Index.ets              # Barrel export (230+ functions)
│       ├── types.ets              # Type definitions
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
│       ├── lang_typecheck.ets     # isArray, isObject, isString, ... (31 type checks)
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
├── entry/                         # Demo/test application
└── README.md
```

### ArkTS Constraints

All code must comply with HarmonyOS ArkTS strict-mode:
- No `any` / `unknown` types
- No `Symbol()`
- No `delete` operator
- No `for...in` loops
- No spread syntax (`...`)
- No `Function.bind()` / `Function.call()` / `Function.apply()`
- No indexed access on untyped objects

### Before Submitting

- Verify the code compiles in DevEco Studio (`hvigorw assembleHar`)
- Ensure new code follows the same patterns as the surrounding modules
- Add barrel export to `Index.ets` if adding new functions

## Reporting Issues

Please include:
- HarmonyOS / SDK version
- Minimal reproduction code snippet
- Expected vs actual behavior
- Whether it works in standard lodash (for behavior regressions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
