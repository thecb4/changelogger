import Yams
import Path

public struct CommitEntry: Codable {
  public static var file = "commit.yml"

  public static let defaultCommitFilePath = Path.cwd / CommitEntry.file

  public static var commitFilePath = defaultCommitFilePath

  public enum Error: Swift.Error {
    case badPath(String)
    case dataNotConvertableFromString(String)
    case notDecodable(String)
  }

  public var summary: String
  public let added: [String]
  public let changed: [String]
  public let deprecated: [String]
  public let removed: [String]
  public let fixed: [String]
  public let security: [String]

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

  public var isEmpty: Bool {
    return
      added.isEmpty &&
      changed.isEmpty &&
      deprecated.isEmpty &&
      removed.isEmpty &&
      fixed.isEmpty &&
      security.isEmpty
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

  public func yaml() throws -> String {
    let encoder = YAMLEncoder()
    let yaml = try encoder.encode(self)
    return yaml
  }
}

extension CommitEntry: Equatable {}
