//
//  Command.swift
//  ChangeLoggerCLI
//
//  Created by Cavelle Benjamin on 2019-Mar-10.
//

import Foundation
import SPMUtility
import ChangeLoggerKit

// https://www.enekoalonso.com/articles/handling-commands-with-swift-package-manager

protocol Command {
  var command: String { get }
  var overview: String { get }

  init(parser: ArgumentParser)

  func run(with arguments: ArgumentParser.Result) throws
}
