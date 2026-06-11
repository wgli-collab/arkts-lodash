/**
 * ArkTS Lodash — Array Search & Mutation Operations
 */

// ---- Find Index ----

export function findIndex<T>(array: Array<T>, predicate: (v: T, i: number) => boolean, fromIndex?: number): number {
  const start: number = fromIndex !== undefined ? (fromIndex < 0 ? Math.max(0, array.length + fromIndex) : fromIndex) : 0
  for (let i: number = start; i < array.length; i++) {
    if (predicate(array[i], i)) {
      return i
    }
  }
  return -1
}

export function findLastIndex<T>(array: Array<T>, predicate: (v: T, i: number) => boolean, fromIndex?: number): number {
  const start: number = fromIndex !== undefined ? (fromIndex < 0 ? Math.max(0, array.length + fromIndex) : fromIndex) : array.length - 1
  for (let i: number = start; i >= 0; i--) {
    if (predicate(array[i], i)) {
      return i
    }
  }
  return -1
}

export function indexOf<T>(array: Array<T>, value: T, fromIndex?: number): number {
  const start: number = fromIndex !== undefined ? fromIndex : 0
  for (let i: number = start; i < array.length; i++) {
    if (array[i] === value || (array[i] !== array[i] && value !== value)) {
      return i
    }
  }
  return -1
}

export function lastIndexOf<T>(array: Array<T>, value: T, fromIndex?: number): number {
  const start: number = fromIndex !== undefined ? fromIndex : array.length - 1
  for (let i: number = start; i >= 0; i--) {
    if (array[i] === value || (array[i] !== array[i] && value !== value)) {
      return i
    }
  }
  return -1
}

// ---- Pull (Mutates) ----

export function pull<T>(array: Array<T>, ...values: Array<T>): Array<T> {
  const exclude: Set<T> = new Set<T>()
  for (let i: number = 0; i < values.length; i++) {
    exclude.add(values[i])
  }
  let writeIndex: number = 0
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(array[i])) {
      array[writeIndex] = array[i]
      writeIndex++
    }
  }
  array.length = writeIndex
  return array
}

export function pullAll<T>(array: Array<T>, values: Array<T>): Array<T> {
  const exclude: Set<T> = new Set<T>()
  for (let i: number = 0; i < values.length; i++) {
    exclude.add(values[i])
  }
  let writeIndex: number = 0
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(array[i])) {
      array[writeIndex] = array[i]
      writeIndex++
    }
  }
  array.length = writeIndex
  return array
}

export function pullAllBy<T, K>(array: Array<T>, values: Array<T>, iteratee: (v: T) => K): Array<T> {
  const exclude: Set<K> = new Set<K>()
  for (let i: number = 0; i < values.length; i++) {
    exclude.add(iteratee(values[i]))
  }
  let writeIndex: number = 0
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(iteratee(array[i]))) {
      array[writeIndex] = array[i]
      writeIndex++
    }
  }
  array.length = writeIndex
  return array
}

export function pullAllWith<T>(array: Array<T>, values: Array<T>, comparator: (a: T, b: T) => boolean): Array<T> {
  let writeIndex: number = 0
  for (let i: number = 0; i < array.length; i++) {
    let shouldRemove: boolean = false
    for (let j: number = 0; j < values.length; j++) {
      if (comparator(array[i], values[j])) {
        shouldRemove = true
        break
      }
    }
    if (!shouldRemove) {
      array[writeIndex] = array[i]
      writeIndex++
    }
  }
  array.length = writeIndex
  return array
}

export function pullAt<T>(array: Array<T>, indexes: Array<number>): Array<T> {
  const removed: Array<T> = []
  const len: number = array.length
  // Resolve negative indexes once using original length
  const resolved: Array<number> = []
  for (let i: number = 0; i < indexes.length; i++) {
    const idx: number = indexes[i]
    const actual: number = idx < 0 ? len + idx : idx
    resolved.push(actual)
  }
  const sortedIndexes: Array<number> = resolved.slice().sort((a: number, b: number): number => a - b)
  for (let i: number = sortedIndexes.length - 1; i >= 0; i--) {
    const idx: number = sortedIndexes[i]
    if (idx >= 0 && idx < array.length) {
      removed.unshift(array[idx])
      array.splice(idx, 1)
    }
  }
  return removed
}

export function remove<T>(array: Array<T>, predicate: (v: T, i: number) => boolean): Array<T> {
  const removed: Array<T> = []
  let writeIndex: number = 0
  for (let i: number = 0; i < array.length; i++) {
    if (predicate(array[i], i)) {
      removed.push(array[i])
    } else {
      array[writeIndex] = array[i]
      writeIndex++
    }
  }
  array.length = writeIndex
  return removed
}

// ---- Sorted Index ----

export function sortedIndex<T>(array: Array<T>, value: T): number {
  let low: number = 0
  let high: number = array.length
  while (low < high) {
    const mid: number = (low + high) >>> 1
    if (array[mid] < value) {
      low = mid + 1
    } else {
      high = mid
    }
  }
  return low
}

export function sortedIndexBy<T, K>(array: Array<T>, value: T, iteratee: (v: T) => K): number {
  const valKey: K = iteratee(value)
  let low: number = 0
  let high: number = array.length
  while (low < high) {
    const mid: number = (low + high) >>> 1
    if (iteratee(array[mid]) < valKey) {
      low = mid + 1
    } else {
      high = mid
    }
  }
  return low
}

export function sortedIndexOf<T>(array: Array<T>, value: T): number {
  const idx: number = sortedIndex(array, value)
  return idx < array.length && (array[idx] === value || (array[idx] !== array[idx] && value !== value)) ? idx : -1
}

export function sortedLastIndex<T>(array: Array<T>, value: T): number {
  let low: number = 0
  let high: number = array.length
  while (low < high) {
    const mid: number = (low + high) >>> 1
    if (value < array[mid]) {
      high = mid
    } else {
      low = mid + 1
    }
  }
  return low
}

export function sortedLastIndexBy<T, K>(array: Array<T>, value: T, iteratee: (v: T) => K): number {
  const valKey: K = iteratee(value)
  let low: number = 0
  let high: number = array.length
  while (low < high) {
    const mid: number = (low + high) >>> 1
    if (valKey < iteratee(array[mid])) {
      high = mid
    } else {
      low = mid + 1
    }
  }
  return low
}

export function sortedLastIndexOf<T>(array: Array<T>, value: T): number {
  const idx: number = sortedLastIndex(array, value)
  return idx > 0 && (array[idx - 1] === value || (array[idx - 1] !== array[idx - 1] && value !== value)) ? idx - 1 : -1
}

export function sortedUniq<T>(array: Array<T>): Array<T> {
  if (array.length === 0) {
    return []
  }
  const result: Array<T> = [array[0]]
  for (let i: number = 1; i < array.length; i++) {
    const a = array[i]; const b = result[result.length - 1]
    if (!(a === b || (a !== a && b !== b))) {
      result.push(array[i])
    }
  }
  return result
}

export function sortedUniqBy<T, K>(array: Array<T>, iteratee: (v: T) => K): Array<T> {
  if (array.length === 0) {
    return []
  }
  const result: Array<T> = [array[0]]
  for (let i: number = 1; i < array.length; i++) {
    const a = iteratee(array[i]); const b = iteratee(result[result.length - 1])
    if (!(a === b || (a !== a && b !== b))) {
      result.push(array[i])
    }
  }
  return result
}
