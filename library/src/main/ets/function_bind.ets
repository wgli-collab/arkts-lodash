/**
 * ArkTS Lodash — Function Binding & Currying
 * Uses arrow function wrappers (no Function.bind/.call/.apply — R9).
 */

export function bind(func: (...args: Array<Object>) => Object, ...partials: Array<Object>): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    const allArgs: Array<Object> = []
    let argIdx: number = 0
    for (let i: number = 0; i < partials.length; i++) {
      allArgs.push(partials[i])
    }
    for (let i: number = 0; i < args.length; i++) {
      allArgs.push(args[i])
    }
    return func(...allArgs)
  }
  return wrapper
}

export function bindKey(object: Object, key: string, ...partials: Array<Object>): (...args: Array<Object>) => Object {
  // ArkTS limitation: cannot dynamically access method by string key (R5).
  throw new Error(
    'bindKey is not supported in ArkTS. ' +
    'Use arrow function: (x) => obj.method(x)'
  )
}

export function bindAll(object: Object, methodNames: Array<string>): Object {
  // ArkTS limitation: cannot dynamically bind methods (R5, R9).
  throw new Error(
    'bindAll is not supported in ArkTS. ' +
    'Use explicit arrow wrappers: obj.method = (x) => this.originalMethod(x)'
  )
}

export function curry(func: (...args: Array<Object>) => Object, arity?: number): Object {
  const fnArity: number = arity !== undefined ? arity : func.length
  const curried: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    if (args.length >= fnArity) {
      return func(...args)
    }
    const partial: (...more: Array<Object>) => Object = (...more: Array<Object>): Object => {
      return curried(...args, ...more)
    }
    return partial
  }
  return curried
}

export function curryRight(func: (...args: Array<Object>) => Object, arity?: number): Object {
  const fnArity: number = arity !== undefined ? arity : func.length
  const curried: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    if (args.length >= fnArity) {
      return func(...args)
    }
    const partial: (...more: Array<Object>) => Object = (...more: Array<Object>): Object => {
      return curried(...more, ...args)
    }
    return partial
  }
  return curried
}

export function partial(func: (...args: Array<Object>) => Object, ...partials: Array<Object>): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    return func(...partials, ...args)
  }
  return wrapper
}

export function partialRight(func: (...args: Array<Object>) => Object, ...partials: Array<Object>): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    return func(...args, ...partials)
  }
  return wrapper
}

export function rearg(func: (...args: Array<Object>) => Object, ...indexes: Array<number>): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    const reordered: Array<Object> = new Array<Object>(args.length)
    for (let i: number = 0; i < indexes.length; i++) {
      reordered[indexes[i]] = args[i]
    }
    return func(...reordered)
  }
  return wrapper
}

export function overArgs(func: (...args: Array<Object>) => Object, ...transforms: Array<(arg: Object) => Object>): (...args: Array<Object>) => Object {
  const wrapper: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    const transformed: Array<Object> = []
    for (let i: number = 0; i < args.length; i++) {
      transformed.push(i < transforms.length ? transforms[i](args[i]) : args[i])
    }
    return func(...transformed)
  }
  return wrapper
}
