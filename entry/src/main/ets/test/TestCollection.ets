/**
 * Test Suite: Collection operations
 */
import { forEach, forEachRight, map, filter, reject, every, some, reduce, reduceRight, find, findLast, includes, size } from 'library'
import { countBy, groupBy, keyBy, partition, sortBy, flatMap, sample, sampleSize, shuffle } from 'library'
import { TestSuite } from './TestRunner'

export function runCollectionTests(suite: TestSuite): void {
  // -- Core Iteration --
  suite.test('forEach array', (): boolean => {
    let count: number = 0
    forEach([1, 2, 3], (): void => { count++ })
    return count === 3
  })

  suite.test('forEachRight array', (): boolean => {
    const order: Array<number> = []
    forEachRight([1, 2, 3], (v: number): void => { order.push(v) })
    return order[0] === 3
  })

  suite.test('map array', (): boolean => {
    const result: Array<number> = map([1, 2, 3], (v: number): number => v * 2)
    return result[0] === 2 && result[1] === 4 && result[2] === 6
  })

  suite.test('filter array', (): boolean => {
    const result: Array<number> = filter([1, 2, 3, 4], (v: number): boolean => v % 2 === 0)
    return result.length === 2
  })

  suite.test('reject array', (): boolean => {
    const result: Array<number> = reject([1, 2, 3, 4], (v: number): boolean => v % 2 === 0)
    return result.length === 2
  })

  suite.test('every true', (): boolean => every([2, 4, 6], (v: number): boolean => v % 2 === 0))
  suite.test('every false', (): boolean => !every([2, 4, 5], (v: number): boolean => v % 2 === 0))

  suite.test('some true', (): boolean => some([1, 2, 3], (v: number): boolean => v > 2))
  suite.test('some false', (): boolean => !some([1, 2, 3], (v: number): boolean => v > 5))

  suite.test('reduce', (): boolean => reduce([1, 2, 3], (a: number, v: number): number => a + v, 0) === 6)
  suite.test('reduceRight', (): boolean => reduceRight([1, 2, 3], (a: number, v: number): number => a + v, 0) === 6)

  suite.test('find', (): boolean => find([1, 2, 3, 4], (v: number): boolean => v > 2) === 3)
  suite.test('find not found', (): boolean => find([1, 2], (v: number): boolean => v > 5) === undefined)

  suite.test('findLast', (): boolean => findLast([1, 2, 3, 4], (v: number): boolean => v > 2) === 4)

  suite.test('includes array', (): boolean => includes([1, 2, 3], 2 as Object))
  suite.test('includes not in array', (): boolean => !includes([1, 2, 3], 5 as Object))
  suite.test('includes string', (): boolean => includes('abcd', 'bc' as Object))

  suite.test('size array', (): boolean => size([1, 2, 3]) === 3)
  suite.test('size string', (): boolean => size('abc') === 3)
  suite.test('size null', (): boolean => size(null) === 0)

  // -- Grouping --
  suite.test('countBy', (): boolean => {
    const result: Map<string, number> = countBy([6.1, 4.2, 6.3], (v: number): string => Math.floor(v).toString())
    return (result.get('6') ?? 0) === 2 && (result.get('4') ?? 0) === 1
  })

  suite.test('groupBy', (): boolean => {
    const result: Map<string, Array<number>> = groupBy([6.1, 4.2, 6.3], (v: number): string => Math.floor(v).toString())
    const g6: Array<number> | undefined = result.get('6')
    return g6 !== undefined && g6.length === 2
  })

  suite.test('keyBy', (): boolean => {
    const obj1: Record<string, Object> = {}
    obj1['dir'] = 'left' as Object
    obj1['code'] = 97 as Object
    const obj2: Record<string, Object> = {}
    obj2['dir'] = 'right' as Object
    obj2['code'] = 100 as Object
    const arr: Array<Record<string, Object>> = [obj1, obj2]
    const result: Map<string, Record<string, Object>> = keyBy(arr, (v: Record<string, Object>): string => v.dir as string)
    const left: Record<string, Object> | undefined = result.get('left')
    return left !== undefined && (left as Record<string, Object>).code === 97
  })

  suite.test('partition', (): boolean => {
    const result: [Array<number>, Array<number>] = partition([1, 2, 3, 4], (v: number): boolean => v % 2 === 0)
    return result[0].length === 2 && result[1].length === 2
  })

  suite.test('sortBy', (): boolean => {
    const obj1: Record<string, Object> = {}
    obj1['name'] = 'fred' as Object
    const obj2: Record<string, Object> = {}
    obj2['name'] = 'barney' as Object
    const users: Array<Record<string, Object>> = [obj1, obj2]
    const byName: (v: Record<string, Object>) => string = (v: Record<string, Object>): string => v.name as string
    const result: Array<Record<string, Object>> = sortBy(users, byName)
    return (result[0] as Record<string, Object>).name === 'barney'
  })

  suite.test('flatMap', (): boolean => {
    const result: Array<number> = flatMap([1, 2], (v: number): Array<number> => [v, v])
    return result.length === 4
  })

  suite.test('sample', (): boolean => sample([1, 2, 3]) !== undefined)
  suite.test('sample empty', (): boolean => sample([]) === undefined)

  suite.test('sampleSize', (): boolean => sampleSize([1, 2, 3, 4], 2).length === 2)
  suite.test('sampleSize > length', (): boolean => {
    return sampleSize([1, 2, 3], 5).length === 3
  })

  suite.test('shuffle same length', (): boolean => shuffle([1, 2, 3, 4]).length === 4)
}
