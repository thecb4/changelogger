import Foundation
import SPMUtility
import Basic
import ChangeLoggerKit
import Path
import Yams

struct InitCommand: Command {
  let command = "init"
  let overview = "initialize directory for changelogger"

  private let commitFileOption: OptionArgument<String>
  private let changelogFileOption: OptionArgument<String>

  init(parser: ArgumentParser) {
    let subparser = parser.add(subparser: command, overview: overview)

    commitFileOption = subparser.add(
      option: "--commit-file",
      shortName: "-cm",
      kind: String.self,
      usage: "path for commit file"
    )

    changelogFileOption = subparser.add(
      option: "--log-entry-file",
      shortName: "-lf",
      kind: String.self,
      usage: "path for log entry file"
    )
  }

  func commitFileOptionAction(_ arguments: ArgumentParser.Result) throws -> Path {
    // option missing
    guard let commitFilePathString = arguments.get(commitFileOption) else {
      return CommitEntry.defaultCommitFilePath
    }

    // option provided but value is empty
    if commitFilePathString.isEmpty {
      throw CommandLineError.missingCommitYAML
    }

    let commitFilePath = Path(commitFilePathString) ?? Path.cwd / commitFilePathString

    return commitFilePath
  }

  func changelogFileOptionAction(_ arguments: ArgumentParser.Result) throws -> Path {
    // option missing
    guard let changelogFilePathString = arguments.get(changelogFileOption) else {
      return Changelog.defaultLogEntryFilePath
    }

    // option provided but value is empty
    if changelogFilePathString.isEmpty {
      throw CommandLineError.missingChangeLogYAML
    }

    let changelogFilePath = Path(changelogFilePathString) ?? Path.cwd / changelogFilePathString

    return changelogFilePath
  }

  func run(with arguments: ArgumentParser.Result) throws {
    print("initializing directory for changelog management")

    let commitFilePath = try commitFileOptionAction(arguments)

    let commit = CommitEntry(
      summary: "Initial Entry",
      added: [],
      changed: [],
      deprecated: [],
      removed: [],
      fixed: [],
      security: []
    )

    let yaml = try commit.yaml()

    try yaml.write(to: commitFilePath)

    let changelogFilePath = try changelogFileOptionAction(arguments)

    if changelogFilePath.parent == Path.cwd {
      try "".write(to: changelogFilePath)
    } else {
      try changelogFilePath.parent.mkdir()
      try "".write(to: changelogFilePath)
    }

    print("commit file: \(commitFilePath)")
    print("changelog file: \(changelogFilePath)")
  }
}
