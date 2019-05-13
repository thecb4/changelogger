import XCTest

final class ChangeloggerExecutableTests: XCTestCase {
  func testRunNoArguments() {
    do {
      let actualOutput = try TestableExecutable.run("changelogger", using: [String]())

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        OVERVIEW: Take control of your changelogs


        USAGE: changelogger <command> <options>

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)

    } catch {
      XCTFail("\(error)")
    }
  }

  func testInit() {}
}
