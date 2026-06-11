/**
 * Test Suite: Object operations
 */
import { get, set, has, unset, update, at, result, invoke } from 'library'
import { assign, merge, defaults, omit, pick, pickBy, mapKeys, mapValues, invert } from 'library'
import { keys, values, forOwn, forOwnRight, findKey, findLastKey, functions } from 'library'
import { TestSuite } from './TestRunner'

export function runObjectTests(suite: TestSuite): void {
  // -- Access --
  suite.test('get', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    const inner: Map<string, Object> = new Map<string, Object>()
    inner.set('c', 3 as Object)
    obj.set('a', inner as Object)
    const result: Object | undefined = get(obj, 'a.c')
    return (result as number) === 3
  })

  suite.test('get with default', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    const result: Object | undefined = get(obj, 'a.b', 'default' as Object)
    return (result as string) === 'default'
  })

  suite.test('set', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    const result: Map<string, Object> = set(obj, 'a.b', 3 as Object)
    const inner: Object | undefined = result.get('a')
    return inner !== undefined && (inner as Map<string, Object>).get('b') === 3
  })

  suite.test('has', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    return has(obj, 'a') && !has(obj, 'b')
  })

  suite.test('unset', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: boolean = unset(obj, 'a')
    return result && !obj.has('a')
  })

  suite.test('update', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Map<string, Object> = update(obj, 'a', (v: Object): Object => ((v as number) * 2) as Object)
    return (result.get('a') as number) === 2
  })

  suite.test('at', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    const result: Array<Object | undefined> = at(obj, ['a', 'b'])
    return result.length === 2 && (result[0] as number) === 1 && (result[1] as number) === 2
  })

  suite.test('result', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 42 as Object)
    return (result(obj, 'a') as number) === 42
  })

  suite.test('invoke', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('fn', ((...args: Array<Object>): Object => ((args[0] as number) * 2) as Object) as Object)
    const result: Object | undefined = invoke(obj, 'fn', 3 as Object)
    return (result as number) === 6
  })

  // -- Transform --
  suite.test('assign', (): boolean => {
    const target: Map<string, Object> = new Map<string, Object>()
    target.set('a', 0 as Object)
    const source: Map<string, Object> = new Map<string, Object>()
    source.set('b', 2 as Object)
    const result: Map<string, Object> = assign(target, source)
    return result.get('a') === 0 && result.get('b') === 2
  })

  suite.test('merge', (): boolean => {
    const target: Map<string, Object> = new Map<string, Object>()
    target.set('a', 1 as Object)
    const source: Map<string, Object> = new Map<string, Object>()
    source.set('b', 2 as Object)
    const result: Map<string, Object> = merge(target, source)
    return result.get('a') === 1 && result.get('b') === 2
  })

  suite.test('defaults', (): boolean => {
    const target: Map<string, Object> = new Map<string, Object>()
    target.set('a', 1 as Object)
    const source: Map<string, Object> = new Map<string, Object>()
    source.set('a', 99 as Object)
    source.set('b', 2 as Object)
    const result: Map<string, Object> = defaults(target, source)
    return result.get('a') === 1 && result.get('b') === 2
  })

  suite.test('omit', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    obj.set('c', 3 as Object)
    const result: Map<string, Object> = omit(obj, 'a', 'c')
    return result.has('b') && !result.has('a')
  })

  suite.test('pick', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    obj.set('c', 3 as Object)
    const result: Map<string, Object> = pick(obj, 'a', 'c')
    return result.has('a') && result.has('c') && !result.has('b')
  })

  suite.test('pickBy', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    obj.set('c', 3 as Object)
    const result: Map<string, Object> = pickBy(obj, (v: Object): boolean => (v as number) > 1)
    return result.has('b') && result.has('c') && !result.has('a')
  })

  suite.test('mapKeys', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Map<string, Object> = mapKeys(obj, (v: Object, k: string): string => k.toUpperCase())
    return result.has('A')
  })

  suite.test('mapValues', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Map<string, Object> = mapValues(obj, (v: Object): Object => ((v as number) * 2) as Object)
    return (result.get('a') as number) === 2
  })

  suite.test('invert', (): boolean => {
    const obj: Map<string, string> = new Map<string, string>()
    obj.set('a', '1')
    obj.set('b', '2')
    const result: Map<string, string> = invert(obj)
    return result.has('1') && result.has('2')
  })

  // -- Iteration --
  suite.test('keys', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Array<string> = keys(obj)
    return result.length === 1 && result[0] === 'a'
  })

  suite.test('values', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    const result: Array<Object> = values(obj)
    return result.length === 1 && (result[0] as number) === 1
  })

  suite.test('forOwn', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    let count: number = 0
    forOwn(obj, (): void => { count++ })
    return count === 1
  })

  suite.test('forOwnRight', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    let count: number = 0
    forOwnRight(obj, (v: Object, k: string): void => { count++ })
    return count === 2
  })

  suite.test('findKey', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    const key: string | undefined = findKey(obj, (v: Object): boolean => (v as number) === 2)
    return key === 'b'
  })

  suite.test('findLastKey', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    const key: string | undefined = findLastKey(obj, (v: Object): boolean => (v as number) === 1)
    return key === 'a'
  })

  suite.test('functions', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('fn', ((): void => {}) as Object)
    const result: Array<string> = functions(obj)
    return result.length === 1 && result[0] === 'fn'
  })
}
