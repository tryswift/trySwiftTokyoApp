import Foundation

enum SupportedLanguage: String, CaseIterable {
  case ja
  case en
}

extension String {
  init(_ key: String, bundle: Bundle = .module, language: SupportedLanguage) {
    // The xcstrings file is converted to an lproj file during the build process.
    // This code references the converted file.
    guard let path = bundle.path(forResource: language.rawValue, ofType: "lproj"),
          let localizedBundle = Bundle(path: path) else {
      fatalError()
    }
    self.init(NSLocalizedString(key, bundle: localizedBundle, comment: ""))
  }
}

extension Bundle {
  static var scheduleFeature: Bundle {
    let bundlePath = Bundle.main.resourceURL!.appendingPathComponent("MyLibrary_ScheduleFeature.bundle")
    return .init(url: bundlePath)!
  }

  static var trySwiftFeature: Bundle {
    let bundlePath = Bundle.main.resourceURL!.appendingPathComponent("MyLibrary_trySwiftFeature.bundle")
    return .init(url: bundlePath)!
  }
}
