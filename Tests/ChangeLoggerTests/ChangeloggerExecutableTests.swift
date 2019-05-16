import XCTest
import Path

final class ChangeloggerExecutableTests: XCTestCase {
  func testRunNoArguments() {
    do {
      let actualOutput = try TestableExecutable.run("changelogger", using: [String]())

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        OVERVIEW: Take control of your changelogs


        USAGE: changelogger <command> <options>

        SUBCOMMANDS:
          init                    initialize directory for changelogger

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)

    } catch {
      XCTFail("\(error)")
    }
  }

  func testInitNoArguments() {
    do {
      let actualOutput = try TestableExecutable.run("changelogger", using: ["init"])

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        initializing directory for changelog management
        commit file: /Users/cavellebenjamin/Development/toolbox/ChangeLogger/commit.yml
        changelog file: /Users/cavellebenjamin/Development/toolbox/ChangeLogger/.changelog/changelog.yml

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)
      XCTAssertTrue((Path.cwd / "commit.yml").exists)
      XCTAssertTrue((Path.cwd / ".changelog/changelog.yml").exists)

    } catch {
      XCTFail("\(error)")
    }
  }

  func testInitWithArguments() {
    do {
      let actualOutput = try TestableExecutable.run(
        "changelogger",
        using: [
          "init",
          "--commit-file", "Tests/fixtures/executable/commit.yml",
          "--log-entry-file", "Tests/fixtures/executable/.changelog/changelog.yml"
        ]
      )

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        initializing directory for changelog management
        commit file: /Users/cavellebenjamin/Development/toolbox/ChangeLogger/Tests/fixtures/executable/commit.yml
        changelog file: /Users/cavellebenjamin/Development/toolbox/ChangeLogger/Tests/fixtures/executable/.changelog/changelog.yml

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)
      XCTAssertTrue((Path.cwd / "Tests/fixtures/executable/commit.yml").exists)
      XCTAssertTrue((Path.cwd / "Tests/fixtures/executable/.changelog/changelog.yml").exists)

    } catch {
      XCTFail("\(error)")
    }
  }
}
