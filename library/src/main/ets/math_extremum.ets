/**
 * ArkTS Lodash — Extremum & Random Math Functions
 */

export function max(array: Array<number>): number | undefined {
  if (array.length === 0) {
    return undefined
  }
  let result: number = array[0]
  for (let i: number = 1; i < array.length; i++) {
    if (array[i] > result) {
      result = array[i]
    }
  }
  return result
}

export function maxBy<T>(array: Array<T>, iteratee: (value: T) => number): T | undefined {
  if (array.length === 0) {
    return undefined
  }
  let result: T = array[0]
  let maxVal: number = iteratee(array[0])
  for (let i: number = 1; i < array.length; i++) {
    const val: number = iteratee(array[i])
    if (val > maxVal) {
      maxVal = val
      result = array[i]
    }
  }
  return result
}

export function min(array: Array<number>): number | undefined {
  if (array.length === 0) {
    return undefined
  }
  let result: number = array[0]
  for (let i: number = 1; i < array.length; i++) {
    if (array[i] < result) {
      result = array[i]
    }
  }
  return result
}

export function minBy<T>(array: Array<T>, iteratee: (value: T) => number): T | undefined {
  if (array.length === 0) {
    return undefined
  }
  let result: T = array[0]
  let minVal: number = iteratee(array[0])
  for (let i: number = 1; i < array.length; i++) {
    const val: number = iteratee(array[i])
    if (val < minVal) {
      minVal = val
      result = array[i]
    }
  }
  return result
}

export function clamp(number: number, lower: number, upper: number): number {
  if (number < lower) {
    return lower
  }
  if (number > upper) {
    return upper
  }
  return number
}

export function inRange(number: number, start: number, end?: number): boolean {
  let s: number = start
  let e: number = end ?? 0
  if (end === undefined) {
    e = start
    s = 0
  }
  if (s > e) {
    const temp: number = s
    s = e
    e = temp
  }
  return number >= s && number < e
}

export function random(lower: number, upper?: number, floating?: boolean): number {
  let s: number = lower
  let e: number = upper ?? 0
  if (upper === undefined) {
    e = lower
    s = 0
  }
  // Swap if inverted range (matching lodash behavior)
  if (s > e) {
    const temp: number = s
    s = e
    e = temp
  }
  const isFloat: boolean = floating === true ||
    (floating !== false && (s % 1 !== 0 || e % 1 !== 0))
  if (isFloat) {
    return s + Math.random() * (e - s)
  }
  const minInt: number = Math.ceil(s)
  const maxInt: number = Math.floor(e)
  return Math.floor(Math.random() * (maxInt - minInt + 1)) + minInt
}
