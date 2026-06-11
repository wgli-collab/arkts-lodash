/**
 * Test Suite: Math (basic + extremum)
 */
import { add, subtract, multiply, divide, ceil, floor, round, sum, sumBy, mean, meanBy } from 'library'
import { max, maxBy, min, minBy, clamp, inRange, random } from 'library'
import { TestSuite } from './TestRunner'

export function runMathTests(suite: TestSuite): void {
  // -- Arithmetic --
  suite.test('add', (): boolean => add(1, 2) === 3)
  suite.test('subtract', (): boolean => subtract(5, 3) === 2)
  suite.test('multiply', (): boolean => multiply(3, 4) === 12)
  suite.test('divide', (): boolean => divide(10, 2) === 5)
  suite.test('divide by zero', (): boolean => divide(5, 0) === Number.POSITIVE_INFINITY)

  suite.test('ceil', (): boolean => ceil(4.006, 0) === 5)
  suite.test('ceil precision', (): boolean => ceil(6.004, 2) === 6.01)

  suite.test('floor', (): boolean => floor(4.9, 0) === 4)
  suite.test('floor precision', (): boolean => floor(4.95, 1) === 4.9)

  suite.test('round', (): boolean => round(4.5, 0) === 5)
  suite.test('round precision', (): boolean => round(4.123, 2) === 4.12)

  // -- Aggregation --
  suite.test('sum', (): boolean => sum([1, 2, 3, 4]) === 10)
  suite.test('sum empty', (): boolean => sum([]) === 0)

  suite.test('sumBy', (): boolean => {
    const obj1: Record<string, Object> = {}
    obj1['n'] = 1 as Object
    const obj2: Record<string, Object> = {}
    obj2['n'] = 2 as Object
    const obj3: Record<string, Object> = {}
    obj3['n'] = 3 as Object
    return sumBy([obj1, obj2, obj3], (v: Record<string, Object>): number => v.n as number) === 6
  })

  suite.test('mean', (): boolean => mean([1, 2, 3]) === 2)
  suite.test('mean empty → NaN', (): boolean => {
    const result: number = mean([])
    return result !== result // NaN check
  })

  suite.test('meanBy', (): boolean => {
    const obj1: Record<string, Object> = {}
    obj1['n'] = 1 as Object
    const obj2: Record<string, Object> = {}
    obj2['n'] = 2 as Object
    const arr: Array<Record<string, Object>> = [obj1, obj2]
    return meanBy(arr, (v: Record<string, Object>): number => v.n as number) === 1.5
  })

  // -- Extremum --
  suite.test('max', (): boolean => max([1, 5, 3, 4]) === 5)
  suite.test('max empty', (): boolean => max([]) === undefined)

  suite.test('maxBy', (): boolean => {
    return maxBy([1, 3, 5, 2], (v: number): number => v) === 5
  })

  suite.test('min', (): boolean => min([1, 5, 3, 4]) === 1)
  suite.test('min empty', (): boolean => min([]) === undefined)

  suite.test('minBy', (): boolean => {
    return minBy([1, 3, 5, 2], (v: number): number => v) === 1
  })

  // -- Range --
  suite.test('clamp', (): boolean => clamp(10, 0, 5) === 5)
  suite.test('clamp below', (): boolean => clamp(-5, 0, 5) === 0)
  suite.test('clamp in range', (): boolean => clamp(3, 0, 5) === 3)

  suite.test('inRange', (): boolean => inRange(3, 1, 5))
  suite.test('inRange below', (): boolean => !inRange(0, 1, 5))
  suite.test('inRange at start', (): boolean => inRange(1, 1, 5))

  suite.test('random in range', (): boolean => {
    const r: number = random(1, 10)
    return r >= 1 && r <= 10
  })
  suite.test('random 0-1', (): boolean => {
    const r: number = random(true as Object as number)
    return r >= 0 && r <= 1
  })
  suite.test('random integer', (): boolean => {
    const r: number = random(1, 10)
    return r === Math.floor(r)
  })
}
