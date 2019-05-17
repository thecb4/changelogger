import Foundation

enum CommandLineError: Error {
  case unkownCommand(String)
  case missingChangeLogYAML
  case missingCommitYAML

  var description: String {
    switch self {
      case let .unkownCommand(command):
        return "Unkown command: \(command)"
      case .missingChangeLogYAML:
        return "must supply file path"
      case .missingCommitYAML:
        return "must supply file path"
    }
  }
}
