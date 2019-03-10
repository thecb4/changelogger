import Foundation

enum CommandLineError: Error {
  case missingChangeLogYAML
  case missingCommitYAML
  // case missingFileName
  // case badWorkDirectoryName(String)
  // case badDraftsDirectoryName(String)
  //
  var description: String {
    switch self {
      case .missingChangeLogYAML: return "changelog.yaml not defined"
      case .missingCommitYAML: return "commit.yaml"
    }
  }
}
