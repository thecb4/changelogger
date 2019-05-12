import Foundation
import Path
import Yams

public struct Changelog: Codable {
  public let title: String
  public var logs: [LogEntry]
  static let preamble: String =
    """
    All notable changes to this project will be documented in this file.

    * Format based on [Keep A Change Log](https://keepachangelog.com/en/1.0.0/)
    * This project adheres to [Semantic Versioning](http://semver.org/).

    """

  public static var logEntryFile = "changelog.yml"

  public static var defaultLogEntryFolder = ".changelog"

  public static let defaultLogEntryFilePath = Path.cwd / defaultLogEntryFolder / logEntryFile

  public static var logEntryFilePath = defaultLogEntryFilePath

  public static var changelogMarkdownFile = "CHANGELOG.md"

  public static let defaultChangelogMarkdownPath = Path.cwd / changelogMarkdownFile

  public static var changelogMarkdownPath = defaultChangelogMarkdownPath

  public init(title: String, logs: [LogEntry] = []) {
    self.title = title
    self.logs = logs
  }
}

// extension Changelog {
//   // var markdown: String {
//   //   var descriptor = ""
//   //
//   //   descriptor += "# \(title) Change Log\n\n"
//   //
//   //   descriptor += Changelog.preamble + "\n\n\n"
//   //
//   //   descriptor += self.squashedUnreleased.markdown + "\n\n"
//   //
//   //   descriptor += entries.filter { $0.version != "unreleased" }.map { $0.markdown }.joined(separator: "\n")
//   //
//   //   return descriptor
//   // }
//
//   // mutating func add(_ entry: LogEntry) {
//   //   entries = [entry] + entries
//   // }
//
//   // var squashedUnreleased: LogEntry {
//   //
//   //   let unreleased = entries.filter { $0.version == "unreleased" }
//   //
//   //   var added: [String] = []
//   //   var changed: [String] = []
//   //   var deprecated: [String] = []
//   //   var removed: [String] = []
//   //   var fixed: [String] = []
//   //   var security: [String] = []
//   //
//   //   for item in unreleased {
//   //     added += item.commit.added
//   //     changed += item.commit.changed
//   //     deprecated += item.commit.deprecated
//   //     removed += item.commit.removed
//   //     fixed += item.commit.fixed
//   //     security += item.commit.security
//   //   }
//   //
//   //   let commit = CommitEntry(
//   //     summary: "",
//   //     added: added,
//   //     changed: changed,
//   //     deprecated: deprecated,
//   //     removed: removed,
//   //     fixed: fixed,
//   //     security: security
//   //   )
//   //
//   //   return LogEntry(
//   //     version: "unreleased",
//   //     date: Date(),
//   //     commit: commit
//   //   )
//   // }
//
//   // public static func current(from path: String = Changelog.defaultLogEntryFilePath.string, using decoder: ContentDecoder = YAMLDecoder()) throws -> CommitEntry {
//   //
//   //   guard let string = try? String(contentsOfFile: path) else {
//   //     throw Error.badPath(path)
//   //   }
//   //
//   //   guard let data = string.data(using: .utf8) else {
//   //
//   //     throw Error.dataNotConvertableFromString(string)
//   //   }
//   //
//   //   guard let entry = try? decoder.decode(Changelog.self, from: data) else {
//   //     throw Error.notDecodable(string)
//   //   }
//   //
//   //   return entry
//   //
//   // }
//
//   // public static func revise(changelog changelogPath: String = Changelog.defaultLogEntryFilePath.string, using commitPath: String = CommitEntry.defaultCommitFilePath.string ) throws {
//   //
//   //   let changelog = Changelog.current(from: changelogPath)
//   //   let commit    = CommitEntry.current(from: commitPath)
//   //
//   //   let decoder = YAMLDecoder()
//   //   let encoder = YAMLEncoder()
//   //
//   //   let changelogYAML = try String(contentsOfFile: ChangeLog.changelogYAMLPath)
//   //   var changelog = try decoder.decode(ChangeLog.self, from: changelogYAML)
//   //
//   //   let commitYAML = try String(contentsOfFile: ChangeLog.commitYAMLPath)
//   //   let commit = try decoder.decode(CommitEntry.self, from: commitYAML)
//   //
//   //   changelog.add(LogEntry(from: commit))
//   //
//   //   let encodedChangelog = try encoder.encode(changelog)
//   //
//   //   let yamlPathURL = URL(fileURLWithPath: ChangeLog.changelogYAMLPath)
//   //
//   //   try encodedChangelog.write(to: yamlPathURL, atomically: true, encoding: .utf8)
//   //
//   //   let mdPathURL = URL(fileURLWithPath: ChangeLog.changelogMarkdownPath)
//   //
//   //   try changelog.markdown.write(to: mdPathURL, atomically: true, encoding: .utf8)
//   // }
// }
