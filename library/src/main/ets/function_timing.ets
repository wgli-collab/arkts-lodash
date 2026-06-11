/**
 * ArkTS Lodash — Timing Functions
 * Uses HarmonyOS setTimeout/clearTimeout API.
 * All callbacks use arrow functions (no Function.apply/.call/.bind — R9).
 */

export function debounce(
  func: (...args: Array<Object>) => Object,
  wait: number,
  options?: Record<string, Object>
): (...args: Array<Object>) => Object | undefined {
  let timerId: number | undefined = undefined
  let lastArgs: Array<Object> | undefined = undefined
  let result: Object | undefined = undefined
  let lastInvokeTime: number = 0
  const leading: boolean = options !== undefined && options.leading === true
  const trailing: boolean = options === undefined || options.trailing !== false
  const maxWait: number | undefined = options !== undefined ? options.maxWait as number : undefined

  const invokeFunc: () => Object = (): Object => {
    const args: Array<Object> = lastArgs as Array<Object>
    lastArgs = undefined
    lastInvokeTime = Date.now()
    result = func(...args)
    return result as Object
  }

  const debounced: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    lastArgs = args
    if (timerId === undefined && leading) {
      invokeFunc()
    }
    if (timerId !== undefined) {
      clearTimeout(timerId)
    }
    // maxWait: force invoke if maxWait elapsed since last invoke
    if (maxWait !== undefined) {
      const now: number = Date.now()
      if (now - lastInvokeTime >= maxWait) {
        invokeFunc()
      }
    }
    timerId = setTimeout((): void => {
      timerId = undefined
      if (trailing && lastArgs !== undefined) {
        invokeFunc()
      }
    }, wait)
    return result
  }

  return debounced
}

export function throttle(
  func: (...args: Array<Object>) => Object,
  wait: number,
  options?: Record<string, Object>
): (...args: Array<Object>) => Object | undefined {
  const leading: boolean = options !== undefined && options.leading === true
  const trailing: boolean = options === undefined || options.trailing !== false

  let timerId: number | undefined = undefined
  let lastArgs: Array<Object> | undefined = undefined
  let result: Object | undefined = undefined

  const invokeFunc: () => void = (): void => {
    const args: Array<Object> = lastArgs as Array<Object>
    lastArgs = undefined
    timerId = undefined
    result = func(...args)
  }

  const throttled: (...args: Array<Object>) => Object | undefined = (...args: Array<Object>): Object | undefined => {
    lastArgs = args
    if (timerId === undefined) {
      if (leading) {
        invokeFunc()
      }
      timerId = setTimeout((): void => {
        if (trailing && lastArgs !== undefined) {
          invokeFunc()
        } else {
          timerId = undefined
        }
      }, wait)
    }
    return result
  }

  return throttled
}

export function defer(func: (...args: Array<Object>) => void, ...args: Array<Object>): number {
  return setTimeout((): void => {
    func(...args)
  }, 1)
}

export function delay(func: (...args: Array<Object>) => void, wait: number, ...args: Array<Object>): number {
  return setTimeout((): void => {
    func(...args)
  }, wait)
}
