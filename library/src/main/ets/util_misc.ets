/**
 * ArkTS Lodash — General Utilities
 */

export function attempt(func: (...args: Array<Object>) => Object, ...args: Array<Object>): Object | Error {
  try {
    return func(...args)
  } catch (e) {
    if (e instanceof Error) {
      return e
    }
    return new Error(String(e))
  }
}

export function constant<T>(value: T): () => T {
  const fn: () => T = (): T => {
    return value
  }
  return fn
}

export function defaultTo<T>(value: T | null | undefined, defaultValue: T): T {
  if (value === null || value === undefined || (typeof value === 'number' && value !== value)) {
    return defaultValue
  }
  return value
}

export function identity<T>(value: T): T {
  return value
}

export function noop(): void {
  // Intentionally empty
}

export function mixin(object: Map<string, Object>, source: Map<string, Object>): Map<string, Object> {
  const iter: IterableIterator<string> = source.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    object.set(key, source.get(key) as Object)
    next = iter.next()
  }
  return object
}

export function method(path: string, ...args: Array<Object>): (object: Map<string, Object>) => Object {
  const fn: (object: Map<string, Object>) => Object = (object: Map<string, Object>): Object => {
    const methodFn: Object | undefined = object.get(path)
    if (typeof methodFn === 'function') {
      return (methodFn as (...a: Array<Object>) => Object)(...args)
    }
    return new Object()
  }
  return fn
}

export function methodOf(object: Map<string, Object>): (path: string, ...args: Array<Object>) => Object {
  const fn: (path: string, ...args: Array<Object>) => Object = (path: string, ...args: Array<Object>): Object => {
    const methodFn: Object | undefined = object.get(path)
    if (typeof methodFn === 'function') {
      return (methodFn as (...a: Array<Object>) => Object)(...args)
    }
    return new Object()
  }
  return fn
}

export function nthArg(n: number): (...args: Array<Object>) => Object | undefined {
  const fn: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    const index: number = n < 0 ? args.length + n : n
    return index >= 0 && index < args.length ? args[index] : undefined
  }
  return fn
}

export function property(path: string): (object: Map<string, Object>) => Object | undefined {
  const fn: (object: Map<string, Object>) => Object | undefined = (object: Map<string, Object>): Object | undefined => {
    return object.get(path)
  }
  return fn
}

export function propertyOf(object: Map<string, Object>): (path: string) => Object | undefined {
  const fn: (path: string) => Object | undefined = (path: string): Object | undefined => {
    return object.get(path)
  }
  return fn
}

export function range(start: number, end?: number, step?: number): Array<number> {
  let s: number = start
  let e: number = end !== undefined ? end : start
  let st: number = step !== undefined ? step : 1
  if (end === undefined) {
    s = 0
  }
  if (st === 0) {
    return []
  }
  const result: Array<number> = []
  if (st > 0) {
    for (let i: number = s; i < e; i += st) {
      result.push(i)
    }
  } else {
    for (let i: number = s; i > e; i += st) {
      result.push(i)
    }
  }
  return result
}

export function rangeRight(start: number, end?: number, step?: number): Array<number> {
  return range(start, end, step).reverse()
}

export function times<T>(n: number, iteratee: (index: number) => T): Array<T> {
  const result: Array<T> = []
  for (let i: number = 0; i < n; i++) {
    result.push(iteratee(i))
  }
  return result
}

let idCounter: number = 0

export function uniqueId(prefix?: string): string {
  const id: number = ++idCounter
  const prefixStr: string = prefix !== undefined ? prefix : ''
  return prefixStr + id.toString()
}

export function toPath(value: string): Array<string> {
  const reProp: RegExp = /[^.[\]]+|\[(?:(-?\d+)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g
  const result: Array<string> = []
  let match: Array<string> | null = reProp.exec(value)
  while (match !== null) {
    const key: string = match[3] ?? match[1] ?? match[0]
    result.push(key.replace(/\\(.)/g, '$1'))
    match = reProp.exec(value)
  }
  return result
}
