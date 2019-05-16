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

    // add + commit
    try Shell.gitAdd(.all)
    try Shell.gitCommit(message: "CLI. Markdown command. No Arguments.")
  }
}
