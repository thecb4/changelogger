import Foundation
import Yams

struct LogEntry: Codable {
  var version: String
  var date: String
  var added: [String]
  var changed: [String]
  var deprecated: [String]
  var removed: [String]
  var fixed: [String]
  var security: [String]
}

extension LogEntry {
  init(_ commit: CommitEntry) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"

    version = "unreleased"
    date = dateFormatter.string(from: Date())
    added = commit.added
    changed = commit.changed
    deprecated = commit.deprecated
    removed = commit.removed
    fixed = commit.fixed
    security = commit.security
  }

  var markdown: String {
    var descriptor = ""

    descriptor += "## [\(version)] - \(date).\n"

    descriptor += convertToMarkDown(titled: "Added", using: added)

    descriptor += convertToMarkDown(titled: "Changed", using: changed)

    descriptor += convertToMarkDown(titled: "Deprecated", using: deprecated)

    descriptor += convertToMarkDown(titled: "Removed", using: removed)

    descriptor += convertToMarkDown(titled: "Fixed", using: fixed)

    descriptor += convertToMarkDown(titled: "Security", using: security)

    return descriptor
  }

  func convertToMarkDown(titled: String, using work: [String]) -> String {
    var descriptor = ""

    descriptor += "### \(titled)\n"

    if work.isEmpty {
      descriptor += "-\n\n"
    } else {
      descriptor += work.map { "- \($0)" }.joined(separator: "\n")
      descriptor += "\n\n"
    }

    return descriptor
  }
}
