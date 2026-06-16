/**
 * ArkTS Lodash — Basic Math Operations
 */

export function add(augend: number, addend: number): number {
  return augend + addend
}

export function subtract(minuend: number, subtrahend: number): number {
  return minuend - subtrahend
}

export function multiply(multiplier: number, multiplicand: number): number {
  return multiplier * multiplicand
}

export function divide(dividend: number, divisor: number): number {
  return dividend / divisor
}

export function ceil(number: number, precision?: number): number {
  let p: number = precision !== undefined ? precision : 0
  if (p <= 0 || p > 292) {
    return Math.ceil(number)
  }
  const factor: number = Math.pow(10, p)
  const shifted: number = number * factor
  return Math.ceil(shifted) / factor
}

export function floor(number: number, precision?: number): number {
  let p: number = precision !== undefined ? precision : 0
  if (p <= 0 || p > 292) {
    return Math.floor(number)
  }
  const factor: number = Math.pow(10, p)
  const shifted: number = number * factor
  return Math.floor(shifted) / factor
}

export function round(number: number, precision?: number): number {
  let p: number = precision !== undefined ? precision : 0
  if (p <= 0 || p > 292) {
    return Math.round(number)
  }
  const factor: number = Math.pow(10, p)
  const shifted: number = number * factor
  return Math.round(shifted) / factor
}

export function sum(array: Array<number>): number {
  let result: number = 0
  for (let i: number = 0; i < array.length; i++) {
    result += array[i]
  }
  return result
}

export function sumBy<T>(array: Array<T>, iteratee: (value: T) => number): number {
  let result: number = 0
  for (let i: number = 0; i < array.length; i++) {
    result += iteratee(array[i])
  }
  return result
}

export function mean(array: Array<number>): number {
  if (array.length === 0) {
    return NaN
  }
  return sum(array) / array.length
}

export function meanBy<T>(array: Array<T>, iteratee: (value: T) => number): number {
  if (array.length === 0) {
    return NaN
  }
  return sumBy(array, iteratee) / array.length
}
