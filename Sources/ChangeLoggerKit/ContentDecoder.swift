import Foundation
import Yams

public protocol ContentDecoder {
  /**
   Decode content of given type. The compiler infers type.

   - Parameters:
     - type: The type to decode
     - data: The data source to decode to tyoe T

   - Returns: The decoded type
   */
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension YAMLDecoder: ContentDecoder {
  public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    guard let string = String(data: data, encoding: .utf8) else {
      throw YamlError.representer(problem: "bad string input")
    }

    return try YAMLDecoder().decode(type, from: string)
  }
}
