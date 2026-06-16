/**
 * ArkTS Lodash — Function Composition & Predicate Utilities
 */

export function flow(...funcs: Array<(...args: Array<Object>) => Object>): (...args: Array<Object>) => Object {
  const composed: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    let result: Object = args.length === 1 ? args[0] : args
    for (let i: number = 0; i < funcs.length; i++) {
      result = funcs[i](result)
    }
    return result
  }
  return composed
}

export function flowRight(...funcs: Array<(...args: Array<Object>) => Object>): (...args: Array<Object>) => Object {
  const composed: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => {
    let result: Object = args.length === 1 ? args[0] : args
    for (let i: number = funcs.length - 1; i >= 0; i--) {
      result = funcs[i](result)
    }
    return result
  }
  return composed
}

export function over(...iteratees: Array<(...args: Array<Object>) => Object>): (...args: Array<Object>) => Array<Object> {
  const wrapper: (...args: Array<Object>) => Array<Object> = (...args: Array<Object>): Array<Object> => {
    const results: Array<Object> = []
    for (let i: number = 0; i < iteratees.length; i++) {
      results.push(iteratees[i](...args))
    }
    return results
  }
  return wrapper
}

export function overEvery(...predicates: Array<(...args: Array<Object>) => boolean>): (...args: Array<Object>) => boolean {
  const wrapper: (...args: Array<Object>) => boolean = (...args: Array<Object>): boolean => {
    for (let i: number = 0; i < predicates.length; i++) {
      if (!predicates[i](...args)) {
        return false
      }
    }
    return true
  }
  return wrapper
}

export function overSome(...predicates: Array<(...args: Array<Object>) => boolean>): (...args: Array<Object>) => boolean {
  const wrapper: (...args: Array<Object>) => boolean = (...args: Array<Object>): boolean => {
    for (let i: number = 0; i < predicates.length; i++) {
      if (predicates[i](...args)) {
        return true
      }
    }
    return false
  }
  return wrapper
}

export function cond(pairs: Array<[(...args: Array<Object>) => boolean, (...args: Array<Object>) => Object]>): (...args: Array<Object>) => Object | undefined {
  const wrapper: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    for (let i: number = 0; i < pairs.length; i++) {
      const pair: [(...args: Array<Object>) => boolean, (...args: Array<Object>) => Object] = pairs[i]
      if (pair[0](...args)) {
        return pair[1](...args)
      }
    }
    return undefined
  }
  return wrapper
}

export function conforms(source: Map<string, (v: Object) => boolean>): (object: Map<string, Object>) => boolean {
  const predicate: (object: Map<string, Object>) => boolean = (object: Map<string, Object>): boolean => {
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      const check: ((v: Object) => boolean) | undefined = source.get(key)
      if (check !== undefined && !check(object.get(key) as Object)) {
        return false
      }
      next = iter.next()
    }
    return true
  }
  return predicate
}

export function matches(source: Map<string, Object>): (object: Map<string, Object>) => boolean {
  const predicate: (object: Map<string, Object>) => boolean = (object: Map<string, Object>): boolean => {
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      if (object.get(key) !== source.get(key)) {
        return false
      }
      next = iter.next()
    }
    return true
  }
  return predicate
}

export function matchesProperty(path: string, srcValue: Object): (object: Object) => boolean {
  // ArkTS limitation: property path matching on arbitrary objects is not supported (R5, R9).
  throw new Error(
    'matchesProperty is not supported in ArkTS. ' +
    'Use explicit property access: (obj) => get(obj, path) === value'
  )
}

export function iteratee(value: Object): (...args: Array<Object>) => Object {
  if (typeof value === 'function') {
    return value as (...args: Array<Object>) => Object
  }
  if (typeof value === 'string') {
    const prop: string = value as string
    const getter: (obj: Object) => Object = (obj: Object): Object => {
      const record: Record<string, Object> = obj as Record<string, Object>
      const entries: Array<[string, Object]> = Object.entries(record)
      for (let i: number = 0; i < entries.length; i++) {
        if (entries[i][0] === prop) {
          return entries[i][1]
        }
      }
      return new Object()
    }
    return getter as Object as (...args: Array<Object>) => Object
  }
  // Default: identity
  const identityFn: (v: Object) => Object = (v: Object): Object => v
  return identityFn as (...args: Array<Object>) => Object
}
