import Foundation
import Yams

public struct LogEntry: Codable {
  public var version: String
  public let date: Date
  // public let date: String
  public var commit: CommitEntry

  public static var dateFormat = "yyyy-MMM-dd"
  public static var timeZone = TimeZone(secondsFromGMT: 0)
  public static var unreleasedVersion = "unreleased"

  public enum Error: Swift.Error {
    case badDate(String)
  }
}

extension LogEntry {
  public init(from commit: CommitEntry) {
    version = LogEntry.unreleasedVersion
    // DateManager.formatter.dateFormat = LogEntry.dateFormat
    // date = DateManager.formatter.string(from: Date())
    date = Date()
    self.commit = commit
  }

  public var summary: String {
    get {
      return commit.summary
    }
    set {
      commit.summary = newValue
    }
  }

  public var markdown: String {
    DateManager.formatter.dateFormat = LogEntry.dateFormat

    let descriptor =
      """
      #### [\(version)] - \(date.markdownDay).
      \(convertItemToMarkDown(titled: "Added", using: commit.added))

      \(convertItemToMarkDown(titled: "Changed", using: commit.changed))

      \(convertItemToMarkDown(titled: "Deprecated", using: commit.deprecated))

      \(convertItemToMarkDown(titled: "Removed", using: commit.removed))

      \(convertItemToMarkDown(titled: "Fixed", using: commit.fixed))

      \(convertItemToMarkDown(titled: "Security", using: commit.security))

      """

    return descriptor
  }

  func convertItemToMarkDown(titled: String, using work: [String]) -> String {
    let newLine = "\n"

    let workDescription = work.isEmpty ? "-" : work.map { "- \($0)" }.joined(separator: newLine)

    let descriptor =
      """
      ##### \(titled)
      \(workDescription)
      """

    return descriptor
  }
}
