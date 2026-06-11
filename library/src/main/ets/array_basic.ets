/**
 * ArkTS Lodash — Basic Array Operations
 */

export function chunk<T>(array: Array<T>, size: number): Array<Array<T>> {
  let s: number = Math.floor(size)
  if (s < 1 || array.length === 0) {
    return []
  }
  const result: Array<Array<T>> = []
  let index: number = 0
  while (index < array.length) {
    result.push(array.slice(index, index + s))
    index += s
  }
  return result
}

export function compact<T>(array: Array<T>): Array<T> {
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const val: T = array[i]
    if (val) {
      result.push(val)
    }
  }
  return result
}

export function concat<T>(array: Array<T>, ...values: Array<T | Array<T>>): Array<T> {
  const result: Array<T> = array.slice()
  for (let i: number = 0; i < values.length; i++) {
    const val: T | Array<T> = values[i]
    if (Array.isArray(val)) {
      for (let j: number = 0; j < (val as Array<T>).length; j++) {
        result.push((val as Array<T>)[j])
      }
    } else {
      result.push(val as T)
    }
  }
  return result
}

export function drop<T>(array: Array<T>, n: number): Array<T> {
  const count: number = n < 0 ? 0 : Math.floor(n)
  return array.slice(count)
}

export function dropRight<T>(array: Array<T>, n: number): Array<T> {
  const count: number = n < 0 ? 0 : Math.floor(n)
  if (count >= array.length) {
    return []
  }
  return array.slice(0, array.length - count)
}

export function dropRightWhile<T>(array: Array<T>, predicate: (value: T, index: number) => boolean): Array<T> {
  let end: number = array.length
  while (end > 0 && predicate(array[end - 1], end - 1)) {
    end--
  }
  return array.slice(0, end)
}

export function dropWhile<T>(array: Array<T>, predicate: (value: T, index: number) => boolean): Array<T> {
  let start: number = 0
  while (start < array.length && predicate(array[start], start)) {
    start++
  }
  return array.slice(start)
}

export function fill<T>(array: Array<T>, value: T, start?: number, end?: number): Array<T> {
  const s: number = start !== undefined ? start : 0
  const e: number = end !== undefined ? end : array.length
  for (let i: number = s; i < e; i++) {
    array[i] = value
  }
  return array
}

export function flatten<T>(array: Array<Array<T>>): Array<T> {
  const result: Array<T> = []
  for (let i: number = 0; i < array.length; i++) {
    const item: Array<T> = array[i]
    if (Array.isArray(item)) {
      for (let j: number = 0; j < item.length; j++) {
        result.push(item[j])
      }
    } else {
      result.push(item as Object as T)
    }
  }
  return result
}

export function flattenDeep<T>(array: Array<Object>): Array<T> {
  const result: Array<T> = []
  flattenDeepRecur(array, result)
  return result
}

function flattenDeepRecur<T>(array: Array<Object>, result: Array<T>): void {
  for (let i: number = 0; i < array.length; i++) {
    const val: Object = array[i]
    if (Array.isArray(val)) {
      flattenDeepRecur(val as Array<Object>, result)
    } else {
      result.push(val as Object as T)
    }
  }
}

export function flattenDepth<T>(array: Array<Object>, depth: number): Array<T> {
  const result: Array<T> = []
  flattenDepthRecur(array, depth, result)
  return result
}

function flattenDepthRecur<T>(array: Array<Object>, depth: number, result: Array<T>): void {
  for (let i: number = 0; i < array.length; i++) {
    const val: Object = array[i]
    if (depth > 0 && Array.isArray(val)) {
      flattenDepthRecur(val as Array<Object>, depth - 1, result)
    } else {
      result.push(val as Object as T)
    }
  }
}

export function fromPairs<T>(pairs: Array<[string, T]>): Map<string, T> {
  const result: Map<string, T> = new Map<string, T>()
  for (let i: number = 0; i < pairs.length; i++) {
    const pair: [string, T] = pairs[i]
    result.set(pair[0], pair[1])
  }
  return result
}

export function head<T>(array: Array<T>): T | undefined {
  return array.length > 0 ? array[0] : undefined
}

export function initial<T>(array: Array<T>): Array<T> {
  if (array.length <= 1) {
    return []
  }
  return array.slice(0, array.length - 1)
}

export function join<T>(array: Array<T>, separator: string): string {
  return array.join(separator)
}

export function last<T>(array: Array<T>): T | undefined {
  return array.length > 0 ? array[array.length - 1] : undefined
}

export function nth<T>(array: Array<T>, n: number): T | undefined {
  const index: number = n < 0 ? array.length + n : n
  return index >= 0 && index < array.length ? array[index] : undefined
}

export function reverse<T>(array: Array<T>): Array<T> {
  return array.reverse()
}

export function slice<T>(array: Array<T>, start: number, end?: number): Array<T> {
  return array.slice(start, end)
}

export function tail<T>(array: Array<T>): Array<T> {
  return array.length > 1 ? array.slice(1) : []
}

export function take<T>(array: Array<T>, n: number): Array<T> {
  const count: number = n < 0 ? 0 : Math.floor(n)
  return array.slice(0, count)
}

export function takeRight<T>(array: Array<T>, n: number): Array<T> {
  const count: number = n < 0 ? 0 : Math.floor(n)
  if (count >= array.length) {
    return array.slice()
  }
  return array.slice(array.length - count)
}

export function takeRightWhile<T>(array: Array<T>, predicate: (value: T, index: number) => boolean): Array<T> {
  let end: number = array.length
  while (end > 0 && predicate(array[end - 1], end - 1)) {
    end--
  }
  return array.slice(end)
}

export function takeWhile<T>(array: Array<T>, predicate: (value: T, index: number) => boolean): Array<T> {
  let end: number = 0
  while (end < array.length && predicate(array[end], end)) {
    end++
  }
  return array.slice(0, end)
}
