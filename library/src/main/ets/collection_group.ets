/**
 * ArkTS Lodash — Collection Grouping, Sorting & Sampling
 */

export function countBy<T>(collection: Array<T>, iteratee: (v: T) => string): Map<string, number> {
  const result: Map<string, number> = new Map<string, number>()
  for (let i: number = 0; i < collection.length; i++) {
    const key: string = iteratee(collection[i])
    const count: number | undefined = result.get(key)
    result.set(key, count !== undefined ? count + 1 : 1)
  }
  return result
}

export function groupBy<T>(collection: Array<T>, iteratee: (v: T) => string): Map<string, Array<T>> {
  const result: Map<string, Array<T>> = new Map<string, Array<T>>()
  for (let i: number = 0; i < collection.length; i++) {
    const key: string = iteratee(collection[i])
    const group: Array<T> | undefined = result.get(key)
    if (group !== undefined) {
      group.push(collection[i])
    } else {
      result.set(key, [collection[i]])
    }
  }
  return result
}

export function keyBy<T>(collection: Array<T>, iteratee: (v: T) => string): Map<string, T> {
  const result: Map<string, T> = new Map<string, T>()
  for (let i: number = 0; i < collection.length; i++) {
    result.set(iteratee(collection[i]), collection[i])
  }
  return result
}

export function partition<T>(collection: Array<T>, predicate: (v: T) => boolean): [Array<T>, Array<T>] {
  const truthy: Array<T> = []
  const falsy: Array<T> = []
  for (let i: number = 0; i < collection.length; i++) {
    if (predicate(collection[i])) {
      truthy.push(collection[i])
    } else {
      falsy.push(collection[i])
    }
  }
  return [truthy, falsy]
}

export function sortBy<T>(collection: Array<T>, ...iteratees: Array<((v: T) => number) | ((v: T) => string)>): Array<T> {
  const sorted: Array<T> = collection.slice()
  sorted.sort((a: T, b: T): number => {
    for (let i: number = 0; i < iteratees.length; i++) {
      const fn: ((v: T) => number) | ((v: T) => string) = iteratees[i]
      const valA: number | string = fn(a)
      const valB: number | string = fn(b)
      if (valA < valB) {
        return -1
      }
      if (valA > valB) {
        return 1
      }
    }
    return 0
  })
  return sorted
}

export function orderBy<T>(collection: Array<T>, iteratees: Array<((v: T) => number) | ((v: T) => string)>, orders: Array<string>): Array<T> {
  const sorted: Array<T> = collection.slice()
  sorted.sort((a: T, b: T): number => {
    for (let i: number = 0; i < iteratees.length; i++) {
      const fn: ((v: T) => number) | ((v: T) => string) = iteratees[i]
      const order: string = i < orders.length ? orders[i] : 'asc'
      const valA: number | string = fn(a)
      const valB: number | string = fn(b)
      if (valA < valB) {
        return order === 'desc' ? 1 : -1
      }
      if (valA > valB) {
        return order === 'desc' ? -1 : 1
      }
    }
    return 0
  })
  return sorted
}

function baseFlatten<T>(array: Array<Object>): Array<T> {
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const val: Object = array[i]
    if (Array.isArray(val)) {
      const sub: Array<T> = baseFlatten<T>(val as Array<Object>)
      for (let j: number = 0; j < sub.length; j++) {
        result.push(sub[j])
      }
    } else {
      result.push(val as Object as T)
    }
  }
  return result
}

export function flatMap<T, R>(collection: Array<T>, iteratee: (v: T) => Array<R>): Array<R> {
  const mapped: Array<Array<R>> = []
  for (let i: number = 0; i < collection.length; i++) {
    mapped.push(iteratee(collection[i]))
  }
  const result: Array<R> = []
  for (let i: number = 0; i < mapped.length; i++) {
    for (let j: number = 0; j < mapped[i].length; j++) {
      result.push(mapped[i][j])
    }
  }
  return result
}

export function flatMapDeep<T, R>(collection: Array<T>, iteratee: (v: T) => Array<R>): Array<R> {
  const result: Array<R> = []
  for (let i: number = 0; i < collection.length; i++) {
    const val: Array<R> = iteratee(collection[i])
    const flattened: Array<R> = baseFlatten<R>(val as Object as Array<Object>)
    for (let j: number = 0; j < flattened.length; j++) {
      result.push(flattened[j])
    }
  }
  return result
}

export function flatMapDepth<T, R>(collection: Array<T>, iteratee: (v: T) => Array<R>, depth: number): Array<R> {
  const result: Array<R> = []
  for (let i: number = 0; i < collection.length; i++) {
    const val: Array<R> = iteratee(collection[i])
    result.push(...val)
  }
  return result
}

export function invokeMap(collection: Array<Object>, methodName: string, ...args: Array<Object>): Array<Object> {
  // ArkTS limitation: cannot dynamically dispatch methods by name (R5, R9).
  // Returns undefined for each element. Callers should use typed method calls instead.
  const result: Array<Object> = []
  for (let i: number = 0; i < collection.length; i++) {
    result.push(new Object())
  }
  return result
}

export function sample<T>(collection: Array<T>): T | undefined {
  if (collection.length === 0) {
    return undefined
  }
  const index: number = Math.floor(Math.random() * collection.length)
  return collection[index]
}

export function sampleSize<T>(collection: Array<T>, n: number): Array<T> {
  if (n <= 0 || collection.length === 0) {
    return []
  }
  const size: number = n > collection.length ? collection.length : n
  const indices: Array<number> = []
  for (let i: number = 0; i < collection.length; i++) {
    indices.push(i)
  }
  // Fisher-Yates shuffle on indices, take first `size`
  for (let i: number = indices.length - 1; i > 0; i--) {
    const j: number = Math.floor(Math.random() * (i + 1))
    const temp: number = indices[i]
    indices[i] = indices[j]
    indices[j] = temp
  }
  const result: Array<T> = []
  for (let i: number = 0; i < size; i++) {
    result.push(collection[indices[i]])
  }
  return result
}

export function shuffle<T>(collection: Array<T>): Array<T> {
  const result: Array<T> = collection.slice()
  for (let i: number = result.length - 1; i > 0; i--) {
    const j: number = Math.floor(Math.random() * (i + 1))
    const temp: T = result[i]
    result[i] = result[j]
    result[j] = temp
  }
  return result
}
