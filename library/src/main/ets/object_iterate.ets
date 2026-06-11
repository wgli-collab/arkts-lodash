/**
 * ArkTS Lodash — Object Iteration & Introspection
 * Uses Map<K,V> and Object.entries() to avoid for...in (R16) and obj[key] (R5).
 */

export function keys(object: Map<string, Object> | Record<string, Object>): Array<string> {
  if (object instanceof Map) {
    const result: Array<string> = []
    const iter: IterableIterator<string> = object.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      result.push(next.value)
      next = iter.next()
    }
    return result
  }
  return Object.keys(object)
}

export function keysIn(object: Map<string, Object> | Record<string, Object>): Array<string> {
  // NOTE: ArkTS forbids for...in (R16), so inherited properties cannot be enumerated.
  // This function behaves identically to keys() — only own properties are returned.
  return keys(object)
}

export function values(object: Map<string, Object>): Array<Object> {
  const result: Array<Object> = []
  const iter: IterableIterator<Object> = object.values()
  let next: IteratorResult<Object> = iter.next()
  while (!next.done) {
    result.push(next.value)
    next = iter.next()
  }
  return result
}

export function valuesIn(object: Map<string, Object>): Array<Object> {
  // NOTE: ArkTS forbids for...in (R16), so inherited properties cannot be enumerated.
  // This function behaves identically to values() — only own properties are returned.
  return values(object)
}

export function forOwn(object: Map<string, Object>, iteratee: (value: Object, key: string) => void): Map<string, Object> {
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    iteratee(object.get(key) as Object, key)
    next = iter.next()
  }
  return object
}

export function forOwnRight(object: Map<string, Object>, iteratee: (value: Object, key: string) => void): Map<string, Object> {
  const allKeys: Array<string> = keys(object)
  for (let i: number = allKeys.length - 1; i >= 0; i--) {
    iteratee(object.get(allKeys[i]) as Object, allKeys[i])
  }
  return object
}

export function forIn(object: Map<string, Object>, iteratee: (value: Object, key: string) => void): Map<string, Object> {
  // NOTE: ArkTS forbids for...in (R16), so inherited properties cannot be enumerated.
  // This function behaves identically to forOwn() — only own properties are iterated.
  return forOwn(object, iteratee)
}

export function forInRight(object: Map<string, Object>, iteratee: (value: Object, key: string) => void): Map<string, Object> {
  // NOTE: ArkTS forbids for...in (R16), so inherited properties cannot be enumerated.
  // This function behaves identically to forOwnRight() — only own properties are iterated.
  return forOwnRight(object, iteratee)
}

export function findKey(object: Map<string, Object>, predicate: (value: Object, key: string) => boolean): string | undefined {
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    if (predicate(object.get(key) as Object, key)) {
      return key
    }
    next = iter.next()
  }
  return undefined
}

export function findLastKey(object: Map<string, Object>, predicate: (value: Object, key: string) => boolean): string | undefined {
  const allKeys: Array<string> = keys(object)
  for (let i: number = allKeys.length - 1; i >= 0; i--) {
    const key: string = allKeys[i]
    if (predicate(object.get(key) as Object, key)) {
      return key
    }
  }
  return undefined
}

export function functions(object: Map<string, Object>): Array<string> {
  const result: Array<string> = []
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    if (typeof object.get(key) === 'function') {
      result.push(key)
    }
    next = iter.next()
  }
  return result
}

export function functionsIn(object: Map<string, Object>): Array<string> {
  // NOTE: ArkTS forbids for...in (R16), so inherited properties cannot be enumerated.
  // This function behaves identically to functions() — only own properties are returned.
  return functions(object)
}
