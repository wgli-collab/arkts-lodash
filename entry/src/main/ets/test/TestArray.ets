/**
 * Test Suite: Array operations
 */
import { chunk, compact, concat, drop, dropRight, fill, flatten, flattenDeep, head, initial, join, last, nth, reverse, slice as sliceArray, tail, take, takeRight } from 'library'
import { difference, intersection, union, uniq, without, xor, zip, zipObject, unzip } from 'library'
import { findIndex, findLastIndex, indexOf, lastIndexOf, pull, pullAll, remove, sortedIndex, sortedUniq } from 'library'
import { TestSuite } from './TestRunner'

export function runArrayTests(suite: TestSuite): void {
  // -- Basic --
  suite.test('chunk', (): boolean => {
    const result: Array<Array<number>> = chunk([1, 2, 3, 4, 5], 2)
    return result.length === 3 && result[0].length === 2 && result[2].length === 1
  })
  suite.test('chunk empty', (): boolean => chunk([], 2).length === 0)

  suite.test('compact', (): boolean => {
    const result: Array<number> = compact([0, 1, 0, 2, 0, 3])
    return result.length === 3
  })

  suite.test('concat', (): boolean => {
    const result: Array<number> = concat([1], 2, [3, 4])
    return result.length === 4
  })

  suite.test('drop', (): boolean => drop([1, 2, 3], 1).length === 2)
  suite.test('dropRight', (): boolean => dropRight([1, 2, 3], 1).length === 2)

  suite.test('fill', (): boolean => {
    const arr: Array<number> = [1, 2, 3]
    fill(arr, 0)
    return arr[0] === 0 && arr[1] === 0 && arr[2] === 0
  })

  suite.test('flatten', (): boolean => flatten([[1], [2], [3]]).length === 3)

  suite.test('flattenDeep', (): boolean => {
    return flattenDeep<number>([[[[1]]]]) .length === 1
  })

  suite.test('head', (): boolean => head([1, 2, 3]) === 1)
  suite.test('head empty', (): boolean => head([]) === undefined)

  suite.test('initial', (): boolean => initial([1, 2, 3]).length === 2)
  suite.test('initial single', (): boolean => initial([1]).length === 0)

  suite.test('join', (): boolean => join([1, 2, 3], '-') === '1-2-3')

  suite.test('last', (): boolean => last([1, 2, 3]) === 3)
  suite.test('last empty', (): boolean => last([]) === undefined)

  suite.test('nth', (): boolean => nth([1, 2, 3], 1) === 2)
  suite.test('nth negative', (): boolean => nth([1, 2, 3], -1) === 3)

  suite.test('reverse', (): boolean => reverse([1, 2, 3])[0] === 3)

  suite.test('slice', (): boolean => sliceArray([1, 2, 3, 4], 1, 3).length === 2)

  suite.test('tail', (): boolean => tail([1, 2, 3]).length === 2)
  suite.test('tail empty', (): boolean => tail([1]).length === 0)

  suite.test('take', (): boolean => take([1, 2, 3], 2).length === 2)
  suite.test('takeRight', (): boolean => takeRight([1, 2, 3], 2).length === 2)

  // -- Set Operations --
  suite.test('difference', (): boolean => difference([2, 1], [2, 3]).length === 1)

  suite.test('intersection', (): boolean => {
    const result: Array<number> = intersection([2, 1], [2, 3])
    return result.length === 1 && result[0] === 2
  })

  suite.test('union', (): boolean => union([2], [1, 2]).length === 2)
  suite.test('uniq', (): boolean => uniq([2, 1, 2]).length === 2)

  suite.test('without', (): boolean => without([2, 1, 2, 3], 1, 2).length === 1)

  suite.test('xor', (): boolean => xor([2, 1], [2, 3]).length === 2)

  suite.test('zip', (): boolean => {
    const result: Array<Array<number>> = zip([1, 2], [10, 20])
    return result.length === 2 && result[0][0] === 1 && result[0][1] === 10
  })

  suite.test('zipObject', (): boolean => {
    const result: Map<string, number> = zipObject(['a', 'b'], [1, 2])
    return result.get('a') === 1 && result.get('b') === 2
  })

  suite.test('unzip', (): boolean => {
    const zipped: Array<Array<number>> = zip([1, 2], [10, 20], [100, 200])
    const result: Array<Array<number>> = unzip(zipped)
    return result.length === 3 && result[0].length === 2
  })

  // -- Search --
  suite.test('findIndex', (): boolean => {
    const o1: Record<string, Object> = {}
    o1['name'] = 'barney' as Object
    o1['active'] = false as Object
    const o2: Record<string, Object> = {}
    o2['name'] = 'fred' as Object
    o2['active'] = false as Object
    const o3: Record<string, Object> = {}
    o3['name'] = 'pebbles' as Object
    o3['active'] = true as Object
    return findIndex([o1, o2, o3], (v: Record<string, Object>): boolean => v.name === 'barney') === 0
  })

  suite.test('findLastIndex', (): boolean => {
    return findLastIndex([1, 2, 3, 2, 1], (v: number): boolean => v === 2) === 3
  })

  suite.test('indexOf', (): boolean => indexOf([1, 2, 1, 2], 2) === 1)
  suite.test('lastIndexOf', (): boolean => lastIndexOf([1, 2, 1, 2], 2) === 3)
  suite.test('indexOf NaN', (): boolean => {
    const nan: number = 0 / 0
    return indexOf([nan, 1, 2], nan) === 0
  })

  suite.test('pull', (): boolean => {
    const arr: Array<number> = [1, 2, 3, 1, 2, 3]
    pull(arr, 2, 3)
    return arr.length === 2
  })

  suite.test('pullAll', (): boolean => {
    const arr: Array<number> = [1, 2, 3, 1, 2, 3]
    pullAll(arr, [2, 3])
    return arr.length === 2
  })

  suite.test('remove', (): boolean => {
    const arr: Array<number> = [1, 2, 3, 4]
    const evens: Array<number> = remove(arr, (n: number): boolean => n % 2 === 0)
    return evens.length === 2 && arr.length === 2
  })

  suite.test('sortedIndex', (): boolean => sortedIndex([10, 20, 30, 40, 50], 35) === 3)
  suite.test('sortedIndex first', (): boolean => sortedIndex([10, 20, 30], 5) === 0)

  suite.test('sortedUniq', (): boolean => sortedUniq([1, 1, 2]).length === 2)
}
