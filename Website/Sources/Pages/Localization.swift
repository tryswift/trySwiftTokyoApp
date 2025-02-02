import Foundation

enum SupportedLanguage: String, CaseIterable {
  case ja
  case en
}

extension String {
  init(forKey key: String, bundle: Bundle = .module, language: SupportedLanguage) {
    guard let path = bundle.path(forResource: language.rawValue, ofType: "lproj"),
          let localizedBundle = Bundle(path: path) else {
      fatalError()
    }
    self.init(NSLocalizedString(key, bundle: localizedBundle, comment: ""))
  }
}
