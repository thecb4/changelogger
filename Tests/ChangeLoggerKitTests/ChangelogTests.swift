import XCTest
import ChangeLoggerKit
import Yams

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
      var sut = try Changelog.current(from: Changelog.testSquashEntryPath.string)
      let unreleasedCount = sut.logs.filter { $0.version == "unreleased" }

      // when
      sut.squashUnreleased()

      let actualYAML = try sut.yaml()

      let expectedYAML =
        """
        title: Changelogger Changelog
        logs:
        - version: unreleased
          date: \(sut.logs[0].date.iso8601StringWithFullNanosecond)
          commit:
            summary: Combined \(unreleasedCount.count) entries
            added:
            - Feature flag all the things
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
}
