import Foundation

extension Date {
  public static let formatter = DateFormatter()
  public static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"

  public static var iso8601WithoutZFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()

  public static let iso8601Formatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()

  public func string(
    using formatter: DateFormatter = Date.formatter,
    with format: String = Date.defaultFormat
  ) -> String {
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: self)
  }

  public var iso8601StringWithFullNanosecond: String {
    let characterSetZero = CharacterSet(charactersIn: "0")
    let calendar = Calendar(identifier: .gregorian)
    let nanosecond = calendar.component(.nanosecond, from: self)
    if nanosecond != 0 {
      return Date.iso8601WithoutZFormatter.string(from: self) +
        String(format: ".%09d", nanosecond).trimmingCharacters(in: characterSetZero) + "Z"
    } else {
      return Date.iso8601Formatter.string(from: self)
    }
  }
}
