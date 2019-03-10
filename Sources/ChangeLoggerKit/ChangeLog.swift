import Foundation
import Yams

public struct ChangeLog: Codable {
  let title: String
  var entries: [LogEntry]
  static let preamble: String =
    """
    All notable changes to this project will be documented in this file.

    * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
    * This project adheres to [Semantic Versioning](http://semver.org/).
    """
}

extension ChangeLog {
  var markdown: String {
    var descriptor = ""

    descriptor += "# \(title) Change Log\n\n"

    descriptor += ChangeLog.preamble + "\n\n\n"

    descriptor += self.squashedUnreleased.markdown + "\n\n"

    descriptor += entries.filter { $0.version != "unreleased" }.map { $0.markdown }.joined(separator: "\n")

    return descriptor
  }

  mutating func add(_ entry: LogEntry) {
    entries = [entry] + entries
  }

  var squashedUnreleased: LogEntry {
    let unreleased = entries.filter { $0.version == "unreleased" }

    var added: [String] = []
    var changed: [String] = []
    var deprecated: [String] = []
    var removed: [String] = []
    var fixed: [String] = []
    var security: [String] = []

    for item in unreleased {
      added += item.added
      changed += item.changed
      deprecated += item.deprecated
      removed += item.removed
      fixed += item.fixed
      security += item.security
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"

    return LogEntry(
      version: "unreleased",
      date: dateFormatter.string(from: Date()),
      added: added,
      changed: changed,
      deprecated: deprecated,
      removed: removed,
      fixed: fixed,
      security: security
    )
  }

  public static var changelogYAMLPath = FileManager.default.currentDirectoryPath + "/.changelog/changelog.yaml"

  public static var commitYAMLPath = FileManager.default.currentDirectoryPath + "/commit.yaml"

  public static var changelogMarkdownPath = FileManager.default.currentDirectoryPath + "/CHANGELOG.md"

  public static func revise() throws {
    let decoder = YAMLDecoder()
    let encoder = YAMLEncoder()

    let changelogYAML = try String(contentsOfFile: ChangeLog.changelogYAMLPath)
    var changelog = try decoder.decode(ChangeLog.self, from: changelogYAML)

    let commitYAML = try String(contentsOfFile: ChangeLog.commitYAMLPath)
    let commit = try decoder.decode(CommitEntry.self, from: commitYAML)

    changelog.add(LogEntry(commit))

    let encodedChangelog = try encoder.encode(changelog)

    let yamlPathURL = URL(fileURLWithPath: ChangeLog.changelogYAMLPath)

    try encodedChangelog.write(to: yamlPathURL, atomically: true, encoding: .utf8)

    let mdPathURL = URL(fileURLWithPath: ChangeLog.changelogMarkdownPath)

    try changelog.markdown.write(to: mdPathURL, atomically: true, encoding: .utf8)
  }
}
