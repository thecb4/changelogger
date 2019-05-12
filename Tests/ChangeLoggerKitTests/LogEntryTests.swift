import XCTest
import ChangeLoggerKit
import Yams

final class LogEntryTests: XCTestCase {
  func testDefaultPathEmptyLogEntry() {
    let expectedVersion = LogEntry.unreleasedVersion
    let maxTimeIntervalForLogEntryDateFromNow = 2.0

    do {
      let commitEntry = try CommitEntry.current()
      let logEntry = LogEntry(from: commitEntry)

      XCTAssertEqual(logEntry.version, expectedVersion)
      XCTAssertEqual(logEntry.commit, commitEntry)
      XCTAssertTrue(logEntry.date.timeIntervalSinceNow < maxTimeIntervalForLogEntryDateFromNow)

    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as LogEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }

  func testTestFixturePathNotEmptyEntryNoError() {
    let expectedVersion = LogEntry.unreleasedVersion
    let maxTimeIntervalForLogEntryDateFromNow = 2.0

    do {
      let commitEntry = try CommitEntry.current(from: CommitEntry.testNotEmptyEntryPath.string)
      let logEntry = LogEntry(from: commitEntry)

      XCTAssertEqual(logEntry.version, expectedVersion)
      XCTAssertEqual(logEntry.commit, commitEntry)
      XCTAssertTrue(logEntry.date.timeIntervalSinceNow < maxTimeIntervalForLogEntryDateFromNow)

    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as LogEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }

  func testTestFixturePathNotEmptyEntryNoErrorMarkdown() {
    do {
      let commitEntry = try CommitEntry.current(from: CommitEntry.testNotEmptyEntryPath.string)
      let logEntry = LogEntry(from: commitEntry)

      // must use YAMS date format because it doesn't provide for changing
      let expectedDateString = logEntry.date.iso8601StringWithFullNanosecond

      let expectedMarkdown =
        """
        #### [unreleased] - \(expectedDateString).
        #### Added
        - Some new feature

        #### Changed
        -

        #### Deprecated
        -

        #### Removed
        -

        #### Fixed
        -

        #### Security
        -

        """

      let actualMarkdown = logEntry.markdown

      XCTAssertEqual(actualMarkdown, expectedMarkdown)

    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }
}
