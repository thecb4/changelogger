import XCTest
import ChangeLoggerKit
import Yams

final class CommitEntryTests: XCTestCase {
  func testCommitEntryFilePaths() {
    // commit entry file and paths
    XCTAssertEqual(CommitEntry.file, "commit.yml")
    XCTAssertEqual(CommitEntry.defaultCommitFilePath.string, FileManager.default.currentDirectoryPath + "/commit.yml")
    XCTAssertEqual(CommitEntry.commitFilePath.string, FileManager.default.currentDirectoryPath + "/commit.yml")
  }

  func testCommitDefaultPathEmptyEntryNoError() {
    do {
      _ = try CommitEntry.current()
    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }

  func testCommitTestFixturePathEmptyEntryNoError() {
    do {
      _ = try CommitEntry.current(from: CommitEntry.testEmptyEntryPath.string)
    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }

  func testCommitTestFixturePathNotEmptyEntryNoError() {
    do {
      _ = try CommitEntry.current(from: CommitEntry.testNotEmptyEntryPath.string)
    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }
}
