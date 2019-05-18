import Foundation
import SPMUtility
import Basic
import ChangeLoggerKit
import Path

struct ReleaseCommand: Command {
  let command = "release"
  let overview = "squash unreleased logs into version"

  // private let commitFileOption: OptionArgument<String>
  private let logEntryFileOption: OptionArgument<String>
  private let summaryArgument: PositionalArgument<String>
  private let versionArgument: OptionArgument<String>
  // private let markdownFileOption: OptionArgument<String>
  // private let releaseTagOption: OptionArgument<String>

  init(parser: ArgumentParser) {
    let subparser = parser.add(subparser: command, overview: overview)

    // commitFileOption = subparser.add(
    //   option: "--commit-file",
    //   shortName: "-cm",
    //   kind: String.self,
    //   usage: "path for commit file"
    // )

    logEntryFileOption = subparser.add(
      option: "--log-entry-file",
      shortName: "-lf",
      kind: String.self,
      usage: "path for log entry file"
    )

    summaryArgument = subparser.add(
      positional: "summary",
      kind: String.self,
      usage: "Summary of version being released"
    )

    // markdownFileOption = subparser.add(
    //   option: "--markdown",
    //   shortName: "-md",
    //   kind: String.self,
    //   usage: "Path for changelog markdown file"
    // )
    //
    versionArgument = subparser.add(
      option: "--version-tag",
      shortName: "-vt",
      kind: String.self,
      usage: "Version tag to use"
    )
  }

  // func commitFileOptionAction(_ arguments: ArgumentParser.Result) throws -> Path {
  //   // option missing
  //   guard let commitFilePathString = arguments.get(commitFileOption) else {
  //     return CommitEntry.defaultCommitFilePath
  //   }
  //
  //   // option provided but value is empty
  //   if commitFilePathString.isEmpty {
  //     throw CommandLineError.missingCommitYAML
  //   }
  //
  //   let commitFilePath = Path(commitFilePathString) ?? Path.cwd / commitFilePathString
  //
  //   return commitFilePath
  // }

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

  func summaryArgumentAction(_ arguments: ArgumentParser.Result) throws -> String {
    guard let summary = arguments.get(summaryArgument) else {
      throw CommandLineError.missingReleaseSummary
    }
    return summary
  }

  func versionArgumentAction(_ arguments: ArgumentParser.Result) throws -> String {
    guard let version = arguments.get(versionArgument) else {
      throw CommandLineError.missingVersion
    }
    return version
  }

  func run(with arguments: ArgumentParser.Result) throws {
    // let commitFilePath = try commitFileOptionAction(arguments)

    let logEntryFilePath = try logEntryFileOptionAction(arguments)

    // let commit = try CommitEntry.current(from: commitFilePath.string)

    let summary = try summaryArgumentAction(arguments)

    let version = try versionArgumentAction(arguments)

    let changelog = try Changelog.current(from: logEntryFilePath.string)

    // let log = LogEntry(from: commit)

    let release = try changelog.release(version, with: summary)

    let yaml = try release.yaml()

    try yaml.write(to: logEntryFilePath)

    let result =
      """
      Log released | \(release.logs[0].date.iso8601StringWithFullNanosecond)

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
