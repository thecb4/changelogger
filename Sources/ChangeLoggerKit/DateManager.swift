import Foundation

/**
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 **/
public struct DateManager {
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
}

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

  public static let markdownDayFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MMM'-'dd'"
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

  public var markdownDay: String {
    return Date.markdownDayFormatter.string(from: self)
  }
}
