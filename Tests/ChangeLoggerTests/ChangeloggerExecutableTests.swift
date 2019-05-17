import XCTest
import Path

final class ChangeloggerExecutableTests: XCTestCase {
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
      let actualOutput = try TestableExecutable.run("changelogger", using: [String]())

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

  func testMarkdownNoArguments() {
    do {
      try ChangeloggerExecutableTests.logYAML.write(to: Path.cwd / ".changelog/changelog.yml")

      let actualOutput = try TestableExecutable.run("changelogger", using: ["markdown"])

      // swiftformat:disable consecutiveBlankLines
      let expectedOutput =
        """
        Wring CHANGELOG markdown
        ### Changelogger Changelog

        All notable changes to this project will be documented in this file.

        * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
        * This project adheres to [Semantic Versioning](http://semver.org/).

        #### [unreleased] - 2019-May-16.
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
      XCTAssertTrue((Path.cwd / "commit.yml").exists)
      XCTAssertTrue((Path.cwd / ".changelog/changelog.yml").exists)

    } catch {
      XCTFail("\(error)")
    }
  }
}
