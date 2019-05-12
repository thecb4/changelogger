import ChangeLoggerKit
import Path

extension CommitEntry {
  public static var emptyFile = "entry-empty.yml"
  public static var notEmptyFile = "entry-not-empty.yml"

  public static let testFixturePath = Path.cwd / "Tests" / "fixtures"

  public static var testEmptyEntryPath = testFixturePath / CommitEntry.emptyFile

  public static var testNotEmptyEntryPath = testFixturePath / CommitEntry.notEmptyFile
}
