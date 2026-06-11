/**
 * ArkTS Lodash — Shared Type Definitions
 * Target: HarmonyOS SDK 6.1.1(24), ArkTS strict mode
 */

// ---- Callback Types ----

/** Standard iteratee: (value, index, collection) => result */
export type ValueCallback<T, R> = (value: T, index: number, collection: Array<T>) => R

/** Comparator function: returns negative, 0, or positive */
export type Comparator<T> = (a: T, b: T) => number

// ---- Path & Property Types ----

/** Property path: dot-separated string or array of keys */
export type Path = string | Array<number>

/** Valid property name */
export type PropertyName = string | number

/** A value or array of values */
export type Many<T> = T | Array<T>

// ---- Object Types ----

/** Generic plain-object mapping string keys to values of type T */
export type PlainObject<T> = Record<string, T>

// ---- Utility Types ----

/** Represents any non-undefined, non-void value (used in defaultTo, isEmpty etc.) */
export type NotVoid = string | number | boolean | bigint | null | Array<Object> | Record<string, Object>
