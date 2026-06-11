/**
 * ArkTS Lodash — String Escaping Functions
 */

const htmlEscapes: Map<string, string> = new Map<string, string>([
  ['&', '&amp;'],
  ['<', '&lt;'],
  ['>', '&gt;'],
  ['"', '&quot;'],
  ["'", '&#39;']
])

const htmlUnescapes: Map<string, string> = new Map<string, string>([
  ['&amp;', '&'],
  ['&lt;', '<'],
  ['&gt;', '>'],
  ['&quot;', '"'],
  ['&#39;', "'"]
])

export function escape(str: string): string {
  let result: string = ''
  for (let i: number = 0; i < str.length; i++) {
    const ch: string = str.charAt(i)
    const escaped: string | undefined = htmlEscapes.get(ch)
    result += escaped !== undefined ? escaped : ch
  }
  return result
}

export function escapeRegExp(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

export function unescape(str: string): string {
  const reEscapedHtml: RegExp = /&(?:amp|lt|gt|quot|#39);/g
  return str.replace(reEscapedHtml, (entity: string): string => {
    const unescaped: string | undefined = htmlUnescapes.get(entity)
    return unescaped !== undefined ? unescaped : entity
  })
}
