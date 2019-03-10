import Yams

struct CommitEntry: Codable {
  let summary: String
  let added: [String]
  let changed: [String]
  let deprecated: [String]
  let removed: [String]
  let fixed: [String]
  let security: [String]

  static func current() throws -> CommitEntry {
    let decoder = YAMLDecoder()
    let YAML = try String(contentsOfFile: "./commit.yaml")
    let entry = try decoder.decode(CommitEntry.self, from: YAML)
    return entry
  }
}
