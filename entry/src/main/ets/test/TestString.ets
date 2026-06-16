/**
 * Test Suite: String operations
 */
import { camelCase, capitalize, kebabCase, snakeCase, lowerCase, lowerFirst, upperCase, upperFirst } from 'library'
import { pad, padEnd, padStart, repeat, trim, trimEnd, trimStart, truncate, words } from 'library'
import { escape, escapeRegExp, unescape } from 'library'
import { TestSuite } from './TestRunner'

export function runStringTests(suite: TestSuite): void {
  // -- Case --
  suite.test('camelCase', (): boolean => camelCase('Foo Bar') === 'fooBar')
  suite.test('camelCase hyphen', (): boolean => camelCase('--foo-bar--') === 'fooBar')
  suite.test('camelCase snake', (): boolean => camelCase('__foo_bar__') === 'fooBar')

  suite.test('capitalize', (): boolean => capitalize('fred') === 'Fred')
  suite.test('capitalize uppercase', (): boolean => capitalize('FRED') === 'Fred')

  suite.test('kebabCase', (): boolean => kebabCase('Foo Bar') === 'foo-bar')
  suite.test('kebabCase camel', (): boolean => kebabCase('fooBar') === 'foo-bar')

  suite.test('snakeCase', (): boolean => snakeCase('Foo Bar') === 'foo_bar')
  suite.test('snakeCase camel', (): boolean => snakeCase('fooBar') === 'foo_bar')

  suite.test('lowerCase', (): boolean => lowerCase('--Foo-Bar--') === 'foo bar')
  suite.test('lowerFirst', (): boolean => lowerFirst('Fred') === 'fred')
  suite.test('upperCase', (): boolean => upperCase('--foo-bar--') === 'FOO BAR')
  suite.test('upperFirst', (): boolean => upperFirst('fred') === 'Fred')

  // -- Manipulation --
  suite.test('pad', (): boolean => pad('abc', 8) === '  abc   ')
  suite.test('pad shorter', (): boolean => pad('abc', 2) === 'abc')

  suite.test('padEnd', (): boolean => padEnd('abc', 6) === 'abc   ')
  suite.test('padStart', (): boolean => padStart('abc', 6) === '   abc')

  suite.test('repeat', (): boolean => repeat('*', 3) === '***')
  suite.test('repeat 0', (): boolean => repeat('abc', 0) === '')

  suite.test('trim', (): boolean => trim('  abc  ') === 'abc')
  suite.test('trimEnd', (): boolean => trimEnd('  abc  ') === '  abc')
  suite.test('trimStart', (): boolean => trimStart('  abc  ') === 'abc  ')

  suite.test('truncate', (): boolean => {
    const result: string = truncate('hi-diddly-ho there, neighborino')
    return result.length <= 33 // default length 30 + omission
  })

  suite.test('words', (): boolean => {
    const result: Array<string> = words('fred, barney, & pebbles')
    return result.length === 3 // & is excluded by default unicode regex
  })
  suite.test('words pattern', (): boolean => {
    const result: Array<string> = words('fred, barney, & pebbles', /[^, ]+/g)
    return result.length === 4
  })

  // -- Escape --
  suite.test('escape', (): boolean => escape('fred, barney, & pebbles').indexOf('&amp;') >= 0)
  suite.test('unescape', (): boolean => unescape('fred, barney, &amp; pebbles').indexOf('&amp;') < 0)
  suite.test('escapeRegExp', (): boolean => escapeRegExp('[lodash](https://lodash.com/)').indexOf('\\[') >= 0)
}
