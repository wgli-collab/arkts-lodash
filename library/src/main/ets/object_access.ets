/**
 * ArkTS Lodash — Object Property Access
 * Uses Map<K,V> for dynamic path access (no obj[key] — R5).
 */

function castPathArray(path: string | Array<number>): Array<string> {
  if (Array.isArray(path)) {
    const result: Array<string> = []
    for (let i: number = 0; i < path.length; i++) {
      result.push(path[i].toString())
    }
    return result
  }
  const reProp: RegExp = /[^.[\]]+|\[(?:(-?\d+)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g
  const result: Array<string> = []
  let match: Array<string> | null = reProp.exec(path)
  while (match !== null) {
    const key: string = match[3] ?? match[1] ?? match[0]
    result.push(key)
    match = reProp.exec(path)
  }
  return result
}

export function get(object: Map<string, Object> | null, path: string | Array<number>, defaultValue?: Object): Object | undefined {
  if (object === null || object === undefined) {
    return defaultValue
  }
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> | Object = object
  for (let i: number = 0; i < keys.length; i++) {
    if (current instanceof Map) {
      const val: Object | undefined = (current as Map<string, Object>).get(keys[i])
      if (val === undefined) {
        return defaultValue
      }
      current = val
    } else {
      return undefined
    }
  }
  return current as Object
}

export function set(object: Map<string, Object>, path: string | Array<number>, value: Object): Map<string, Object> {
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> = object
  for (let i: number = 0; i < keys.length - 1; i++) {
    const key: string = keys[i]
    let next: Map<string, Object> | undefined = current.get(key) as Map<string, Object> | undefined
    if (next === undefined || !(next instanceof Map)) {
      next = new Map<string, Object>()
      current.set(key, next)
    }
    current = next
  }
  const lastKey: string = keys[keys.length - 1]
  current.set(lastKey, value)
  return object
}

export function setWith(object: Map<string, Object>, path: string | Array<number>, value: Object, customizer: (nsValue: Object, key: string, nsObject: Map<string, Object>) => Object): Map<string, Object> {
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> = object
  for (let i: number = 0; i < keys.length - 1; i++) {
    const key: string = keys[i]
    let next: Map<string, Object> | undefined = current.get(key) as Map<string, Object> | undefined
    const customVal: Object = customizer(next as Object, key, current)
    if (customVal instanceof Map) {
      next = customVal
    } else if (next === undefined || !(next instanceof Map)) {
      next = new Map<string, Object>()
    }
    current.set(key, next)
    current = next
  }
  const lastKey: string = keys[keys.length - 1]
  current.set(lastKey, value)
  return object
}

export function has(object: Map<string, Object> | null, path: string | Array<number>): boolean {
  if (object === null || object === undefined) {
    return false
  }
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> | Object = object
  for (let i: number = 0; i < keys.length; i++) {
    if (current instanceof Map) {
      const mapCurrent: Map<string, Object> = current as Map<string, Object>
      if (!mapCurrent.has(keys[i])) {
        return false
      }
      current = mapCurrent.get(keys[i]) as Object
    } else {
      return false
    }
  }
  return true
}

export function hasIn(object: Map<string, Object> | null, path: string | Array<number>): boolean {
  return has(object, path)
}

export function unset(object: Map<string, Object>, path: string | Array<number>): boolean {
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> = object
  for (let i: number = 0; i < keys.length - 1; i++) {
    const val: Object | undefined = current.get(keys[i])
    if (val === undefined || !(val instanceof Map)) {
      return false
    }
    current = val as Map<string, Object>
  }
  const lastKey: string = keys[keys.length - 1]
  return current.delete(lastKey)
}

export function update(object: Map<string, Object>, path: string | Array<number>, updater: (value: Object) => Object): Map<string, Object> {
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> = object
  for (let i: number = 0; i < keys.length - 1; i++) {
    let next: Object | undefined = current.get(keys[i])
    if (next === undefined || !(next instanceof Map)) {
      next = new Map<string, Object>()
      current.set(keys[i], next)
    }
    current = next as Map<string, Object>
  }
  const lastKey: string = keys[keys.length - 1]
  const oldVal: Object | undefined = current.get(lastKey)
  current.set(lastKey, updater(oldVal as Object))
  return object
}

export function updateWith(object: Map<string, Object>, path: string | Array<number>, updater: (value: Object) => Object, customizer: (nsValue: Object, key: string, nsObject: Map<string, Object>) => Object): Map<string, Object> {
  const keys: Array<string> = castPathArray(path)
  let current: Map<string, Object> = object
  for (let i: number = 0; i < keys.length - 1; i++) {
    const key: string = keys[i]
    let next: Object | undefined = current.get(key)
    const custVal: Object = customizer(next as Object, key, current)
    if (custVal instanceof Map) {
      next = custVal
    }
    if (next === undefined || !(next instanceof Map)) {
      next = new Map<string, Object>()
    }
    current.set(key, next)
    current = next as Map<string, Object>
  }
  const lastKey: string = keys[keys.length - 1]
  const oldVal: Object | undefined = current.get(lastKey)
  current.set(lastKey, updater(oldVal as Object))
  return object
}

export function at(object: Map<string, Object> | Array<Object>, paths: Array<string | Array<number>>): Array<Object> {
  const result: Array<Object> = []
  for (let i: number = 0; i < paths.length; i++) {
    if (Array.isArray(object)) {
      const idx: number = typeof paths[i] === 'string' ? parseInt(paths[i] as string) : (paths[i] as Array<number>)[0]
      result.push(object[idx])
    } else {
      result.push(get(object as Map<string, Object>, paths[i]) as Object)
    }
  }
  return result
}

export function result(object: Map<string, Object>, path: string | Array<number>, defaultValue?: Object): Object {
  const val: Object | undefined = get(object, path, defaultValue)
  if (typeof val === 'function') {
    return (val as () => Object)()
  }
  return val as Object
}

export function invoke(object: Map<string, Object>, path: string, ...args: Array<Object>): Object | undefined {
  const method: Object | undefined = get(object, path)
  if (typeof method === 'function') {
    return (method as (...a: Array<Object>) => Object)(...args)
  }
  return undefined
}

function parseInt(str: string): number {
  return Number.parseInt(str)
}
