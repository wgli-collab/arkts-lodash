/**
 * ArkTS Lodash — String Manipulation Functions
 */

import { escapeRegExp } from './string_escape'

export function endsWith(str: string, target: string, position?: number): boolean {
  const end: number = position !== undefined ? position : str.length
  const start: number = end - target.length
  return start >= 0 && str.slice(start, end) === target
}

export function startsWith(str: string, target: string, position?: number): boolean {
  const pos: number = position !== undefined ? position : 0
  return str.slice(pos, pos + target.length) === target
}

export function pad(str: string, length: number, chars?: string): string {
  const padChar: string = chars !== undefined && chars.length > 0 ? chars : ' '
  const padLen: number = length - str.length
  if (padLen <= 0) {
    return str
  }
  const leftPad: number = Math.floor(padLen / 2)
  const rightPad: number = padLen - leftPad
  return createPadding(padChar, leftPad) + str + createPadding(padChar, rightPad)
}

export function padEnd(str: string, length: number, chars?: string): string {
  const padChar: string = chars !== undefined && chars.length > 0 ? chars : ' '
  const padLen: number = length - str.length
  if (padLen <= 0) {
    return str
  }
  return str + createPadding(padChar, padLen)
}

export function padStart(str: string, length: number, chars?: string): string {
  const padChar: string = chars !== undefined && chars.length > 0 ? chars : ' '
  const padLen: number = length - str.length
  if (padLen <= 0) {
    return str
  }
  return createPadding(padChar, padLen) + str
}

function createPadding(chars: string, length: number): string {
  if (length <= 0) {
    return ''
  }
  let result: string = ''
  while (result.length < length) {
    result += chars
  }
  return result.slice(0, length)
}

export function repeat(str: string, n: number): string {
  if (n <= 0) {
    return ''
  }
  let result: string = ''
  for (let i: number = 0; i < n; i++) {
    result += str
  }
  return result
}

export function replace(
  str: string,
  pattern: string | RegExp,
  replacement: string | ((match: string, ...args: Array<string>) => string)
): string {
  if (typeof replacement === 'function') {
    return str.replace(pattern as RegExp, replacement as (substring: string, ...args: Array<Object>) => string)
  }
  return str.replace(pattern as RegExp, replacement)
}

export function split(str: string, separator: string | RegExp, limit?: number): Array<string> {
  return str.split(separator, limit)
}

export function trim(str: string, chars?: string): string {
  if (chars === undefined || chars.length === 0) {
    return str.trim()
  }
  const escaped: string = escapeRegExp(chars)
  const pattern: RegExp = new RegExp('^[' + escaped + ']+|[' + escaped + ']+$', 'g')
  return str.replace(pattern, '')
}

export function trimEnd(str: string, chars?: string): string {
  if (chars === undefined || chars.length === 0) {
    return str.trimEnd()
  }
  const escaped: string = escapeRegExp(chars)
  const pattern: RegExp = new RegExp('[' + escaped + ']+$', 'g')
  return str.replace(pattern, '')
}

export function trimStart(str: string, chars?: string): string {
  if (chars === undefined || chars.length === 0) {
    return str.trimStart()
  }
  const escaped: string = escapeRegExp(chars)
  const pattern: RegExp = new RegExp('^[' + escaped + ']+', 'g')
  return str.replace(pattern, '')
}

export function truncate(str: string, options?: Record<string, Object>): string {
  const effectiveLength: number = options !== undefined && options.length !== undefined
    ? options.length as number : 30
  const effectiveOmission: string = options !== undefined && options.omission !== undefined
    ? options.omission as string : '...'
  const separator: string | RegExp | undefined = options !== undefined
    ? options.separator as (string | RegExp | undefined) : undefined

  if (str.length <= effectiveLength) {
    return str
  }
  const end: number = effectiveLength - effectiveOmission.length
  if (end < 0) {
    return effectiveOmission
  }
  let result: string = str.slice(0, end)
  if (separator !== undefined && separator !== '') {
    const sepPattern: RegExp = typeof separator === 'string'
      ? new RegExp(escapeRegExp(separator as string), 'g')
      : separator as RegExp
    const matches: Array<string> | null = result.match(sepPattern)
    if (matches !== null && matches.length > 0) {
      const lastMatch: string = matches[matches.length - 1]
      const lastIndex: number = result.lastIndexOf(lastMatch)
      if (lastIndex >= 0) {
        result = result.slice(0, lastIndex)
      }
    }
  }
  return result + effectiveOmission
}

export function words(str: string, pattern?: RegExp | string): Array<string> {
  if (pattern !== undefined) {
    const re: RegExp = typeof pattern === 'string' ? new RegExp(pattern as string, 'g') : pattern
    const result: Array<string> | null = str.match(re)
    return result !== null ? result : []
  }
  const unicodeWords: RegExp = /[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+/g
  const result: Array<string> | null = str.match(unicodeWords)
  return result !== null ? result : []
}

export function parseInt(str: string, radix?: number): number {
  return Number.parseInt(str, radix)
}

export function toLower(str: string): string {
  return str.toLowerCase()
}

export function toUpper(str: string): string {
  return str.toUpperCase()
}
