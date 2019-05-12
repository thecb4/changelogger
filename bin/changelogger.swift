#!/usr/bin/swift sh

import Foundation
import Shelltr // https://gitlab.com/thecb4/Shelltr == 0.2.0
// import ChangeLogger // https://gitlab.com/thecb4/changelogger == 0.1.0

@available(macOS 10.13, *)
extension Shell {
  public static func _swifttest(shellType: ShellType = .bash, arguments: [String] = []) throws {
    let args = ["test"] + arguments
    try Shell(shellType).execute(.swift(args))
  }
}

if #available(macOS 10.13, *) {
  Shell.work {
    // get rid of all the old data
    try Shell.rm(content: ".build", recursive: true, force: true)

    try Shell.swifttest(arguments: ["--generate-linuxmain"])

    // Lint & Format
    try Shell.swiftformat(arguments: [
      "--swiftversion", "5"
    ])
    try Shell.swiftlint(quiet: false)

    try Shell.swifttest(arguments: ["--enable-code-coverage"])
    try Shell.sourcekitten(module: "ChangeLoggerKit", destination: Shell.cwd + "/docs/source.json")
    try Shell.jazzy()

    // cleanup
    try Shell.rm(content: ".build", recursive: true, force: true)

    // add + commit
    try Shell.gitAdd(.all)
    try Shell.gitCommit(message: "Changelog Unit tests, use ISO 8601 with nanoseconds for date")
  }
}
