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
}
