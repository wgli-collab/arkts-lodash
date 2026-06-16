/**
 * ArkTS Lodash — Equality & Comparison Functions
 * All dynamic property access uses Map<K,V> instead of obj[key] (R5).
 */

// ---- Simple Comparisons ----

export function eq(value: Object | null, other: Object | null): boolean {
  return value === other || (value !== value && other !== other)
}

export function gt(value: Object | null, other: Object | null): boolean {
  return (value as number) > (other as number)
}

export function gte(value: Object | null, other: Object | null): boolean {
  return (value as number) >= (other as number)
}

export function lt(value: Object | null, other: Object | null): boolean {
  return (value as number) < (other as number)
}

export function lte(value: Object | null, other: Object | null): boolean {
  return (value as number) <= (other as number)
}

// ---- Internal Helpers ----

function isObjLike(value: Object | null): boolean {
  return typeof value === 'object' && value !== null
}

// ---- Deep Equality ----

export function isEqual(value: Object | null, other: Object | null): boolean {
  return baseIsEqual(value, other)
}

export function isEqualWith(
  value: Object | null,
  other: Object | null,
  customizer: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined
): boolean {
  return baseIsEqual(value, other, customizer)
}

function baseIsEqual(
  value: Object | null,
  other: Object | null,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  if (value === other) {
    return true
  }
  if (value === null || other === null || value === undefined || other === undefined) {
    return value === other
  }
  if (value !== value && other !== other) {
    return true
  }

  if (customizer !== undefined) {
    const customResult: boolean | undefined = customizer(value, other)
    if (customResult !== undefined) {
      return customResult
    }
  }

  if (typeof value !== typeof other) {
    return false
  }

  const effectiveStack: Map<Object, Object> = stack ?? new Map<Object, Object>()
  return deepCompare(value, other, customizer, effectiveStack)
}

const MAX_COMPARE_DEPTH: number = 512

function deepCompare(
  value: Object,
  other: Object,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  // Use stack.size as recursion depth proxy.
  // For linear nesting each level adds 1 entry — exact depth tracking.
  // For branching structures stack.size over-counts (all sibling objects accumulate),
  // making the guard trigger earlier than 512 levels. This is conservative but safe.
  if (stack !== undefined && stack.size > MAX_COMPARE_DEPTH) {
    throw new Error('isEqual: maximum recursion depth exceeded')
  }
  // Circular reference check using Map (not WeakMap — ArkTS R14)
  if (stack !== undefined && stack.has(value)) {
    return stack.get(value) === other
  }
  if (stack !== undefined) {
    stack.set(value, other)
  }

  if (value instanceof Date && other instanceof Date) {
    return value.getTime() === other.getTime()
  }
  if (value instanceof RegExp && other instanceof RegExp) {
    return value.toString() === other.toString()
  }
  if (value instanceof Map && other instanceof Map) {
    return compareMaps(value, other, customizer, stack)
  }
  if (value instanceof Set && other instanceof Set) {
    return compareSets(value, other, customizer, stack)
  }

  if (Array.isArray(value) && Array.isArray(other)) {
    return compareArrays(value as Array<Object>, other as Array<Object>, customizer, stack)
  }

  if (isObjLike(value) && isObjLike(other)) {
    return compareObjects(
      value as Map<string, Object>,
      other as Map<string, Object>,
      customizer,
      stack
    )
  }

  return false
}

function compareArrays(
  value: Array<Object>,
  other: Array<Object>,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  if (value.length !== other.length) {
    return false
  }
  for (let i: number = 0; i < value.length; i++) {
    if (!baseIsEqual(value[i], other[i], customizer, stack)) {
      return false
    }
  }
  return true
}

function compareObjects(
  value: Map<string, Object>,
  other: Map<string, Object>,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  if (value.size !== other.size) {
    return false
  }
  // Check all keys of value exist in other
  const keysIter: IterableIterator<string> = value.keys()
  let keyResult: IteratorResult<string> = keysIter.next()
  while (!keyResult.done) {
    const key: string = keyResult.value
    if (!other.has(key)) {
      return false
    }
    keyResult = keysIter.next()
  }
  // Deep compare each value
  const keysIter2: IterableIterator<string> = value.keys()
  let keyResult2: IteratorResult<string> = keysIter2.next()
  while (!keyResult2.done) {
    const key: string = keyResult2.value
    if (!baseIsEqual(value.get(key) ?? null, other.get(key) ?? null, customizer, stack)) {
      return false
    }
    keyResult2 = keysIter2.next()
  }
  return true
}

function compareMaps(
  value: Map<Object, Object>,
  other: Map<Object, Object>,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  if (value.size !== other.size) {
    return false
  }
  const keysIter: IterableIterator<Object> = value.keys()
  let keyResult: IteratorResult<Object> = keysIter.next()
  while (!keyResult.done) {
    const k: Object = keyResult.value
    if (!other.has(k) || !baseIsEqual(value.get(k) ?? null, other.get(k) ?? null, customizer, stack)) {
      return false
    }
    keyResult = keysIter.next()
  }
  return true
}

function compareSets(
  value: Set<Object>,
  other: Set<Object>,
  customizer?: (v: Object, o: Object, key?: string, vMap?: Map<string, Object>, oMap?: Map<string, Object>) => boolean | undefined,
  stack?: Map<Object, Object>
): boolean {
  if (value.size !== other.size) {
    return false
  }
  const valuesIter: IterableIterator<Object> = value.values()
  let valResult: IteratorResult<Object> = valuesIter.next()
  while (!valResult.done) {
    const v: Object = valResult.value
    let found: boolean = false
    const otherIter: IterableIterator<Object> = other.values()
    let otherResult: IteratorResult<Object> = otherIter.next()
    while (!otherResult.done) {
      if (baseIsEqual(v, otherResult.value, customizer, stack)) {
        found = true
        break
      }
      otherResult = otherIter.next()
    }
    if (!found) {
      return false
    }
    valResult = valuesIter.next()
  }
  return true
}

// ---- Partial Match ----

export function isMatch(object: Map<string, Object>, source: Map<string, Object>): boolean {
  if (object.size === 0 && source.size === 0) {
    return true
  }
  const keysIter: IterableIterator<string> = source.keys()
  let keyResult: IteratorResult<string> = keysIter.next()
  while (!keyResult.done) {
    const key: string = keyResult.value
    const srcVal: Object | undefined = source.get(key)
    const objVal: Object | undefined = object.get(key)
    if (srcVal !== objVal && !baseIsEqual(objVal as Object, srcVal as Object)) {
      return false
    }
    keyResult = keysIter.next()
  }
  return true
}

export function isMatchWith(
  object: Map<string, Object>,
  source: Map<string, Object>,
  customizer: (objValue: Object, srcValue: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => boolean | undefined
): boolean {
  if (object.size === 0 && source.size === 0) {
    return true
  }
  const keysIter: IterableIterator<string> = source.keys()
  let keyResult: IteratorResult<string> = keysIter.next()
  while (!keyResult.done) {
    const key: string = keyResult.value
    const srcVal: Object | undefined = source.get(key)
    const objVal: Object | undefined = object.get(key)
    const customResult: boolean | undefined = customizer(
      objVal as Object, srcVal as Object, key, object, source
    )
    if (customResult !== undefined) {
      if (!customResult) {
        return false
      }
    } else if (!baseIsEqual(objVal as Object, srcVal as Object)) {
      return false
    }
    keyResult = keysIter.next()
  }
  return true
}

export function conformsTo(
  object: Map<string, Object>,
  source: Map<string, (value: Object) => boolean>
): boolean {
  const keysIter: IterableIterator<string> = source.keys()
  let keyResult: IteratorResult<string> = keysIter.next()
  while (!keyResult.done) {
    const key: string = keyResult.value
    const predicate: ((value: Object) => boolean) | undefined = source.get(key)
    if (predicate !== undefined && !predicate(object.get(key) as Object)) {
      return false
    }
    keyResult = keysIter.next()
  }
  return true
}
