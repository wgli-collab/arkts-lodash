/**
 * ArkTS Lodash — Array Set Operations
 * Uses Map<K,V> and Set<T> for deduplication (no obj[key] — R5 compliant).
 */

// ---- Difference ----

export function difference<T>(array: Array<T>, ...values: Array<Array<T>>): Array<T> {
  const exclude: Set<T> = new Set<T>()
  for (let i: number = 0; i < values.length; i++) {
    const arr: Array<T> = values[i]
    for (let j: number = 0; j < arr.length; j++) {
      exclude.add(arr[j])
    }
  }
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(array[i])) {
      result.push(array[i])
    }
  }
  return result
}

export function differenceBy<T, K>(array: Array<T>, ...args: Array<Array<T> | ((v: T) => K)>): Array<T> {
  const iteratee: (v: T) => K = args[args.length - 1] as (v: T) => K
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const exclude: Set<K> = new Set<K>()
  for (let i: number = 0; i < arrs.length; i++) {
    const arr: Array<T> = arrs[i]
    for (let j: number = 0; j < arr.length; j++) {
      exclude.add(iteratee(arr[j]))
    }
  }
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(iteratee(array[i]))) {
      result.push(array[i])
    }
  }
  return result
}

export function differenceWith<T>(array: Array<T>, ...args: Array<Array<T> | ((a: T, b: T) => boolean)>): Array<T> {
  const comparator: (a: T, b: T) => boolean = args[args.length - 1] as (a: T, b: T) => boolean
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    let found: boolean = false
    for (let a: number = 0; a < arrs.length && !found; a++) {
      const arr: Array<T> = arrs[a]
      for (let j: number = 0; j < arr.length; j++) {
        if (comparator(array[i], arr[j])) {
          found = true
          break
        }
      }
    }
    if (!found) {
      result.push(array[i])
    }
  }
  return result
}

// ---- Intersection ----

export function intersection<T>(...arrays: Array<Array<T>>): Array<T> {
  if (arrays.length === 0) {
    return []
  }
  const first: Array<T> = arrays[0]
  const result: Array<T> = []
  for (let i: number = 0; i < first.length; i++) {
    const val: T = first[i]
    let inAll: boolean = true
    for (let j: number = 1; j < arrays.length; j++) {
      if (arrays[j].indexOf(val) < 0) {
        inAll = false
        break
      }
    }
    if (inAll) {
      result.push(val)
    }
  }
  return result
}

export function intersectionBy<T, K>(...args: Array<Array<T> | ((v: T) => K)>): Array<T> {
  if (args.length === 0) {
    return []
  }
  const iteratee: (v: T) => K = args[args.length - 1] as (v: T) => K
  const arrays: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  if (arrays.length === 0) {
    return []
  }
  const first: Array<T> = arrays[0]
  // Build a Set<K> per subsequent array for O(1) membership checks
  const sets: Array<Set<K>> = []
  for (let j: number = 1; j < arrays.length; j++) {
    const s: Set<K> = new Set<K>()
    for (let k: number = 0; k < arrays[j].length; k++) {
      s.add(iteratee(arrays[j][k]))
    }
    sets.push(s)
  }
  const seen: Set<K> = new Set<K>()
  const result: Array<T> = []
  for (let i: number = 0; i < first.length; i++) {
    const val: T = first[i]
    const key: K = iteratee(val)
    if (seen.has(key)) {
      continue
    }
    seen.add(key)
    let inAll: boolean = true
    for (let j: number = 0; j < sets.length; j++) {
      if (!sets[j].has(key)) {
        inAll = false
        break
      }
    }
    if (inAll) {
      result.push(val)
    }
  }
  return result
}

export function intersectionWith<T>(...args: Array<Array<T> | ((a: T, b: T) => boolean)>): Array<T> {
  if (args.length <= 1) {
    return args.length === 0 ? [] : (args[0] as Array<T>).slice()
  }
  const comparator: (a: T, b: T) => boolean = args[args.length - 1] as (a: T, b: T) => boolean
  const arrays: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const first: Array<T> = arrays[0]
  const result: Array<T> = []
  for (let i: number = 0; i < first.length; i++) {
    const val: T = first[i]
    // deduplicate result by comparator
    let already: boolean = false
    for (let r: number = 0; r < result.length; r++) {
      if (comparator(val, result[r])) {
        already = true
        break
      }
    }
    if (already) {
      continue
    }
    let inAll: boolean = true
    for (let j: number = 1; j < arrays.length; j++) {
      let found: boolean = false
      for (let k: number = 0; k < arrays[j].length; k++) {
        if (comparator(val, arrays[j][k])) {
          found = true
          break
        }
      }
      if (!found) {
        inAll = false
        break
      }
    }
    if (inAll) {
      result.push(val)
    }
  }
  return result
}

// ---- Union ----

export function union<T>(...arrays: Array<Array<T>>): Array<T> {
  const seen: Set<T> = new Set<T>()
  const result: Array<T> = []
  for (let i: number = 0; i < arrays.length; i++) {
    const arr: Array<T> = arrays[i]
    for (let j: number = 0; j < arr.length; j++) {
      const val: T = arr[j]
      if (!seen.has(val)) {
        seen.add(val)
        result.push(val)
      }
    }
  }
  return result
}

export function unionBy<T, K>(array: Array<T>, ...args: Array<Array<T> | ((v: T) => K)>): Array<T> {
  const iteratee: (v: T) => K = args[args.length - 1] as (v: T) => K
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const seen: Set<K> = new Set<K>()
  const result: Array<T> = []
  const all: Array<Array<T>> = [array].concat(arrs)
  for (let i: number = 0; i < all.length; i++) {
    const arr: Array<T> = all[i]
    for (let j: number = 0; j < arr.length; j++) {
      const val: T = arr[j]
      const key: K = iteratee(val)
      if (!seen.has(key)) {
        seen.add(key)
        result.push(val)
      }
    }
  }
  return result
}

export function unionWith<T>(array: Array<T>, ...args: Array<Array<T> | ((a: T, b: T) => boolean)>): Array<T> {
  const comparator: (a: T, b: T) => boolean = args[args.length - 1] as (a: T, b: T) => boolean
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const result: Array<T> = array.slice()
  const all: Array<Array<T>> = arrs
  for (let i: number = 0; i < all.length; i++) {
    const arr: Array<T> = all[i]
    for (let j: number = 0; j < arr.length; j++) {
      const val: T = arr[j]
      let found: boolean = false
      for (let k: number = 0; k < result.length; k++) {
        if (comparator(val, result[k])) {
          found = true
          break
        }
      }
      if (!found) {
        result.push(val)
      }
    }
  }
  return result
}

// ---- Uniq ----

export function uniq<T>(array: Array<T>): Array<T> {
  const seen: Set<T> = new Set<T>()
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const val: T = array[i]
    if (!seen.has(val)) {
      seen.add(val)
      result.push(val)
    }
  }
  return result
}

export function uniqBy<T, K>(array: Array<T>, iteratee: (v: T) => K): Array<T> {
  const seen: Set<K> = new Set<K>()
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const val: T = array[i]
    const key: K = iteratee(val)
    if (!seen.has(key)) {
      seen.add(key)
      result.push(val)
    }
  }
  return result
}

export function uniqWith<T>(array: Array<T>, comparator: (a: T, b: T) => boolean): Array<T> {
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const val: T = array[i]
    let found: boolean = false
    for (let j: number = 0; j < result.length; j++) {
      if (comparator(val, result[j])) {
        found = true
        break
      }
    }
    if (!found) {
      result.push(val)
    }
  }
  return result
}

export function without<T>(array: Array<T>, ...values: Array<T>): Array<T> {
  const exclude: Set<T> = new Set<T>()
  for (let i: number = 0; i < values.length; i++) {
    exclude.add(values[i])
  }
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    if (!exclude.has(array[i])) {
      result.push(array[i])
    }
  }
  return result
}

// ---- XOR (Symmetric Difference) ----

export function xor<T>(...arrays: Array<Array<T>>): Array<T> {
  const counts: Map<T, number> = new Map<T, number>()
  for (let i: number = 0; i < arrays.length; i++) {
    const seen: Set<T> = new Set<T>()
    for (let j: number = 0; j < arrays[i].length; j++) {
      const val: T = arrays[i][j]
      if (!seen.has(val)) {
        seen.add(val)
        const count: number | undefined = counts.get(val)
        counts.set(val, count !== undefined ? count + 1 : 1)
      }
    }
  }
  const result: Array<T> = []
  const iter: IterableIterator<T> = counts.keys()
  let next: IteratorResult<T> = iter.next()
  while (!next.done) {
    const key: T = next.value
    if (counts.get(key) === 1) {
      result.push(key)
    }
    next = iter.next()
  }
  return result
}

export function xorBy<T, K>(array: Array<T>, ...args: Array<Array<T> | ((v: T) => K)>): Array<T> {
  const iteratee: (v: T) => K = args[args.length - 1] as (v: T) => K
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const all: Array<Array<T>> = [array].concat(arrs)
  const counts: Map<K, number> = new Map<K, number>()
  const vals: Map<K, T> = new Map<K, T>()
  for (let i: number = 0; i < all.length; i++) {
    const seen: Set<K> = new Set<K>()
    for (let j: number = 0; j < all[i].length; j++) {
      const val: T = all[i][j]
      const key: K = iteratee(val)
      if (!seen.has(key)) {
        seen.add(key)
        const count: number | undefined = counts.get(key)
        counts.set(key, count !== undefined ? count + 1 : 1)
        vals.set(key, val)
      }
    }
  }
  const result: Array<T> = []
  const iter: IterableIterator<K> = counts.keys()
  let next: IteratorResult<K> = iter.next()
  while (!next.done) {
    const key: K = next.value
    if (counts.get(key) === 1) {
      result.push(vals.get(key) as T)
    }
    next = iter.next()
  }
  return result
}

export function xorWith<T>(array: Array<T>, ...args: Array<Array<T> | ((a: T, b: T) => boolean)>): Array<T> {
  const comparator: (a: T, b: T) => boolean = args[args.length - 1] as (a: T, b: T) => boolean
  const arrs: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  const all: Array<Array<T>> = [array].concat(arrs)
  const result: Array<T> = []
  for (let i: number = 0; i < all.length; i++) {
    for (let j: number = 0; j < all[i].length; j++) {
      const val: T = all[i][j]
      let count: number = 0
      for (let a: number = 0; a < all.length; a++) {
        for (let b: number = 0; b < all[a].length; b++) {
          if (comparator(val, all[a][b])) {
            count++
            if (count > 1) {
              break
            }
          }
        }
        if (count > 1) {
          break
        }
      }
      if (count === 1) {
        let already: boolean = false
        for (let k: number = 0; k < result.length; k++) {
          if (comparator(val, result[k])) {
            already = true
            break
          }
        }
        if (!already) {
          result.push(val)
        }
      }
    }
  }
  return result
}

// ---- Zip ----

export function zip<T>(...arrays: Array<Array<T>>): Array<Array<T>> {
  if (arrays.length === 0) {
    return []
  }
  let maxLen: number = 0
  for (let i: number = 0; i < arrays.length; i++) {
    if (arrays[i].length > maxLen) {
      maxLen = arrays[i].length
    }
  }
  const result: Array<Array<T>> = []
  for (let i: number = 0; i < maxLen; i++) {
    const group: Array<T> = []
    for (let j: number = 0; j < arrays.length; j++) {
      group.push(arrays[j][i])
    }
    result.push(group)
  }
  return result
}

export function zipObject<T>(props: Array<string>, values: Array<T>): Map<string, T> {
  const result: Map<string, T> = new Map<string, T>()
  const len: number = props.length < values.length ? props.length : values.length
  for (let i: number = 0; i < len; i++) {
    result.set(props[i], values[i])
  }
  return result
}

// Known limitation: zipObjectDeep does not support deep property paths (e.g. 'a.b[0].c').
// ArkTS restricts dynamic property access (no obj[key]) and recursive property setting,
// making deep-path resolution impractical. This implementation behaves identically to zipObject.
export function zipObjectDeep<T>(props: Array<string>, values: Array<T>): Map<string, T> {
  const result: Map<string, T> = new Map<string, T>()
  const len: number = props.length < values.length ? props.length : values.length
  for (let i: number = 0; i < len; i++) {
    result.set(props[i], values[i])
  }
  return result
}

export function zipWith<T, R>(...args: Array<Array<T> | ((...values: Array<T>) => R)>): Array<R> {
  const iteratee: (...values: Array<T>) => R = args[args.length - 1] as (...values: Array<T>) => R
  const arrays: Array<Array<T>> = args.slice(0, args.length - 1) as Array<Array<T>>
  if (arrays.length === 0) {
    return []
  }
  let minLen: number = arrays[0].length
  for (let i: number = 1; i < arrays.length; i++) {
    if (arrays[i].length < minLen) {
      minLen = arrays[i].length
    }
  }
  const result: Array<R> = []
  for (let i: number = 0; i < minLen; i++) {
    const group: Array<T> = []
    for (let j: number = 0; j < arrays.length; j++) {
      group.push(arrays[j][i])
    }
    result.push(iteratee(...group))
  }
  return result
}

export function unzip<T>(array: Array<Array<T>>): Array<Array<T>> {
  if (array.length === 0) {
    return []
  }
  let maxLen: number = 0
  for (let i: number = 0; i < array.length; i++) {
    if (array[i].length > maxLen) {
      maxLen = array[i].length
    }
  }
  const result: Array<Array<T>> = []
  for (let i: number = 0; i < maxLen; i++) {
    const group: Array<T> = []
    for (let j: number = 0; j < array.length; j++) {
      group.push(array[j][i])
    }
    result.push(group)
  }
  return result
}

export function unzipWith<T, R>(array: Array<Array<T>>, iteratee: (...values: Array<T>) => R): Array<R> {
  const unzipped: Array<Array<T>> = unzip(array)
  const result: Array<R> = []
  for (let i: number = 0; i < unzipped.length; i++) {
    result.push(iteratee(...unzipped[i]))
  }
  return result
}
