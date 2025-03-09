import Foundation

extension Date {
  func formattedDateString(language: SupportedLanguage) -> String {
    let formatter = DateFormatter()
    switch language {
    case .en:
      let day = Calendar.current.component(.day, from: self)
      let ordinal = NumberFormatter.localizedString(from: NSNumber(value: day), number: .ordinal)
      formatter.dateFormat = "MMMM"
      return formatter.string(from: self) + " \(ordinal)"
    case .ja:
      formatter.dateFormat = "M月d日"
      return formatter.string(from: self)
    }
  }

  func formattedTimeString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }
}
