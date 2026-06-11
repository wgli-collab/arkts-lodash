/**
 * Lightweight test framework for ArkTS
 * Uses classes (not interfaces) and avoids all strict-mode violations.
 */
export class TestResult {
  name: string
  passed: boolean
  message: string

  constructor(name: string, passed: boolean, message: string) {
    this.name = name
    this.passed = passed
    this.message = message
  }
}

export class TestSuite {
  name: string
  results: Array<TestResult>

  constructor(name: string) {
    this.name = name
    this.results = new Array<TestResult>()
  }

  test(name: string, fn: () => boolean, msg?: string): void {
    try {
      const passed: boolean = fn()
      this.results.push(new TestResult(name, passed, msg ?? ''))
    } catch (e) {
      const errMsg: string = e instanceof Error ? (e as Error).message : 'unknown error'
      this.results.push(new TestResult(name, false, msg ?? ''))
    }
  }

  passedCount(): number {
    let count: number = 0
    for (let i: number = 0; i < this.results.length; i++) {
      if (this.results[i].passed) {
        count++
      }
    }
    return count
  }

  totalCount(): number {
    return this.results.length
  }

  failedTests(): Array<string> {
    const failed: Array<string> = new Array<string>()
    for (let i: number = 0; i < this.results.length; i++) {
      if (!this.results[i].passed) {
        failed.push(this.results[i].name)
      }
    }
    return failed
  }

  summary(): string {
    return this.name + ': ' + this.passedCount() + '/' + this.totalCount() + ' passed'
  }
}
