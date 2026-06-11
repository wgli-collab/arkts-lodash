/**
 * Test runner page — runs all 8 test suites on app launch.
 */
import { TestSuite } from '../test/TestRunner'
import { runMathTests } from '../test/TestMath'
import { runLangTests } from '../test/TestLang'
import { runStringTests } from '../test/TestString'
import { runArrayTests } from '../test/TestArray'
import { runCollectionTests } from '../test/TestCollection'
import { runFunctionTests } from '../test/TestFunction'
import { runObjectTests } from '../test/TestObject'
import { runUtilTests } from '../test/TestUtil'

class SuiteItem {
  suite: TestSuite
  totalTests: number
  totalPassed: number

  constructor(suite: TestSuite) {
    this.suite = suite
    this.totalTests = suite.totalCount()
    this.totalPassed = suite.passedCount()
  }
}

@Entry
@Component
struct Index {
  @State message: string = ''
  @State passCount: number = 0
  @State totalCount: number = 0

  aboutToAppear(): void {
    // Run all test suites
    const suites: Array<TestSuite> = new Array<TestSuite>()

    const math: TestSuite = new TestSuite('Math')
    runMathTests(math)
    suites.push(math)

    const lang: TestSuite = new TestSuite('Lang')
    runLangTests(lang)
    suites.push(lang)

    const str: TestSuite = new TestSuite('String')
    runStringTests(str)
    suites.push(str)

    const arr: TestSuite = new TestSuite('Array')
    runArrayTests(arr)
    suites.push(arr)

    const col: TestSuite = new TestSuite('Collection')
    runCollectionTests(col)
    suites.push(col)

    const fnSuite: TestSuite = new TestSuite('Function')
    runFunctionTests(fnSuite)
    suites.push(fnSuite)

    const obj: TestSuite = new TestSuite('Object')
    runObjectTests(obj)
    suites.push(obj)

    const util: TestSuite = new TestSuite('Util')
    runUtilTests(util)
    suites.push(util)

    // Aggregate results
    let totalPassed: number = 0
    let totalAll: number = 0
    const lines: Array<string> = new Array<string>()

    for (let i: number = 0; i < suites.length; i++) {
      const s: TestSuite = suites[i]
      totalPassed += s.passedCount()
      totalAll += s.totalCount()
      const status: string = s.passedCount() === s.totalCount() ? 'OK' : 'FAIL'
      lines.push(status + '  ' + s.summary())

      // Show failures
      const failed: Array<string> = s.failedTests()
      for (let j: number = 0; j < failed.length; j++) {
        lines.push('       FAIL: ' + failed[j])
      }
    }

    lines.push('')
    lines.push('TOTAL: ' + totalPassed + '/' + totalAll + ' passed')

    this.message = lines.join('\n')
    this.passCount = totalPassed
    this.totalCount = totalAll
  }

  build(): void {
    Column() {
      Text('ArkTS Lodash — Test Results')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 12 })

      Text(this.message)
        .fontSize(14)
        .fontColor(this.passCount === this.totalCount ? '#4CAF50' : '#F44336')
        .width('100%')
        .padding(12)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .justifyContent(FlexAlign.Start)
  }
}
