/**
 * ArkTS Lodash — Object Transformation
 * Uses Map<K,V> for all key-value access (no obj[key] — R5).
 */

export function assign(target: Map<string, Object>, ...sources: Array<Map<string, Object>>): Map<string, Object> {
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      target.set(key, source.get(key) as Object)
      next = iter.next()
    }
  }
  return target
}

export function assignIn(target: Map<string, Object>, ...sources: Array<Map<string, Object>>): Map<string, Object> {
  return assign(target, ...sources)
}

export function assignWith(target: Map<string, Object>, ...args: Array<Map<string, Object> | ((objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object)>): Map<string, Object> {
  const customizer: (objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object =
    args[args.length - 1] as (objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object
  const sources: Array<Map<string, Object>> = args.slice(0, args.length - 1) as Array<Map<string, Object>>
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      const srcVal: Object = source.get(key) as Object
      const objVal: Object | undefined = target.get(key)
      target.set(key, customizer(objVal as Object, srcVal, key, target, source))
      next = iter.next()
    }
  }
  return target
}

export function assignInWith(target: Map<string, Object>, ...args: Array<Map<string, Object> | ((objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object)>): Map<string, Object> {
  return assignWith(target, ...args)
}

export function merge(target: Map<string, Object>, ...sources: Array<Map<string, Object>>): Map<string, Object> {
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      const srcVal: Object = source.get(key) as Object
      const objVal: Object | undefined = target.get(key)
      if (srcVal instanceof Map && objVal instanceof Map) {
        merge(objVal, srcVal)
      } else {
        target.set(key, srcVal)
      }
      next = iter.next()
    }
  }
  return target
}

export function mergeWith(target: Map<string, Object>, ...args: Array<Map<string, Object> | ((objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object)>): Map<string, Object> {
  const customizer: (objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object =
    args[args.length - 1] as (objVal: Object, srcVal: Object, key: string, obj: Map<string, Object>, src: Map<string, Object>) => Object
  const sources: Array<Map<string, Object>> = args.slice(0, args.length - 1) as Array<Map<string, Object>>
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      const srcVal: Object = source.get(key) as Object
      const objVal: Object | undefined = target.get(key)
      const result: Object = customizer(objVal as Object, srcVal, key, target, source)
      if (result instanceof Map && objVal instanceof Map) {
        merge(objVal, result)
      } else {
        target.set(key, result)
      }
      next = iter.next()
    }
  }
  return target
}

export function defaults(target: Map<string, Object>, ...sources: Array<Map<string, Object>>): Map<string, Object> {
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      if (target.get(key) === undefined) {
        target.set(key, source.get(key) as Object)
      }
      next = iter.next()
    }
  }
  return target
}

export function defaultsDeep(target: Map<string, Object>, ...sources: Array<Map<string, Object>>): Map<string, Object> {
  for (let i: number = 0; i < sources.length; i++) {
    const source: Map<string, Object> = sources[i]
    const iter: IterableIterator<string> = source.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      const srcVal: Object = source.get(key) as Object
      const objVal: Object | undefined = target.get(key)
      if (objVal === undefined) {
        target.set(key, srcVal)
      } else if (srcVal instanceof Map && objVal instanceof Map) {
        defaultsDeep(objVal, srcVal)
      }
      next = iter.next()
    }
  }
  return target
}

export function create(prototype: Map<string, Object> | null, properties?: Map<string, Object>): Map<string, Object> {
  // ArkTS: no prototypal inheritance. Returns a new Map with properties.
  if (properties !== undefined) {
    const result: Map<string, Object> = new Map<string, Object>()
    const iter: IterableIterator<string> = properties.keys()
    let next: IteratorResult<string> = iter.next()
    while (!next.done) {
      const key: string = next.value
      result.set(key, properties.get(key) as Object)
      next = iter.next()
    }
    return result
  }
  return new Map<string, Object>()
}

export function omit(object: Map<string, Object>, ...paths: Array<string>): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  const exclude: Set<string> = new Set<string>()
  for (let i: number = 0; i < paths.length; i++) {
    exclude.add(paths[i])
  }
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    if (!exclude.has(key)) {
      result.set(key, object.get(key) as Object)
    }
    next = iter.next()
  }
  return result
}

export function omitBy(object: Map<string, Object>, predicate: (value: Object, key: string) => boolean): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    if (!predicate(object.get(key) as Object, key)) {
      result.set(key, object.get(key) as Object)
    }
    next = iter.next()
  }
  return result
}

export function pick(object: Map<string, Object>, ...paths: Array<string>): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  for (let i: number = 0; i < paths.length; i++) {
    const val: Object | undefined = object.get(paths[i])
    if (val !== undefined) {
      result.set(paths[i], val)
    }
  }
  return result
}

export function pickBy(object: Map<string, Object>, predicate: (value: Object, key: string) => boolean): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    const val: Object = object.get(key) as Object
    if (predicate(val, key)) {
      result.set(key, val)
    }
    next = iter.next()
  }
  return result
}

export function mapKeys(object: Map<string, Object>, iteratee: (value: Object, key: string) => string): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    const val: Object = object.get(key) as Object
    result.set(iteratee(val, key), val)
    next = iter.next()
  }
  return result
}

export function mapValues(object: Map<string, Object>, iteratee: (value: Object, key: string) => Object): Map<string, Object> {
  const result: Map<string, Object> = new Map<string, Object>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    result.set(key, iteratee(object.get(key) as Object, key))
    next = iter.next()
  }
  return result
}

export function invert(object: Map<string, string>): Map<string, string> {
  const result: Map<string, string> = new Map<string, string>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    result.set(object.get(key) as string, key)
    next = iter.next()
  }
  return result
}

export function invertBy(object: Map<string, Object>, iteratee: (value: Object) => string): Map<string, Array<string>> {
  const result: Map<string, Array<string>> = new Map<string, Array<string>>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    const newKey: string = iteratee(object.get(key) as Object)
    const group: Array<string> | undefined = result.get(newKey)
    if (group !== undefined) {
      group.push(key)
    } else {
      result.set(newKey, [key])
    }
    next = iter.next()
  }
  return result
}

export function transform(object: Map<string, Object>, iteratee: (result: Map<string, Object>, value: Object, key: string, obj: Map<string, Object>) => void, accumulator?: Map<string, Object>): Map<string, Object> {
  const acc: Map<string, Object> = accumulator !== undefined ? accumulator : new Map<string, Object>()
  const iter: IterableIterator<string> = object.keys()
  let next: IteratorResult<string> = iter.next()
  while (!next.done) {
    const key: string = next.value
    iteratee(acc, object.get(key) as Object, key, object)
    next = iter.next()
  }
  return acc
}
