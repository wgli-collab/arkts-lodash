/**
 * ArkTS Lodash — Type Conversion & Cloning
 * All dynamic key access uses Map<K,V> — no obj[key] per R5.
 */

// ---- Conversion Functions ----

export function castArray<T>(value: T | Array<T>): Array<T> {
  return Array.isArray(value) ? (value as Array<T>) : [value as T]
}

export function toArray<T>(value: Array<T> | Map<string, T> | Set<T> | string | null): Array<T> {
  if (value === null || value === undefined) {
    return []
  }
  if (Array.isArray(value)) {
    return value as Array<T>
  }
  if (typeof value === 'string') {
    const result: Array<T> = []
    const chars: Array<string> = (value as string).split('')
    for (let i: number = 0; i < chars.length; i++) {
      result.push(chars[i] as Object as T)
    }
    return result
  }
  if (value instanceof Set) {
    const result: Array<T> = []
    const iter: IterableIterator<T> = (value as Set<T>).values()
    let next: IteratorResult<T> = iter.next()
    while (!next.done) {
      result.push(next.value)
      next = iter.next()
    }
    return result
  }
  if (value instanceof Map) {
    const result: Array<T> = []
    const iter: IterableIterator<T> = (value as Map<string, T>).values()
    let next: IteratorResult<T> = iter.next()
    while (!next.done) {
      result.push(next.value)
      next = iter.next()
    }
    return result
  }
  return []
}

export function toFinite(value: number): number {
  if (value === Number.POSITIVE_INFINITY) {
    return Number.MAX_VALUE
  }
  if (value === Number.NEGATIVE_INFINITY) {
    return -Number.MAX_VALUE
  }
  if (value !== value) {
    return 0
  }
  return value
}

export function toInteger(value: number): number {
  const finite: number = toFinite(value)
  const remainder: number = finite % 1
  return remainder !== 0 ? finite - remainder : finite
}

export function toLength(value: number): number {
  if (value <= 0) {
    return 0
  }
  const intVal: number = toInteger(value)
  return intVal > 4294967295 ? 4294967295 : intVal
}

export function toNumber(value: number | string): number {
  if (typeof value === 'number') {
    return value
  }
  const num: number = parseFloat(value as string)
  return num !== num ? 0 : num
}

export function toPlainObject(value: Map<string, Object> | Record<string, Object>): Map<string, Object> {
  if (value instanceof Map) {
    const result: Map<string, Object> = new Map<string, Object>()
    const iter: IterableIterator<string> = value.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      result.set(key, value.get(key) as Object)
      next = iter.next()
    }
    return result
  }
  const result: Map<string, Object> = new Map<string, Object>()
  const entries: Array<[string, Object]> = Object.entries(value)
  for (let i: number = 0; i < entries.length; i++) {
    const entry: [string, Object] = entries[i]
    result.set(entry[0], entry[1])
  }
  return result
}

export function toSafeInteger(value: number): number {
  const intVal: number = toInteger(value)
  if (intVal > Number.MAX_SAFE_INTEGER) {
    return Number.MAX_SAFE_INTEGER
  }
  if (intVal < Number.MIN_SAFE_INTEGER) {
    return Number.MIN_SAFE_INTEGER
  }
  return intVal
}

export function toString(value: Object | null): string {
  if (value === null || value === undefined) {
    return ''
  }
  if (typeof value === 'string') {
    return value as string
  }
  if (Array.isArray(value)) {
    return (value as Array<Object>).join(',')
  }
  return String(value)
}

export function toPairs(object: Map<string, Object>): Array<[string, Object]> {
  const result: Array<[string, Object]> = []
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    result.push([key, object.get(key) as Object])
    next = iter.next()
  }
  return result
}

export function toPairsIn(object: Map<string, Object>): Array<[string, Object]> {
  return toPairs(object)
}

// ---- Clone Functions ----

export function clone<T>(value: T): T {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value
  }
  if (Array.isArray(value)) {
    const arr: Array<Object> = value as Object as Array<Object>
    const result: Array<Object> = []
    for (let i: number = 0; i < arr.length; i++) {
      result[i] = arr[i]
    }
    return result as Object as T
  }
  if (value instanceof Map) {
    const m: Map<Object, Object> = value as Object as Map<Object, Object>
    const result: Map<Object, Object> = new Map<Object, Object>()
    const iter: IterableIterator<Object> = m.keys()
    let next: IteratorResult<Object> = iter.next()
    while (!next.done) {
      const k: Object = next.value
      result.set(k, m.get(k) as Object)
      next = iter.next()
    }
    return result as Object as T
  }
  if (value instanceof Set) {
    const s: Set<Object> = value as Object as Set<Object>
    const result: Set<Object> = new Set<Object>()
    const iter: IterableIterator<Object> = s.values()
    let next: IteratorResult<Object> = iter.next()
    while (!next.done) {
      result.add(next.value)
      next = iter.next()
    }
    return result as Object as T
  }
  if (value instanceof Date) {
    return new Date((value as Date).getTime()) as Object as T
  }
  if (value instanceof RegExp) {
    return new RegExp((value as RegExp).source, (value as RegExp).flags) as Object as T
  }
  return value
}

export function cloneDeep<T>(value: T): T {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value
  }
  const stack: Map<Object, Object> = new Map<Object, Object>()
  return baseCloneDeep(value as Object, stack) as Object as T
}

export function cloneDeepWith<T>(
  value: T,
  customizer: (v: Object) => Object | undefined
): T {
  const customResult: Object | undefined = customizer(value as Object)
  if (customResult !== undefined) {
    return customResult as Object as T
  }
  return cloneDeep(value)
}

export function cloneWith<T>(
  value: T,
  customizer: (v: Object) => Object | undefined
): T {
  const customResult: Object | undefined = customizer(value as Object)
  if (customResult !== undefined) {
    return customResult as Object as T
  }
  return clone(value)
}

// ---- Internal Deep Clone ----

function baseCloneDeep(value: Object, stack: Map<Object, Object>): Object {
  if (stack.has(value)) {
    return stack.get(value) as Object
  }

  if (Array.isArray(value)) {
    const arr: Array<Object> = value as Array<Object>
    const result: Array<Object> = new Array<Object>(arr.length)
    stack.set(value, result)
    for (let i: number = 0; i < arr.length; i++) {
      const item: Object = arr[i]
      if (item !== null && typeof item === 'object') {
        result[i] = baseCloneDeep(item, stack)
      } else {
        result[i] = item
      }
    }
    return result
  }

  if (value instanceof Map) {
    const m: Map<Object, Object> = value as Map<Object, Object>
    const result: Map<Object, Object> = new Map<Object, Object>()
    stack.set(value, result)
    const mapIter: IterableIterator<Object> = m.keys()
    let mapNext: IteratorResult<Object> = mapIter.next()
    while (!mapNext.done) {
      const k: Object = mapNext.value
      const v: Object | undefined = m.get(k)
      if (v !== undefined && v !== null && typeof v === 'object') {
        result.set(k, baseCloneDeep(v, stack))
      } else if (v !== undefined) {
        result.set(k, v as Object)
      }
      mapNext = mapIter.next()
    }
    return result
  }

  if (value instanceof Set) {
    const s: Set<Object> = value as Set<Object>
    const result: Set<Object> = new Set<Object>()
    stack.set(value, result)
    const setIter: IterableIterator<Object> = s.values()
    let setNext: IteratorResult<Object> = setIter.next()
    while (!setNext.done) {
      const item: Object = setNext.value
      if (item !== null && typeof item === 'object') {
        result.add(baseCloneDeep(item, stack))
      } else {
        result.add(item)
      }
      setNext = setIter.next()
    }
    return result
  }

  if (value instanceof Date) {
    return new Date((value as Date).getTime())
  }

  if (value instanceof RegExp) {
    return new RegExp((value as RegExp).source, (value as RegExp).flags)
  }

  // Plain object — use Object.entries() to avoid obj[key] (R5)
  const result: Map<string, Object> = new Map<string, Object>()
  stack.set(value, result)
  const entries: Array<[string, Object]> = Object.entries(value as Record<string, Object>)
  for (let i: number = 0; i < entries.length; i++) {
    const entry: [string, Object] = entries[i]
    const key: string = entry[0]
    const val: Object = entry[1]
    if (val !== null && typeof val === 'object') {
      result.set(key, baseCloneDeep(val, stack))
    } else {
      result.set(key, val)
    }
  }
  return result
}
