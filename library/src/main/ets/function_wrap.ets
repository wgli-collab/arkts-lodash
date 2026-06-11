/**
 * ArkTS Lodash — Function Wrapping Utilities
 * All wrappers use arrow functions (no Function.bind/.call/.apply — R9).
 */

export function after(n: number, func: (...args: Array<Object>) => Object): (...args: Array<Object>) => Object | undefined {
  if (typeof func !== 'function') {
    throw new Error('Expected a function')
  }
  let count: number = n
  const wrapper: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    count--
    if (count < 1) {
      return func(...args)
    }
    return undefined
  }
  return wrapper
}

export function before(n: number, func: (...args: Array<Object>) => Object): (...args: Array<Object>) => Object | undefined {
  let count: number = n
  let result: Object | undefined
  const wrapper: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    if (count > 1) {
      count--
      result = func(...args)
    }
    return result
  }
  return wrapper
}

export function ary(func: (...args: Array<Object>) => Object, n: number): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    return func(...args.slice(0, n))
  }
  return wrapper
}

export function unary<T, R>(func: (arg: T, ...rest: Array<Object>) => R): (arg: T) => R {
  const wrapper: (arg: T) => R = (arg: T): R => {
    return func(arg)
  }
  return wrapper
}

export function negate(predicate: (...args: Array<Object>) => boolean): (...args: Array<Object>) => boolean {
  const wrapper: (...args: Array<Object>) => boolean = (...args: Array<Object>): boolean => {
    return !predicate(...args)
  }
  return wrapper
}

export function once(func: (...args: Array<Object>) => Object): (...args: Array<Object>) => Object | undefined {
  let called: boolean = false
  let result: Object | undefined
  const wrapper: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    if (!called) {
      called = true
      result = func(...args)
    }
    return result
  }
  return wrapper
}

export function memoize(func: (...args: Array<Object>) => Object, resolver?: (...args: Array<Object>) => string): (...args: Array<Object>) => Object {
  const cache: Map<string, Object> = new Map<string, Object>()
  const memoized: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    const key: string = resolver !== undefined ? resolver(...args) : args[0] as string
    if (cache.has(key)) {
      return cache.get(key) as Object
    }
    const result: Object = func(...args)
    cache.set(key, result)
    return result
  }
  return memoized
}

export function wrap(value: Object, wrapper: (v: Object, ...args: Array<Object>) => Object): (...args: Array<Object>) => Object {
  const wrapped: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    return wrapper(value, ...args)
  }
  return wrapped
}

export function spread(func: (args: Array<Object>) => Object, start?: number): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    const s: number = start !== undefined ? start : 0
    return func(args.slice(s))
  }
  return wrapper
}

export function flip(func: (...args: Array<Object>) => Object): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    return func(...args.reverse())
  }
  return wrapper
}
