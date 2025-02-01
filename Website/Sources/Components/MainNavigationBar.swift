import Ignite

struct MainNavigationBar: HTML {
  let language: Language

  var body: some HTML {
    NavigationBar {
      for link in SectionType.allCases.map(\.rawValue) {
        Link(String(forKey: link, language: language), target: "#\(link)")
          .role(.light)
      }
    } logo: {
      LanguageSelector(currentLanguage: language)
    }
    .navigationItemAlignment(.center)
    .navigationBarStyle(.dark)
    .background(.darkBlue.opacity(0.7))
    .position(.fixedTop)
  }
}
