import Ignite

struct FAQ: StaticLayout {
  let language: Language
  let title: String

  init(language: Language) {
    self.language = language
    self.title = String(forKey: "faq", language: language)
  }

  var path: String {
    switch language {
    case .ja: return "/faq"
    case .en: return "/faq_en"
    }
  }

  var body: some HTML {
    MainNavigationBar(language: language)
  }
}
