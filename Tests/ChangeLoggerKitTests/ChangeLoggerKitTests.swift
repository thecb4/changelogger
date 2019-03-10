import XCTest
import ChangeLoggerKit
import Yams

final class MissiveKitTests: XCTestCase {
  func testCompiles() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.

    XCTAssertEqual(ChangeLog.changelogYAMLPath, FileManager.default.currentDirectoryPath + "/.changelog/changelog.yaml")

    XCTAssertEqual(ChangeLog.commitYAMLPath, FileManager.default.currentDirectoryPath + "/commit.yaml")

    XCTAssertEqual(ChangeLog.changelogMarkdownPath, FileManager.default.currentDirectoryPath + "/CHANGELOG.md")
  }

  static var allTests = [
    ("testCompiles", testCompiles)
  ]
}
