import Foundation
// import SPMUtility
import ChangeLoggerKit

// https://github.com/apple/swift-package-manager/blob/master/Sources/Utility/ArgumentParser.swift

typealias FileURL = Foundation.URL

public class ChangeLoggerCommandLine {
  var registry = CommandRegistry(commandName: "changelogger", usage: "<command> <options>", overview: "Take control of your changelogs\n")

  public init() {
    registry.register(command: InitCommand.self)
    registry.register(command: LogCommand.self)
    registry.register(command: MarkdownCommand.self)
  }

  public func run() {
    registry.run()
  }
}
