/**
 * Test Suite: Utility functions
 */
import { attempt, constant, defaultTo, identity, noop, range, rangeRight, times, uniqueId, toPath } from 'library'
import { castArray, toArray, toFinite, toInteger, toLength, toNumber, toPlainObject, toSafeInteger, toString, toPairs, clone, cloneDeep } from 'library'
import { TestSuite } from './TestRunner'

export function runUtilTests(suite: TestSuite): void {
  // -- Conversion --
  suite.test('castArray value', (): boolean => {
    const result: Array<number> = castArray(1)
    return result.length === 1 && result[0] === 1
  })
  suite.test('castArray array', (): boolean => {
    const result: Array<number> = castArray([1, 2, 3])
    return result.length === 3
  })

  suite.test('toArray array', (): boolean => toArray([1, 2, 3]).length === 3)
  suite.test('toArray null', (): boolean => toArray<number>(null).length === 0)

  suite.test('toFinite', (): boolean => {
    return toFinite(Number.POSITIVE_INFINITY) === Number.MAX_VALUE
  })
  suite.test('toFinite NaN → 0', (): boolean => {
    const nan: number = 0 / 0
    return toFinite(nan) === 0
  })

  suite.test('toInteger', (): boolean => toInteger(3.2) === 3)
  suite.test('toLength max', (): boolean => toLength(9999999999) === 4294967295)

  suite.test('toNumber string', (): boolean => toNumber('3.2') === 3.2)
  suite.test('toNumber number', (): boolean => toNumber(5) === 5)

  suite.test('toSafeInteger max', (): boolean => toSafeInteger(Number.MAX_VALUE) === Number.MAX_SAFE_INTEGER)
  suite.test('toSafeInteger normal', (): boolean => toSafeInteger(3.2) === 3)

  suite.test('toString null', (): boolean => toString(null) === '')
  suite.test('toString number', (): boolean => toString(5 as Object) === '5')
  suite.test('toString string', (): boolean => toString('hello' as Object) === 'hello')

  suite.test('toPairs', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const pairs: Array<[string, Object]> = toPairs(obj)
    return pairs.length === 1 && pairs[0][0] === 'a'
  })

  suite.test('clone number', (): boolean => clone(5) === 5)
  suite.test('clone array', (): boolean => {
    const arr: Array<number> = [1, 2, 3]
    const cloned: Array<number> = clone(arr)
    return cloned.length === 3 && cloned !== arr
  })

  suite.test('cloneDeep', (): boolean => {
    const nested: Array<Array<number>> = [[1, 2], [3, 4]]
    const cloned: Array<Array<number>> = cloneDeep(nested)
    return Array.isArray(cloned) && cloned.length === 2
  })

  suite.test('toPlainObject Map', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Map<string, Object> = toPlainObject(obj)
    return result.get('a') === 1
  })

  // -- Utilities --
  suite.test('attempt success', (): boolean => {
    const result: Object | Error = attempt((...args: Array<Object>): Object => {
      return ((args[0] as number) * 2) as Object
    }, 3 as Object)
    return !(result instanceof Error)
  })

  suite.test('attempt error', (): boolean => {
    const result: Object | Error = attempt((...args: Array<Object>): Object => {
      throw new Error('test error')
    })
    return result instanceof Error
  })

  suite.test('constant', (): boolean => constant(42)() === 42)

  suite.test('defaultTo', (): boolean => defaultTo(1, 10) === 1)
  suite.test('defaultTo null', (): boolean => defaultTo(null, 10) === 10)
  suite.test('defaultTo NaN', (): boolean => {
    const nan: number = 0 / 0
    return defaultTo(nan, 10) === 10
  })

  suite.test('identity', (): boolean => identity(42) === 42)
  suite.test('identity string', (): boolean => identity('hello') === 'hello')

  suite.test('noop returns undefined', (): boolean => {
    const v: void = noop()
    return v === undefined
  })

  suite.test('range', (): boolean => {
    const result: Array<number> = range(4)
    return result.length === 4 && result[0] === 0 && result[3] === 3
  })
  suite.test('range start,end', (): boolean => {
    const result: Array<number> = range(1, 5)
    return result[0] === 1 && result[3] === 4
  })
  suite.test('range step', (): boolean => {
    const result: Array<number> = range(0, 10, 3)
    return result.length === 4 && result[1] === 3 && result[2] === 6
  })
  suite.test('range step=0', (): boolean => range(1, 5, 0).length === 0)

  suite.test('rangeRight', (): boolean => {
    const result: Array<number> = rangeRight(4)
    return result[0] === 3 && result[3] === 0
  })

  suite.test('times', (): boolean => {
    const result: Array<number> = times(3, (i: number): number => i * 2)
    return result.length === 3 && result[0] === 0 && result[2] === 4
  })

  suite.test('uniqueId', (): boolean => {
    const id1: string = uniqueId()
    const id2: string = uniqueId()
    return id1 !== id2
  })
  suite.test('uniqueId prefix', (): boolean => {
    const id: string = uniqueId('contact_')
    return id.indexOf('contact_') === 0
  })

  suite.test('toPath', (): boolean => {
    const path: Array<string> = toPath('a.b.c')
    return path.length === 3 && path[0] === 'a' && path[2] === 'c'
  })
  suite.test('toPath brackets', (): boolean => {
    const path: Array<string> = toPath('a[0].b.c')
    return path.length === 4 && path[1] === '0'
  })
}
