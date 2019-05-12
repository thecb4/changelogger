import ChangeLoggerKit
import Path

extension CommitEntry {
  public static let emptyFile = "entry-empty.yml"
  public static let notEmptyFile = "entry-not-empty.yml"
  public static let newCommitFile = "new-commit.yml"

  public static let testFixturePath = Path.cwd / "Tests" / "fixtures"

  public static let testEmptyEntryPath = testFixturePath / CommitEntry.emptyFile

  public static let testNotEmptyEntryPath = testFixturePath / CommitEntry.notEmptyFile

  public static let testNewEntryPath = testFixturePath / CommitEntry.newCommitFile
}
