/**
 * ArkTS Lodash — Core Collection Iteration
 * Uses Object.entries() to avoid obj[key] bracket notation (R5).
 * Uses for...of loops instead of for...in (R16).
 */

export function forEach<T>(collection: Array<T> | Map<string, T> | Record<string, T>, iteratee: (v: T, k: number | string) => void): Array<T> | Map<string, T> | Record<string, T> {
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      iteratee(arr[i], i)
    }
  } else if (collection instanceof Map) {
    const m: Map<string, T> = collection as Map<string, T>
    const iter: IterableIterator<string> = m.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      iteratee(m.get(key) as T, key)
      next = iter.next()
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      iteratee(entry[1], entry[0])
    }
  }
  return collection
}

export function forEachRight<T>(collection: Array<T> | Record<string, T>, iteratee: (v: T, k: number | string) => void): Array<T> | Record<string, T> {
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = arr.length - 1; i >= 0; i--) {
      iteratee(arr[i], i)
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = entries.length - 1; i >= 0; i--) {
      const entry: [string, T] = entries[i]
      iteratee(entry[1], entry[0])
    }
  }
  return collection
}

export function map<T, R>(collection: Array<T> | Map<string, T> | Record<string, T>, iteratee: (v: T, k: number | string) => R): Array<R> {
  const result: Array<R> = []
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      result.push(iteratee(arr[i], i))
    }
  } else if (collection instanceof Map) {
    const m: Map<string, T> = collection as Map<string, T>
    const iter: IterableIterator<string> = m.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      result.push(iteratee(m.get(key) as T, key))
      next = iter.next()
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      result.push(iteratee(entry[1], entry[0]))
    }
  }
  return result
}

export function filter<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean): Array<T> {
  const result: Array<T> = []
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      if (predicate(arr[i], i)) {
        result.push(arr[i])
      }
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      if (predicate(entry[1], entry[0])) {
        result.push(entry[1])
      }
    }
  }
  return result
}

export function reject<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean): Array<T> {
  return filter(collection, (v: T, k: number | string): boolean => !predicate(v, k))
}

export function every<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean): boolean {
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      if (!predicate(arr[i], i)) {
        return false
      }
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      if (!predicate(entry[1], entry[0])) {
        return false
      }
    }
  }
  return true
}

export function some<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean): boolean {
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      if (predicate(arr[i], i)) {
        return true
      }
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      if (predicate(entry[1], entry[0])) {
        return true
      }
    }
  }
  return false
}

export function reduce<T, R>(collection: Array<T> | Record<string, T>, iteratee: (acc: R, v: T, k: number | string) => R, accumulator: R): R {
  let result: R = accumulator
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = 0; i < arr.length; i++) {
      result = iteratee(result, arr[i], i)
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = 0; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      result = iteratee(result, entry[1], entry[0])
    }
  }
  return result
}

export function reduceRight<T, R>(collection: Array<T> | Record<string, T>, iteratee: (acc: R, v: T, k: number | string) => R, accumulator: R): R {
  let result: R = accumulator
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = arr.length - 1; i >= 0; i--) {
      result = iteratee(result, arr[i], i)
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = entries.length - 1; i >= 0; i--) {
      const entry: [string, T] = entries[i]
      result = iteratee(result, entry[1], entry[0])
    }
  }
  return result
}

export function find<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean, fromIndex?: number): T | undefined {
  const start: number = fromIndex !== undefined ? fromIndex : 0
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    for (let i: number = start; i < arr.length; i++) {
      if (predicate(arr[i], i)) {
        return arr[i]
      }
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    for (let i: number = start; i < entries.length; i++) {
      const entry: [string, T] = entries[i]
      if (predicate(entry[1], entry[0])) {
        return entry[1]
      }
    }
  }
  return undefined
}

export function findLast<T>(collection: Array<T> | Record<string, T>, predicate: (v: T, k: number | string) => boolean, fromIndex?: number): T | undefined {
  if (Array.isArray(collection)) {
    const arr: Array<T> = collection as Array<T>
    const start: number = fromIndex !== undefined ? fromIndex : arr.length - 1
    for (let i: number = start; i >= 0; i--) {
      if (predicate(arr[i], i)) {
        return arr[i]
      }
    }
  } else {
    const entries: Array<[string, T]> = Object.entries(collection)
    const start: number = fromIndex !== undefined ? fromIndex : entries.length - 1
    for (let i: number = start; i >= 0; i--) {
      const entry: [string, T] = entries[i]
      if (predicate(entry[1], entry[0])) {
        return entry[1]
      }
    }
  }
  return undefined
}

export function includes(collection: Array<Object> | Map<Object, Object> | Set<Object> | Record<string, Object> | string | null, value: Object, fromIndex?: number): boolean {
  if (typeof collection === 'string') {
    const idx: number = collection.indexOf(value as string, fromIndex)
    return idx >= 0
  }
  if (Array.isArray(collection)) {
    const idx: number = collection.indexOf(value, fromIndex)
    return idx >= 0
  }
  if (collection instanceof Map) {
    const iter: IterableIterator<Object> = collection.values()
    let next: IteratorResult<Object> = iter.next()
    while (!next.done) {
      if (next.value === value) { return true }
      next = iter.next()
    }
    return false
  }
  if (collection instanceof Set) {
    return collection.has(value)
  }
  return false
}

export function size(collection: Array<Object> | Map<Object, Object> | Set<Object> | Record<string, Object> | string | null): number {
  if (collection === null || collection === undefined) {
    return 0
  }
  if (typeof collection === 'string') {
    return (collection as string).length
  }
  if (Array.isArray(collection)) {
    return (collection as Array<Object>).length
  }
  if (collection instanceof Map) {
    return (collection as Map<Object, Object>).size
  }
  if (collection instanceof Set) {
    return (collection as Set<Object>).size
  }
  return Object.keys(collection).length
}
