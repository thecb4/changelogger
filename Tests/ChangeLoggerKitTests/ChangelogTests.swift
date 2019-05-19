import XCTest
import ChangeLoggerKit
import Yams
import Path

final class ChangelogTests: XCTestCase {
  func testChangelogFilePaths() {
    // changelog files and paths
    XCTAssertEqual(Changelog.logEntryFile, "changelog.yml")
    XCTAssertEqual(Changelog.defaultLogEntryFilePath.string, FileManager.default.currentDirectoryPath + "/.changelog/changelog.yml")

    XCTAssertEqual(Changelog.changelogMarkdownFile, "CHANGELOG.md")
    XCTAssertEqual(Changelog.defaultChangelogMarkdownPath.string, FileManager.default.currentDirectoryPath + "/CHANGELOG.md")
  }

  func testCreateEmptyChangelog() {
    do {
      let expectedTitle = "Changelogger Changelog"

      // given
      let expectedYAML =
        """
        title: \(expectedTitle)
        logs: []

        """

      // when
      let changelog = Changelog(title: expectedTitle)
      let encoder = YAMLEncoder()
      let actualYAML = try encoder.encode(changelog)

      // then
      XCTAssertEqual(actualYAML, expectedYAML)

    } catch let error as CommitEntry.Error {
      XCTFail("\(error)")
    } catch let error as YamlError {
      XCTFail("\(error)")
    } catch {
      XCTFail("\(error)")
    }
  }

  func testCreateNotEmptyChangelog() {
    do {
      // given
      let expectedTitle = "Changelogger Changelog"
      let expectedCommitSummary = "Fixed a bunch of workflow stuff"
      let expectedAddedFeature = "Some new feature"

      // when
      let commitEntry = CommitEntry(
        summary: expectedCommitSummary,
        added: [expectedAddedFeature],
        changed: [String](),
        deprecated: [String](),
        removed: [String](),
        fixed: [String](),
        security: [String]()
      )
      let logEntry = LogEntry(from: commitEntry)

      // must use YAMS date format because it doesn't provide for changing
      let expectedDateString = logEntry.date.iso8601StringWithFullNanosecond

      let expectedYAML =
        """
        title: \(expectedTitle)
        logs:
        - version: unreleased
          date: \(expectedDateString)
          commit:
            summary: \(expectedCommitSummary)
            added:
            - \(expectedAddedFeature)
            changed: []
            deprecated: []
            removed: []
            fixed: []
            security: []

        """

      let changelog = Changelog(title: expectedTitle, logs: [logEntry])
      let encoder = YAMLEncoder()
      // https://useyourloaf.com/blog/swift-codable-with-custom-dates/
      // https://stackoverflow.com/questions/48658574/jsonencoders-dateencodingstrategy-not-working
      let actualYAML = try encoder.encode(changelog)

      // then
      XCTAssertEqual(actualYAML, expectedYAML)

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

  func testReadNotEmptyChangelog() {
    do {
      // given
      let expectedTitle = "Changelogger Changelog"
      let expectedCommitSummary = "Fixed a bunch of workflow stuff"
      let expectedAddedFeature = "Some new feature"

      // when
      let sut = try Changelog.current(from: Changelog.testNotEmptyEntryPath.string)

      // then
      XCTAssertEqual(sut.title, expectedTitle)
      XCTAssertEqual(sut.logs.count, 1)
      XCTAssertEqual(sut.logs[0].commit.summary, expectedCommitSummary)
      XCTAssertEqual(sut.logs[0].commit.added.count, 1)
      XCTAssertEqual(sut.logs[0].commit.added[0], expectedAddedFeature)
      XCTAssertTrue(sut.logs[0].commit.changed.isEmpty)
      XCTAssertTrue(sut.logs[0].commit.deprecated.isEmpty)
      XCTAssertTrue(sut.logs[0].commit.removed.isEmpty)
      XCTAssertTrue(sut.logs[0].commit.fixed.isEmpty)
      XCTAssertTrue(sut.logs[0].commit.security.isEmpty)

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

  func testUpdateChangelogStruct() {
    do {
      // given
      let expectedTitle = "Changelogger Changelog"
      var sut = try Changelog.current(from: Changelog.testNotEmptyEntryPath.string)
      let priorCount = sut.logs.count

      // when
      let commitEntry = try CommitEntry.current(from: CommitEntry.testNewEntryPath.string)
      let logEntry = LogEntry(from: commitEntry)

      sut.update(using: logEntry)

      // then
      XCTAssertEqual(sut.title, expectedTitle)
      // should only have 1 new entry
      XCTAssertEqual(sut.logs.count - priorCount, 1)
      // new entry should be first
      XCTAssertEqual(sut.logs[0].commit.summary, "Feature flags")

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

  func testUpdateChangelogFile() {
    do {
      // given
      var sut = try Changelog.current(from: Changelog.testNotEmptyEntryPath.string)

      // when
      let commitEntry = try CommitEntry.current(from: CommitEntry.testNewEntryPath.string)
      let logEntry = LogEntry(from: commitEntry)

      sut.update(using: logEntry)

      let actualYAML = try sut.yaml()

      let expectedYAML =
        """
        title: Changelogger Changelog
        logs:
        - version: unreleased
          date: \(logEntry.date.iso8601StringWithFullNanosecond)
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
      // then
      XCTAssertEqual(actualYAML, expectedYAML)

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

  func testSquashUnreleasedEntries() {
    do {
      // given
      let sut = try Changelog.current(from: Changelog.testSquashEntryPath.string)
      let unreleasedCount = sut.logs.filter { $0.version == "unreleased" }

      // when
      let squashed = sut.squashedUnreleased

      // then
      XCTAssertEqual(squashed.commit.summary, "Combined \(unreleasedCount.count) entries")

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

  func testwriteChangelogYAML() {
    do {
      // given
      try Changelog.testWriteChangelogPath.delete()
      var sut = try Changelog.current(from: Changelog.testSquashEntryPath.string)
      let commitEntry = try CommitEntry.current(from: CommitEntry.testNotEmptyEntryPath.string)
      let logEntry = LogEntry(from: commitEntry)

      // when
      sut.update(using: logEntry)

      try sut.write(to: Changelog.testWriteChangelogPath)

      let actualYAML = try String(contentsOf: Changelog.testWriteChangelogPath)

      let expectedYAML =
        """
        title: Changelogger Changelog
        logs:
        - version: unreleased
          date: \(logEntry.date.iso8601StringWithFullNanosecond)
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

      // then
      XCTAssertEqual(actualYAML, expectedYAML)

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

  func testCreateMarkdown() {
    do {
      let testRunPath = Path.cwd / "Tests/test-runs"

      let sampleLogFile = Path.cwd / "Tests/fixtures/changelog/test-write-changelog-markdown.yml"

      let testDir = testRunPath.join("testCreateMarkdown")

      try testDir.mkdir()
      try testDir.join(".changelog").mkdir()

      let loggingFile = testDir.join(".changelog/changelog.yml")

      try loggingFile.delete()

      try sampleLogFile.copy(to: loggingFile)

      // when
      let sut = try Changelog.current(from: loggingFile.string)
      let actualMarkdown = sut.markdown

      // swiftformat:disable consecutiveBlankLines
      let expectedMarkdown =
        """
        ### Changelogger Changelog

        All notable changes to this project will be documented in this file.

        * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
        * This project adheres to [Semantic Versioning](http://semver.org/).

        #### [unreleased] - \(Date().markdownDay).
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
      XCTAssertEqual(actualMarkdown, expectedMarkdown)

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

  func testWriteMarkdown() {
    do {
      // given
      try Changelog.testWriteChangelogMarkdownPath.delete()
      let sut = try Changelog.current(from: Changelog.testSquashEntryPath.string)

      // when
      try sut.markdown.write(to: Changelog.testWriteChangelogMarkdownPath)

      let actualMarkdown = try String(contentsOf: Changelog.testWriteChangelogMarkdownPath)

      // swiftformat:disable consecutiveBlankLines
      let expectedMarkdown =
        """
        ### Changelogger Changelog

        All notable changes to this project will be documented in this file.

        * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
        * This project adheres to [Semantic Versioning](http://semver.org/).

        #### [unreleased] - \(DateManager.formatter.string(from: Date())).
        ##### Added
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
      XCTAssertEqual(actualMarkdown, expectedMarkdown)

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
}
