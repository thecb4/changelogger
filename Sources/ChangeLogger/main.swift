import ChangeLoggerCLI

let changelogger = ChangeLoggerCommandLine()

if #available(macOS 10.12, *) {
  changelogger.run()
} else {
  print("need to run macOS 10.12")
}
