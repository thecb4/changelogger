import ChangeLoggerKit
import Path

extension Changelog {
  public static let emptyFile = "changelog-empty.yml"
  public static let notEmptyFile = "changelog-notempty.yml"
  public static let squashUnreleased = "test-squash-unreleased.yml"
  public static let testWriteFile = "test-write-changelog-yaml.yml"
  public static let testWriteChangelogMarkdown = "CHANGELOG.md"

  public static let testFixturePath = Path.cwd / "Tests" / "fixtures" / "changelog"

  public static let testEmptyEntryPath = testFixturePath / CommitEntry.emptyFile

  public static let testNotEmptyEntryPath = testFixturePath / Changelog.notEmptyFile

  public static let testSquashEntryPath = testFixturePath / Changelog.squashUnreleased

  public static let testWriteChangelogPath = testFixturePath / Changelog.testWriteFile

  public static let testWriteChangelogMarkdownPath = Path.cwd / "Tests" / "fixtures" / Changelog.testWriteChangelogMarkdown
}
