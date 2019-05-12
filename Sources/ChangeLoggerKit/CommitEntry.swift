import Yams
import Path

public struct CommitEntry: Codable {
  public static var file = "commit.yaml"

  public static let defaultCommitFilePath = Path.cwd / CommitEntry.file

  public static var commitFilePath = defaultCommitFilePath

  public enum Error: Swift.Error {
    case badPath(String)
    case dataNotConvertableFromString(String)
    case notDecodable(String)
  }

  public let summary: String
  let added: [String]
  let changed: [String]
  let deprecated: [String]
  let removed: [String]
  let fixed: [String]
  let security: [String]

  public init(
    summary: String,
    added: [String],
    changed: [String],
    deprecated: [String],
    removed: [String],
    fixed: [String],
    security: [String]
  ) {
    self.summary = summary
    self.added = added
    self.changed = changed
    self.deprecated = deprecated
    self.removed = removed
    self.fixed = fixed
    self.security = security
  }

  public static func current(from path: String = CommitEntry.defaultCommitFilePath.string, using decoder: ContentDecoder = YAMLDecoder()) throws -> CommitEntry {
    guard let string = try? String(contentsOfFile: path) else {
      throw Error.badPath(path)
    }

    guard let data = string.data(using: .utf8) else {
      throw Error.dataNotConvertableFromString(string)
    }

    guard let entry = try? decoder.decode(CommitEntry.self, from: data) else {
      throw Error.notDecodable(string)
    }

    return entry
  }
}

extension CommitEntry: Equatable {}
