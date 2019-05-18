#!/usr/bin/swift sh

import Foundation
import Shelltr // https://gitlab.com/thecb4/Shelltr == 0.2.0

@available(macOS 10.13, *)
extension ShellCommand {
  public static func mint(_ arguments: [String], environment: ShellEnvironment? = nil, emoji: String? = ShellCommand.defaultEmoji, echoString: String? = nil, directory: String = Shell.cwd) -> ShellCommand {
    return ShellCommand(named: "mint", arguments: arguments, environment: environment, emoji: emoji, echoString: echoString, directory: directory)
  }
}

@available(macOS 10.13, *)
extension Shell {
  public static func _swifttest(shellType: ShellType = .bash, arguments: [String] = []) throws {
    let args = ["test"] + arguments
    try Shell(shellType).execute(.swift(args))
  }

  public static func mint(shellType: ShellType = .bash, _ arguments: [String]) throws {
    try Shell(shellType).execute(.mint(arguments))
  }
}

if #available(macOS 10.13, *) {
  Shell.work {
    // Ensure commit YAML is revised before starting flow
    try Shell.assertModified(file: "commit.yml")

    // get rid of all old files
    try Shell.rm(content: ".build", recursive: true, force: true)
    try Shell.rm(content: "/docs/source.json", recursive: true, force: true)
    try Shell.rm(content: "/docs/api", recursive: true, force: true)

    // auto-generate files
    try Shell.swifttest(arguments: ["--generate-linuxmain"])

    // Format and Lint
    try Shell.swiftformat(arguments: [
      "--swiftversion", "5"
    ])
    try Shell.swiftlint(quiet: false)

    // build and tests
    try Shell.swifttest(arguments: ["--enable-code-coverage"])

    // docs
    try Shell.sourcekitten(module: "ChangeLoggerKit", destination: Shell.cwd + "/docs/source.json")
    try Shell.jazzy()

    // cleanup
    try Shell.rm(content: ".build", recursive: true, force: true)

    try Shell.mint([
      "run",
      "--verbose",
      "https://gitlab.com/thecb4/changelogger",
      "changelogger",
      "log"
    ])

    let message = try String(contentsOfFile: "commit.yml")

    // add + commit
    try Shell.gitAdd(.all)
    try Shell.gitCommit(message: message)
  }
}
