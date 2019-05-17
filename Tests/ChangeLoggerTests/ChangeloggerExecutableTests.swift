import XCTest
import Path

final class ChangeloggerExecutableTests: XCTestCase {
  public static let changelogDateFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MMM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()

  static let testFolderPath = Path.cwd / "Tests/fixtures/executable"
  static let testFolderCustomPath = Path.cwd / "Tests/fixtures/custom-path"

  static let logYAML =
    """
    title: Changelogger Changelog
    logs:
    - version: unreleased
      date: 2019-05-16T23:08:50.770277976Z
      commit:
        summary: Fixing workflow
        added:
        - Some new feature
        changed: []
        deprecated: []
        removed: []
        fixed: []
        security: []
    - version: unreleased
      date: 2019-05-12T23:25:07.905285954Z
      commit:
        summary: Feature flags
        added:
        - Feature flag all the things
        changed: []
        deprecated: []
        removed: []
        fixed: []
        security: []
    - version: unreleased
      date: 2019-05-12T19:57:00.496031045Z
      commit:
        summary: Fixed a bunch of workflow stuff
        added:
        - Some new feature
        changed: []
        deprecated: []
        removed: []
        fixed: []
        security: []

    """

  func testRunNoArguments() {
    do {
      let actualOutput = try TestableExecutable.run(
        "changelogger",
        using: [String](),
        workingDirectory: ChangeloggerExecutableTests.testFolderPath
      )

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        OVERVIEW: Take control of your changelogs


        USAGE: changelogger <command> <options>

        SUBCOMMANDS:
          init                    initialize directory for changelogger
          markdown                Write CHANGELOG markdown

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
      let actualOutput = try TestableExecutable.run(
        "changelogger",
        using: ["init"],
        workingDirectory: ChangeloggerExecutableTests.testFolderPath
      )

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        initializing directory for changelog management
        commit file: \(ChangeloggerExecutableTests.testFolderPath.string)/commit.yml
        changelog file: \(ChangeloggerExecutableTests.testFolderPath.string)/.changelog/changelog.yml

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderPath / "commit.yml").exists)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderPath / ".changelog/changelog.yml").exists)

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
          "--commit-file", "Tests/fixtures/custom-path/commit.yml",
          "--log-entry-file", "Tests/fixtures/custom-path/.changelog/changelog.yml"
        ],
        workingDirectory: Path.cwd
      )

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        initializing directory for changelog management
        commit file: \(ChangeloggerExecutableTests.testFolderCustomPath.string)/commit.yml
        changelog file: \(ChangeloggerExecutableTests.testFolderCustomPath.string)/.changelog/changelog.yml

        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderCustomPath / "commit.yml").exists)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderCustomPath / ".changelog/changelog.yml").exists)

    } catch {
      XCTFail("\(error)")
    }
  }

  func testMarkdownNoArguments() {
    do {
      let loggingFile = Path.cwd / "Tests/fixtures/executable/.changelog/changelog.yml"

      try ChangeloggerExecutableTests.logYAML.write(to: loggingFile)

      let actualOutput = try TestableExecutable.run(
        "changelogger",
        using: ["markdown"],
        workingDirectory: ChangeloggerExecutableTests.testFolderPath
      )

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        Wring CHANGELOG markdown
        ### Changelogger Changelog

        All notable changes to this project will be documented in this file.

        * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
        * This project adheres to [Semantic Versioning](http://semver.org/).

        #### [unreleased] - \(ChangeloggerExecutableTests.changelogDateFormatter.string(from: Date())).
        ##### Added
        - Some new feature
        - Feature flag all the things
        - Some new feature

        ##### Changed
        -

        ##### Deprecated
        -

        ##### Removed
        -

        ##### Fixed
        -

        ##### Security
        -




        """
      // swiftformat:enable consecutiveBlankLines

      // then
      XCTAssertEqual(actualOutput, expectedOutput)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderPath / "commit.yml").exists)
      XCTAssertTrue((ChangeloggerExecutableTests.testFolderPath / ".changelog/changelog.yml").exists)

    } catch {
      XCTFail("\(error)")
    }
  }
}
