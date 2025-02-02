import Ignite

struct LanguageSelector: HTML, InlineHTML {
  let path: (Language) -> String
  let currentLanguage: Language

  var body: some HTML {
    Section {
      ForEach(Language.allCases) { language in
        Link(language.name, target: path(language))
          .role(currentLanguage == language ? .light : .secondary)
          .fontWeight(currentLanguage == language ? .bold : .regular)
          .margin(.trailing, .px(16))
      }
    }
  }
}

private extension Language {
  var name: String {
    switch self {
    case .ja: return "日本語"
    case .en: return "English"
    }
  }
}
