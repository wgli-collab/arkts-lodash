/**
 * ArkTS Lodash — Internal Helper Functions
 * NOT part of public API. Used by other library modules.
 */
// No type imports needed — all types defined inline or use primitives

// ---- Array Helpers ----

/**
 * Slices `array` from `start` up to, but not including, `end`.
 * Internal: no guards — callers must validate inputs.
 */
export function baseSlice<T>(array: Array<T>, start: number, end: number): Array<T> {
  let index: number = -1
  let length: number = end - start
  if (length < 0) {
    length = 0
  }
  const result: Array<T> = new Array<T>(length)
  while (++index < length) {
    result[index] = array[index + start]
  }
  return result
}

// ---- Path Helpers ----

/** Regular expression for matching bracket notation: obj["key"] or obj[0] */
const rePropName: RegExp = /[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g

/** Regular expression for matching backslash-escaped characters in path strings */
const reEscapeChar: RegExp = /\\(\\)?/g

/**
 * Converts a dot/bracket-notation path string to an array of property keys.
 * e.g. "a.b[0].c" => ["a", "b", "0", "c"]
 */
export function stringToPath(value: string): Array<string> {
  const result: Array<string> = []
  if (value.charCodeAt(0) === 46 /* '.' */) {
    result.push('')
  }
  let match: Array<string> | null = rePropName.exec(value) as Array<string> | null
  while (match !== null) {
    const key: string = match[3] ?? match[1] ?? match[0]
    result.push(key.replace(reEscapeChar, '$1'))
    match = rePropName.exec(value)
  }
  return result
}

/**
 * Converts a value to a string key for object property access.
 */
export function toKey(value: number | string): string {
  if (typeof value === 'string') {
    return value
  }
  const result: string = value.toString()
  return (result === '0' && (1 / value) === (-1 / 0)) ? '-0' : result
}

/**
 * Casts `path` to an array of string keys.
 * If already an array, converts numbers to strings.
 * If a string, parses dot/bracket notation.
 */
export function castPath(value: string | Array<number> | Array<string>): Array<string> {
  if (Array.isArray(value)) {
    const arr: Array<string> = []
    for (let i: number = 0; i < value.length; i++) {
      arr[i] = typeof value[i] === 'string' ? value[i] as string : (value[i] as number).toString()
    }
    return arr
  }
  return stringToPath(value as string)
}

/**
 * Checks if `value` is a valid property key (not __proto__).
 */
export function isKeyable(value: string | number | boolean | null): boolean {
  const t: string = typeof value
  if (t === 'string' || t === 'number' || t === 'boolean') {
    return value !== '__proto__'
  }
  return value === null
}
