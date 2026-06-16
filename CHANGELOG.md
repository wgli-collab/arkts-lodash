# Changelog

## 1.0.0 (2025-06-16)

Initial release — lodash v4.17.21 ported to HarmonyOS ArkTS.

### Included
- **Array** — chunk, compact, concat, drop*, fill, flatten*, fromPairs, head, initial, join, last, nth, reverse, slice, tail, take*, difference*, intersection*, union*, uniq*, without, xor*, zip*, findIndex*, indexOf, lastIndexOf, pull*, remove, sortedIndex*, sortedUniq*
- **Collection** — forEach, map, filter, reject, every, some, reduce, reduceRight, find, findLast, includes, size, countBy, groupBy, keyBy, partition, sortBy, orderBy, flatMap*, invokeMap, sample, sampleSize, shuffle
- **Function** — after, before, ary, unary, negate, once, memoize, wrap, spread, flip, bind, bindKey, bindAll, curry, curryRight, partial*, rearg, overArgs, debounce, throttle, defer, delay, flow, flowRight, over*, cond, conforms, matches*, iteratee
- **Lang** — is* (31 type checks), eq, gt, gte, lt, lte, isEqual, isMatch, conformsTo, castArray, toArray, toFinite, toInteger, toNumber, toString, clone, cloneDeep
- **Math** — add, subtract, multiply, divide, ceil, floor, round, sum, sumBy, mean, meanBy, max, maxBy, min, minBy, clamp, inRange, random
- **Object** — get, set, has, unset, update, at, result, invoke, assign, assignIn, merge, defaults, defaultsDeep, create, omit, omitBy, pick, pickBy, mapKeys, mapValues, invert, transform, keys, keysIn, values, valuesIn, forOwn*, forIn*, findKey*, functions*
- **String** — camelCase, capitalize, kebabCase, lowerCase, lowerFirst, snakeCase, startCase, upperCase, upperFirst, deburr, endsWith, startsWith, pad*, repeat, replace, split, trim*, truncate, words, parseInt, escape, escapeRegExp, unescape
- **Util** — attempt, constant, defaultTo, identity, noop, mixin, method, methodOf, nthArg, property, propertyOf, range, rangeRight, times, uniqueId, toPath

### Omitted (HarmonyOS platform constraints)
- `now()` — replaced by `Date.now()`
- `template()` — HTML template not applicable
- `mixin()` on `_` global — no global `_` in ArkTS

### Known Limitations
- Some array methods return `Array<T>` instead of mutable wrappers (no lodash chain)
- `isElement`, `isSymbol` return `false` always (no DOM, no Symbol in ArkTS)
- `isEqual` does not support circular reference detection
