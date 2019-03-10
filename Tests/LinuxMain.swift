import XCTest

import ChangeLoggerTests
import ChangeLoggerKitTests

var tests = [XCTestCaseEntry]()
tests += ChangeLoggerTests.allTests()
tests += ChangeLoggerKitTests.allTests()
XCTMain(tests)
