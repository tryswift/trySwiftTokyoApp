import Ignite

struct MainNavigationBar: HTML {
  let path: (Language) -> String
  let language: Language

  var body: some HTML {
    NavigationBar {
      for link in HomeSectionType.allCases.map(\.rawValue) {
        let target: String = {
          let homePath = Home.generatePath(language: language)
          return path(language) == homePath ? "#\(link)" : "\(homePath)#\(link)"
        }()
        Link(String(forKey: link, language: language), target: target)
          .role(.light)
      }
      Link(String(forKey: "faq", language: language), target: FAQ(language: language))
        .role(.light)
    } logo: {
      LanguageSelector(path: path, currentLanguage: language)
    }
    .navigationItemAlignment(.center)
    .navigationBarStyle(.dark)
    .background(.darkBlue.opacity(0.7))
    .position(.fixedTop)
  }
}
