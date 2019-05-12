import XCTest

import ChangeLoggerKitTests
import ChangeLoggerTests

var tests = [XCTestCaseEntry]()
tests += ChangeLoggerKitTests.__allTests()
tests += ChangeLoggerTests.__allTests()

XCTMain(tests)
