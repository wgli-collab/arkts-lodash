/**
 * Test Suite: Function utilities
 */
import { after, before, ary, unary, negate, once, memoize, wrap as wrapFunc, spread, flip } from 'library'
import { bind, partial, partialRight, curry } from 'library'
import { defer, delay } from 'library'
import { flow, flowRight, over, overEvery, overSome, cond } from 'library'
import { TestSuite } from './TestRunner'

// Module-level helpers to avoid ArkTS closure nesting issues
function makeInc(): (...args: Object[]) => Object {
  const fn: (...args: Object[]) => Object = (...innerArgs: Object[]): Object => {
    return ((innerArgs[0] as number) + 1) as Object
  }
  return fn
}

function makeNegChecker(): (...args: Object[]) => boolean {
  const fn: (...args: Object[]) => boolean = (...innerArgs: Object[]): boolean => {
    return (innerArgs[0] as number) < 0
  }
  return fn
}

function makePosChecker(): (...args: Object[]) => boolean {
  const fn: (...args: Object[]) => boolean = (...innerArgs: Object[]): boolean => {
    return (innerArgs[0] as number) >= 0
  }
  return fn
}

export function runFunctionTests(suite: TestSuite): void {
  // -- Wrapping --
  suite.test('after', (): boolean => {
    let calls: number = 0
    const fn: (...args: Array<Object>) => Object | undefined = after(2, (): Object => { calls++; return calls as Object })
    fn()
    const result2: Object | undefined = fn()
    return result2 !== undefined && calls === 1
  })

  suite.test('before', (): boolean => {
    let calls: number = 0
    const fn: (...args: Array<Object>) => Object | undefined = before(3, (): Object => { calls++; return calls as Object })
    fn()
    fn()
    const val: Object | undefined = fn()
    return calls === 2 && val !== undefined
  })

  suite.test('ary', (): boolean => {
    const fn: (...args: Array<Object>) => Object = ary((...args: Array<Object>): Object => args.length as Object, 2)
    return (fn(1 as Object, 2 as Object, 3 as Object) as number) === 2
  })

  suite.test('unary', (): boolean => {
    const fn: (arg: number) => number = unary((arg: number, ...rest: Array<Object>): number => rest.length)
    return fn(1) === 0
  })

  suite.test('negate', (): boolean => {
    const fn: (...args: Array<Object>) => boolean = negate((...args: Array<Object>): boolean => true)
    return !fn()
  })

  suite.test('once', (): boolean => {
    let calls: number = 0
    const fn: (...args: Array<Object>) => Object | undefined = once((...args: Array<Object>): Object => { calls++; return calls as Object })
    fn()
    fn()
    return calls === 1
  })

  suite.test('memoize', (): boolean => {
    let calls: number = 0
    const fn: (...args: Array<Object>) => Object = memoize((...args: Array<Object>): Object => { calls++; return args[0] })
    fn(1 as Object)
    fn(1 as Object)
    fn(2 as Object)
    return calls === 2
  })

  suite.test('wrap', (): boolean => {
    const fn: (...args: Array<Object>) => Object = wrapFunc('hello' as Object, (v: Object): Object => (v as string).toUpperCase() as Object)
    return (fn() as string) === 'HELLO'
  })

  suite.test('spread', (): boolean => {
    const fn: (...args: Array<Object>) => Object = spread((args: Array<Object>): Object => args.length as Object)
    const result: Object = fn(1 as Object, 2 as Object, 3 as Object)
    return (result as number) === 3
  })

  suite.test('flip', (): boolean => {
    const fn: (...args: Array<Object>) => Object = flip((...args: Array<Object>): Object => (args[0] as string) + (args[1] as string) as Object)
    return (fn('a' as Object, 'b' as Object) as string) === 'ba'
  })

  // -- Binding --
  suite.test('bind', (): boolean => {
    const fn: (...args: Array<Object>) => Object = bind((...args: Array<Object>): Object => args.length as Object, 1 as Object)
    return (fn(2 as Object) as number) === 2
  })

  suite.test('partial', (): boolean => {
    const fn: (...args: Array<Object>) => Object = partial((...args: Array<Object>): Object => ((args[0] as number) + (args[1] as number)) as Object, 1 as Object)
    return (fn(2 as Object) as number) === 3
  })

  suite.test('partialRight', (): boolean => {
    const fn: (...args: Array<Object>) => Object = partialRight((...args: Array<Object>): Object => ((args[0] as number) + (args[1] as number)) as Object, 2 as Object)
    return (fn(1 as Object) as number) === 3
  })

  suite.test('curry', (): boolean => {
    const addFn: (...args: Array<Object>) => Object = (...args: Array<Object>): Object => ((args[0] as number) + (args[1] as number)) as Object
    const curried: Object = curry(addFn, 2)
    const step1: Object = (curried as (a: Object, ...b: Array<Object>) => Object)(1 as Object)
    const step2: Object = (step1 as (a: Object, ...b: Array<Object>) => Object)(2 as Object)
    return (step2 as number) === 3
  })

  // -- Timing --
  suite.test('defer returns number', (): boolean => {
    const timerId: number = defer((): void => {})
    return typeof timerId === 'number'
  })

  suite.test('delay returns number', (): boolean => {
    const timerId: number = delay((): void => {}, 10)
    return typeof timerId === 'number'
  })

  // -- Composition --
  suite.test('flow', (): boolean => {
    const inc: (...args: Array<Object>) => Object = makeInc()
    const composed: (...args: Array<Object>) => Object = flow(inc, inc)
    return (composed(1 as Object) as number) === 3
  })

  suite.test('flowRight', (): boolean => {
    const incR: (...args: Array<Object>) => Object = makeInc()
    const composedR: (...args: Array<Object>) => Object = flowRight(incR, incR)
    return (composedR(1 as Object) as number) === 3
  })

  suite.test('over', (): boolean => {
    const fns: (...args: Array<Object>) => Array<Object> = over(makeInc(), makeInc())
    const result: Array<Object> = fns(5 as Object)
    return (result[0] as number) === 6 && (result[1] as number) === 6
  })

  suite.test('overEvery', (): boolean => {
    const check: (...args: Array<Object>) => boolean = overEvery(
      (...args: Array<Object>): boolean => (args[0] as number) > 0,
      (...args: Array<Object>): boolean => (args[0] as number) < 10
    )
    return check(5 as Object) && !check(15 as Object)
  })

  suite.test('overSome', (): boolean => {
    const checkSome: (...args: Array<Object>) => boolean = overSome(
      (...args: Array<Object>): boolean => (args[0] as number) > 10,
      (...args: Array<Object>): boolean => (args[0] as number) < 0
    )
    return !checkSome(5 as Object) && checkSome(15 as Object)
  })

  suite.test('cond', (): boolean => {
    const fn: (...args: Array<Object>) => Object | undefined = cond([
      [makeNegChecker(), (...args: Array<Object>): Object => 'negative' as Object],
      [makePosChecker(), (...args: Array<Object>): Object => 'non-negative' as Object]
    ])
    return (fn(5 as Object) as string) === 'non-negative'
  })
}
