/**
 * Test Suite: Language type checking & comparison & stubs
 */
import { isArray, isBoolean, isDate, isEmpty, isFinite, isFunction, isInteger, isMap, isNaN as isNaNCheck, isNil, isNull, isNumber, isObject, isObjectLike, isPlainObject, isRegExp, isSafeInteger, isSet, isString, isUndefined, isTypedArray } from 'library'
import { eq, gt, gte, lt, lte, isEqual, isMatch } from 'library'
import { stubArray, stubFalse, stubObject, stubString, stubTrue } from 'library'
import { TestSuite } from './TestRunner'

export function runLangTests(suite: TestSuite): void {
  const emptyArr: Array<number> = []
  const emptyObj: Record<string, Object> = {}

  // -- Type Checking --
  suite.test('isArray([])', (): boolean => isArray(emptyArr as Object | null))
  suite.test('isArray({})', (): boolean => !isArray(emptyObj as Object | null))
  suite.test('isArray(null)', (): boolean => !isArray(null))

  suite.test('isBoolean(true)', (): boolean => isBoolean(true as Object | null))
  suite.test('isBoolean("true")', (): boolean => !isBoolean('true' as Object | null))

  suite.test('isDate(new Date)', (): boolean => isDate(new Date() as Object | null))
  suite.test('isDate("")', (): boolean => !isDate('' as Object | null))

  suite.test('isEmpty(null)', (): boolean => isEmpty(null))
  suite.test('isEmpty([])', (): boolean => isEmpty(emptyArr as Object | null))
  suite.test('isEmpty([1])', (): boolean => !isEmpty([1, 2] as Object | null))
  suite.test('isEmpty("")', (): boolean => isEmpty('' as Object | null))
  suite.test('isEmpty("abc")', (): boolean => !isEmpty('abc' as Object | null))
  suite.test('isEmpty({})', (): boolean => isEmpty(emptyObj as Object | null))

  suite.test('isFinite(3)', (): boolean => isFinite(3 as Object | null))
  suite.test('isFinite(Infinity)', (): boolean => !isFinite(Number.POSITIVE_INFINITY as Object | null))

  suite.test('isFunction(()=>{})', (): boolean => isFunction(((): void => {}) as Object | null))
  suite.test('isFunction(3)', (): boolean => !isFunction(3 as Object | null))

  suite.test('isInteger(3)', (): boolean => isInteger(3 as Object | null))
  suite.test('isInteger(3.5)', (): boolean => !isInteger(3.5 as Object | null))

  suite.test('isMap(new Map)', (): boolean => isMap(new Map<string, Object>() as Object | null))
  suite.test('isMap({})', (): boolean => !isMap(emptyObj as Object | null))

  suite.test('isNil(null)', (): boolean => isNil(null))
  suite.test('isNil check via null', (): boolean => {
    const u: Object | null = null
    return isNil(u)
  })
  suite.test('isNil(0)', (): boolean => !isNil(0 as Object | null))

  suite.test('isNull(null)', (): boolean => isNull(null))
  suite.test('isNull check', (): boolean => {
    const u: Object | null = null
    return isNull(u) && !isNull(new Object())
  })

  suite.test('isNumber(3)', (): boolean => isNumber(3 as Object | null))
  suite.test('isNumber("3")', (): boolean => !isNumber('3' as Object | null))

  suite.test('isObject({})', (): boolean => isObject(emptyObj as Object | null))
  suite.test('isObject(null)', (): boolean => !isObject(null))

  suite.test('isObjectLike({})', (): boolean => isObjectLike(emptyObj as Object | null))
  suite.test('isObjectLike(null)', (): boolean => !isObjectLike(null))

  suite.test('isPlainObject({})', (): boolean => isPlainObject(emptyObj as Object | null))
  suite.test('isPlainObject([])', (): boolean => !isPlainObject(emptyArr as Object | null))
  suite.test('isPlainObject(new Date)', (): boolean => !isPlainObject(new Date() as Object | null))

  suite.test('isRegExp(/abc/)', (): boolean => isRegExp(/abc/ as Object | null))
  suite.test('isRegExp("abc")', (): boolean => !isRegExp('abc' as Object | null))

  suite.test('isSafeInteger(3)', (): boolean => isSafeInteger(3 as Object | null))
  suite.test('isSafeInteger(MAX)', (): boolean => isSafeInteger(Number.MAX_SAFE_INTEGER as Object | null))

  suite.test('isSet(new Set)', (): boolean => isSet(new Set<Object>() as Object | null))

  suite.test('isString("abc")', (): boolean => isString('abc' as Object | null))
  suite.test('isString(1)', (): boolean => !isString(1 as Object | null))

  suite.test('isTypedArray Uint8Array', (): boolean => {
    const arr: Uint8Array = new Uint8Array(2)
    return isTypedArray(arr as Object | null)
  })
  suite.test('isTypedArray []', (): boolean => !isTypedArray(emptyArr as Object | null))

  suite.test('isUndefined(null)', (): boolean => !isUndefined(null))

  // -- NaN check --
  suite.test('isNaN(NaN)', (): boolean => {
    const nan: number = 0 / 0
    return isNaNCheck(nan as Object | null)
  })
  suite.test('isNaN(3)', (): boolean => !isNaNCheck(3 as Object | null))

  // -- Equality --
  suite.test('eq same', (): boolean => eq(1 as Object, 1 as Object))
  suite.test('eq NaN==NaN', (): boolean => {
    const nan: number = 0 / 0
    return eq(nan as Object, nan as Object)
  })

  suite.test('gt', (): boolean => gt(5 as Object, 3 as Object))
  suite.test('gt false', (): boolean => !gt(3 as Object, 5 as Object))

  suite.test('gte', (): boolean => gte(5 as Object, 5 as Object))
  suite.test('lt', (): boolean => lt(1 as Object, 3 as Object))
  suite.test('lte', (): boolean => lte(3 as Object, 3 as Object))

  // -- Deep Equality --
  suite.test('isEqual same arrays', (): boolean => isEqual([1, 2, 3] as Object, [1, 2, 3] as Object))
  suite.test('isEqual diff arrays', (): boolean => !isEqual([1, 2] as Object, [1, 3] as Object))
  suite.test('isEqual null', (): boolean => isEqual(null, null))

  // -- isMatch --
  suite.test('isMatch', (): boolean => {
    const obj: Map<string, Object> = new Map<string, Object>()
    obj.set('a', 1 as Object)
    obj.set('b', 2 as Object)
    const src: Map<string, Object> = new Map<string, Object>()
    src.set('a', 1 as Object)
    return isMatch(obj, src)
  })

  // -- Stubs --
  suite.test('stubArray', (): boolean => stubArray().length === 0)
  suite.test('stubFalse', (): boolean => stubFalse() === false)
  suite.test('stubTrue', (): boolean => stubTrue() === true)
  suite.test('stubString', (): boolean => stubString() === '')
  suite.test('stubObject empty', (): boolean => {
    const result: Record<string, Object> = stubObject()
    return Object.keys(result).length === 0
  })
}
