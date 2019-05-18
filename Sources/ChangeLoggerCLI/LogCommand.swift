import Foundation
import SPMUtility
import Basic
import ChangeLoggerKit
import Path

struct LogCommand: Command {
  let command = "log"
  let overview = "log commit to log entry file"

  private let commitFileOption: OptionArgument<String>
  private let logEntryFileOption: OptionArgument<String>
  // private let markdownFileOption: OptionArgument<String>
  // private let releaseTagOption: OptionArgument<String>

  init(parser: ArgumentParser) {
    let subparser = parser.add(subparser: command, overview: overview)

    commitFileOption = subparser.add(
      option: "--commit-file",
      shortName: "-cm",
      kind: String.self,
      usage: "path for commit file"
    )

    logEntryFileOption = subparser.add(
      option: "--log-entry-file",
      shortName: "-lf",
      kind: String.self,
      usage: "path for log entry file"
    )

    // markdownFileOption = subparser.add(
    //   option: "--markdown",
    //   shortName: "-md",
    //   kind: String.self,
    //   usage: "Path for changelog markdown file"
    // )
    //
    // releaseTagOption = subparser.add(
    //   option: "--release",
    //   shortName: "-r",
    //   kind: String.self,
    //   usage: "Release tag info"
    // )
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

  func logEntryFileOptionAction(_ arguments: ArgumentParser.Result) throws -> Path {
    // option missing
    guard let logEntryFilePathString = arguments.get(logEntryFileOption) else {
      return Changelog.defaultLogEntryFilePath
    }

    // option provided but value is empty
    if logEntryFilePathString.isEmpty {
      throw CommandLineError.missingChangeLogYAML
    }

    let logEntryFilePath = Path(logEntryFilePathString) ?? Path.cwd / logEntryFilePathString

    return logEntryFilePath
  }

  func run(with arguments: ArgumentParser.Result) throws {
    let commitFilePath = try commitFileOptionAction(arguments)

    let logEntryFilePath = try logEntryFileOptionAction(arguments)

    let commit = try CommitEntry.current(from: commitFilePath.string)

    var changelog = try Changelog.current(from: logEntryFilePath.string)

    let log = LogEntry(from: commit)

    changelog.update(using: log)

    let yaml = try changelog.yaml()

    try yaml.write(to: logEntryFilePath)

    let result =
      """
      Log updated | \(log.date.iso8601StringWithFullNanosecond)

      \(yaml)
      """

    print(result)

    // print(changelog.markdown)

    // let changelogPath = Changelog.defaultChangelogMarkdownPath
    //
    // try changelog.markdown.write(to: changelogPath)

    // if changelogFilePath.parent == Path.cwd {
    //   try "".write(to: changelogFilePath)
    // } else {
    //   try changelogFilePath.parent.mkdir()
    //   try "".write(to: changelogFilePath)
    // }
    //
    // print("commit file: \(commitFilePath)")
    // print("changelog file: \(changelogFilePath)")
  }
}
