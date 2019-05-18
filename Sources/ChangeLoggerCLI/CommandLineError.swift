import Foundation

enum CommandLineError: Error {
  case unkownCommand(String)
  case missingChangeLogYAML
  case missingCommitYAML
  case missingReleaseSummary
  case missingVersion

  var description: String {
    switch self {
      case let .unkownCommand(command):
        return "Unkown command: \(command)"
      case .missingChangeLogYAML:
        return "must supply file path"
      case .missingCommitYAML:
        return "must supply file path"
      case .missingReleaseSummary:
        return "must supply summary for release"
      case .missingVersion:
        return "Version must be supplied"
    }
  }
}
