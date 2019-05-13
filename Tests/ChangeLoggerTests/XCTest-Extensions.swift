import XCTest
import Path

// extension XCTestCase {
//   func run(_ arguments: [String], workingDirectory: String = "./", buildPath: String = "./.build") throws -> String {
//     // This is an example of a functional test case.
//     // Use XCTAssert and related functions to verify your tests produce the correct
//     // results.
//
//     // Some of the APIs that we use below are available in macOS 10.13 and above.
//     guard #available(macOS 10.13, *) else {
//         return "--- BAD RETURN ---"
//     }
//
//     let binaryName = "changelogger"
//
//     let process = Process()
//
//     // let exacutable = FileManager.makeFileURL(using: "bin/missive")
//
//     let exacutable = Path("/bin/bash").url //FileManager.makeFileURL(using: "/bin/bash")
//
//     process.executableURL = exacutable
//
//     process.arguments = ["-c", "cd \(workingDirectory) && swift run --build-path \(buildPath) \(binaryName) \(arguments.joined(separator: " "))"]
//
//     print(String(describing: process.arguments))
//
//     let stdOut = Pipe()
//     process.standardOutput = stdOut
//
//     let stdErr = Pipe()
//     process.standardError = stdErr
//
//     #if os(Linux)
//       process.launch()
//     #else
//       try process.run()
//     #endif
//
//     // try process.run()
//     process.waitUntilExit()
//
//     let data = stdOut.fileHandleForReading.readDataToEndOfFile()
//
//     guard let output = String(data: data, encoding: .utf8) else {
//       return "--- BAD RETURN ---"
//     }
//
//     let errData = stdErr.fileHandleForReading.readDataToEndOfFile()
//
//     if let errOutput = String(data: errData, encoding: .utf8) {
//       print(errOutput)
//     }
//
//     return output
//   }
// }
