/**
 * ArkTS Lodash — String Case Utilities
 */

/** Unicode word boundary pattern for case conversion */
const reWords: RegExp = /[A-Z\xc0-\xd6\xd8-\xde]?[a-z\xdf-\xf6\xf8-\xff]+|[A-Z\xc0-\xd6\xd8-\xde]+(?![a-z\xdf-\xf6\xf8-\xff])|\d+/g

/** Pattern for detecting uppercase letters */
const reUpper: RegExp = /[A-Z]/g

function wordsToCase(str: string, delimiter: string, upperFirst: boolean): string {
  const words: Array<string> = []
  let match: Array<string> | null = reWords.exec(str)
  while (match !== null) {
    words.push(match[0])
    match = reWords.exec(str)
  }
  if (words.length === 0) {
    return ''
  }
  const result: Array<string> = []
  for (let i: number = 0; i < words.length; i++) {
    let w: string = words[i]
    if (upperFirst) {
      w = w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
    } else {
      w = w.toLowerCase()
    }
    result.push(w)
  }
  return result.join(delimiter)
}

export function camelCase(str: string): string {
  const words: Array<string> = []
  let match: Array<string> | null = reWords.exec(str)
  while (match !== null) {
    words.push(match[0])
    match = reWords.exec(str)
  }
  if (words.length === 0) {
    return ''
  }
  let result: string = words[0].toLowerCase()
  for (let i: number = 1; i < words.length; i++) {
    const w: string = words[i]
    result += w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
  }
  return result
}

export function capitalize(str: string): string {
  if (str.length === 0) {
    return ''
  }
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase()
}

export function kebabCase(str: string): string {
  return wordsToCase(str, '-', false)
}

export function lowerCase(str: string): string {
  return wordsToCase(str, ' ', false)
}

export function lowerFirst(str: string): string {
  if (str.length === 0) {
    return ''
  }
  return str.charAt(0).toLowerCase() + str.slice(1)
}

export function snakeCase(str: string): string {
  return wordsToCase(str, '_', false)
}

export function startCase(str: string): string {
  return wordsToCase(str, ' ', true)
}

export function upperCase(str: string): string {
  return wordsToCase(str, ' ', false).toUpperCase()
}

export function upperFirst(str: string): string {
  if (str.length === 0) {
    return ''
  }
  return str.charAt(0).toUpperCase() + str.slice(1)
}

/** Deburs diacritics — simplified Latin-only mapping */
const deburrMap: Map<string, string> = new Map<string, string>([
  ['\xc0', 'A'], ['\xc1', 'A'], ['\xc2', 'A'], ['\xc3', 'A'], ['\xc4', 'A'], ['\xc5', 'A'],
  ['\xe0', 'a'], ['\xe1', 'a'], ['\xe2', 'a'], ['\xe3', 'a'], ['\xe4', 'a'], ['\xe5', 'a'],
  ['\xc7', 'C'], ['\xe7', 'c'],
  ['\xc8', 'E'], ['\xc9', 'E'], ['\xca', 'E'], ['\xcb', 'E'],
  ['\xe8', 'e'], ['\xe9', 'e'], ['\xea', 'e'], ['\xeb', 'e'],
  ['\xcc', 'I'], ['\xcd', 'I'], ['\xce', 'I'], ['\xcf', 'I'],
  ['\xec', 'i'], ['\xed', 'i'], ['\xee', 'i'], ['\xef', 'i'],
  ['\xd1', 'N'], ['\xf1', 'n'],
  ['\xd2', 'O'], ['\xd3', 'O'], ['\xd4', 'O'], ['\xd5', 'O'], ['\xd6', 'O'],
  ['\xf2', 'o'], ['\xf3', 'o'], ['\xf4', 'o'], ['\xf5', 'o'], ['\xf6', 'o'],
  ['\xd9', 'U'], ['\xda', 'U'], ['\xdb', 'U'], ['\xdc', 'U'],
  ['\xf9', 'u'], ['\xfa', 'u'], ['\xfb', 'u'], ['\xfc', 'u'],
  ['\xdd', 'Y'], ['\xfd', 'y'], ['\xff', 'y'],
  ['\xc6', 'AE'], ['\xe6', 'ae'],
  ['\xde', 'TH'], ['\xfe', 'th'],
  ['\xdf', 'ss']
])

export function deburr(str: string): string {
  let result: string = ''
  for (let i: number = 0; i < str.length; i++) {
    const ch: string = str.charAt(i)
    const replacement: string | undefined = deburrMap.get(ch)
    result += replacement !== undefined ? replacement : ch
  }
  return result
}

export function hasUnicodeWord(str: string): RegExpMatchArray | null {
  return str.match(reWords)
}
