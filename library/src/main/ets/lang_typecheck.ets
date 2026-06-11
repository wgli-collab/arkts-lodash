/**
 * ArkTS Lodash — Type Checking Predicates
 * Uses typeof + instanceof checks instead of Object.prototype.toString.call()
 * because ArkTS forbids Function.call / Function.apply (R9).
 */

/**
 * Internal: check if value is object-like (typeof returns 'object' and not null).
 */
function isObjLike(value: Object | null): boolean {
  return typeof value === 'object' && value !== null
}

// ---- Public Type Checks ----

export function isArguments(value: Object | null): boolean {
  // ArkTS has no arguments object in strict mode — always false
  return false
}

export function isArray(value: Object | null): boolean {
  return Array.isArray(value)
}

export function isArrayBuffer(value: Object | null): boolean {
  return value instanceof ArrayBuffer
}

export function isArrayLike(value: Object | null): boolean {
  if (value === null || value === undefined || typeof value === 'function') {
    return false
  }
  const obj: Record<string, Object> = value as Record<string, Object>
  const length: Object = obj.length
  return typeof length === 'number' && (length as number) >= 0 && (length as number) <= Number.MAX_SAFE_INTEGER
}

export function isArrayLikeObject(value: Object | null): boolean {
  return isObjLike(value) && isArrayLike(value)
}

export function isBoolean(value: Object | null): boolean {
  return value === true || value === false
}

export function isDate(value: Object | null): boolean {
  return value instanceof Date
}

export function isElement(value: Object | null): boolean {
  // HarmonyOS has no DOM — always returns false
  return false
}

export function isEmpty(value: Object | null): boolean {
  if (value === null || value === undefined) {
    return true
  }
  if (Array.isArray(value) || typeof value === 'string') {
    return (value as Array<Object> | string).length === 0
  }
  if (value instanceof Map) {
    return (value as Map<Object, Object>).size === 0
  }
  if (value instanceof Set) {
    return (value as Set<Object>).size === 0
  }
  if (isObjLike(value)) {
    return Object.keys(value as Record<string, Object>).length === 0
  }
  return true
}

export function isError(value: Object | null): boolean {
  return value instanceof Error
}

export function isFinite(value: Object | null): boolean {
  return typeof value === 'number' && Number.isFinite(value as number)
}

export function isFunction(value: Object | null): boolean {
  return typeof value === 'function'
}

export function isInteger(value: Object | null): boolean {
  return typeof value === 'number' && Number.isInteger(value as number)
}

export function isLength(value: Object | null): boolean {
  return typeof value === 'number' &&
    (value as number) > -1 &&
    (value as number) % 1 === 0 &&
    (value as number) <= Number.MAX_SAFE_INTEGER
}

export function isMap(value: Object | null): boolean {
  return value instanceof Map
}

export function isNaN(value: Object | null): boolean {
  // NaN is the only value not equal to itself
  return typeof value === 'number' && value !== value
}

export function isNil(value: Object | null): boolean {
  return value === null || value === undefined
}

export function isNull(value: Object | null): boolean {
  return value === null
}

export function isNumber(value: Object | null): boolean {
  return typeof value === 'number'
}

export function isObject(value: Object | null): boolean {
  const t: string = typeof value
  return (value !== null && (t === 'object' || t === 'function'))
}

export function isObjectLike(value: Object | null): boolean {
  return typeof value === 'object' && value !== null
}

export function isPlainObject(value: Object | null): boolean {
  if (!isObjLike(value)) {
    return false
  }
  // ArkTS strict mode cannot use Object.getPrototypeOf; use exclusion approach.
  // Note: instances of user-defined classes will return true — this is a known
  // limitation of the exclusion strategy vs lodash's prototype-chain check.
  if (value instanceof Array ||
      value instanceof Map ||
      value instanceof Set ||
      value instanceof Date ||
      value instanceof RegExp ||
      value instanceof Error ||
      value instanceof ArrayBuffer ||
      isTypedArray(value)) {
    return false
  }
  return true
}

export function isRegExp(value: Object | null): boolean {
  return value instanceof RegExp
}

export function isSafeInteger(value: Object | null): boolean {
  return isInteger(value) && Math.abs(value as number) <= Number.MAX_SAFE_INTEGER
}

export function isSet(value: Object | null): boolean {
  return value instanceof Set
}

export function isString(value: Object | null): boolean {
  return typeof value === 'string'
}

export function isSymbol(value: Object | null): boolean {
  // ArkTS has no Symbol support — always returns false
  return false
}

export function isTypedArray(value: Object | null): boolean {
  return value instanceof Uint8Array ||
    value instanceof Uint8ClampedArray ||
    value instanceof Int8Array ||
    value instanceof Uint16Array ||
    value instanceof Int16Array ||
    value instanceof Uint32Array ||
    value instanceof Int32Array ||
    value instanceof Float32Array ||
    value instanceof Float64Array
}

export function isUndefined(value: Object | null): boolean {
  return value === undefined
}

export function isWeakMap(value: Object | null): boolean {
  // ArkTS has no WeakMap — always returns false
  return false
}

export function isWeakSet(value: Object | null): boolean {
  // ArkTS has no WeakSet — always returns false
  return false
}
