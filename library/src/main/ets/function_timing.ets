/**
 * ArkTS Lodash — Timing Functions
 * Uses HarmonyOS setTimeout/clearTimeout API.
 * All callbacks use arrow functions (no Function.apply/.call/.bind — R9).
 *
 * Note: ArkTS strict mode cannot attach .cancel()/.flush() to function objects (R5).
 * Use the standalone `cancelDebounce`/`flushDebounce`/`cancelThrottle`/`flushThrottle`
 * helpers instead. They accept the function returned by `debounce()`/`throttle()`.
 */

// Registry: maps debounced/throttled function → { cancel, flush } handlers
const debounceHandlers: Map<Object, Object> = new Map()
const throttleHandlers: Map<Object, Object> = new Map()

export function cancelDebounce(debounced: (...args: Array<Object>) => Object | undefined): void {
  const handler: Object | undefined = debounceHandlers.get(debounced as Object)
  if (handler !== undefined) {
    const cancelFn: () => void = (handler as Record<string, Object>).cancel as () => void
    cancelFn()
    debounceHandlers.delete(debounced as Object)
  }
}

export function flushDebounce(debounced: (...args: Array<Object>) => Object | undefined): Object | undefined {
  const handler: Object | undefined = debounceHandlers.get(debounced as Object)
  if (handler !== undefined) {
    const flushFn: () => Object | undefined = (handler as Record<string, Object>).flush as () => Object | undefined
    return flushFn()
  }
  return undefined
}

export function cancelThrottle(throttled: (...args: Array<Object>) => Object | undefined): void {
  const handler: Object | undefined = throttleHandlers.get(throttled as Object)
  if (handler !== undefined) {
    const cancelFn: () => void = (handler as Record<string, Object>).cancel as () => void
    cancelFn()
    throttleHandlers.delete(throttled as Object)
  }
}

export function flushThrottle(throttled: (...args: Array<Object>) => Object | undefined): Object | undefined {
  const handler: Object | undefined = throttleHandlers.get(throttled as Object)
  if (handler !== undefined) {
    const flushFn: () => Object | undefined = (handler as Record<string, Object>).flush as () => Object | undefined
    return flushFn()
  }
  return undefined
}

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

  const cancel: () => void = (): void => {
    if (timerId !== undefined) {
      clearTimeout(timerId)
      timerId = undefined
    }
    lastArgs = undefined
  }

  const flush: () => Object | undefined = (): Object | undefined => {
    if (timerId !== undefined && lastArgs !== undefined) {
      clearTimeout(timerId)
      timerId = undefined
      return invokeFunc()
    }
    return undefined
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

  const handler: Record<string, Object> = {
    'cancel': cancel,
    'flush': flush
  }
  debounceHandlers.set(debounced as Object, handler)

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

  const cancel: () => void = (): void => {
    if (timerId !== undefined) {
      clearTimeout(timerId)
      timerId = undefined
    }
    lastArgs = undefined
  }

  const flush: () => Object | undefined = (): Object | undefined => {
    if (timerId !== undefined && lastArgs !== undefined) {
      clearTimeout(timerId)
      timerId = undefined
      invokeFunc()
      return result
    }
    return undefined
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

  const handler: Record<string, Object> = {
    'cancel': cancel,
    'flush': flush
  }
  throttleHandlers.set(throttled as Object, handler)

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
