import DataClient
import Dependencies
import Foundation
import Ignite
import SharedModels

struct Home: StaticLayout {
  let language: SupportedLanguage
  var title = ""

  var path: String {
    Home.generatePath(language: language)
  }

  var description: String {
    String(forKey: "description", language: language)
  }

  @Dependency(DataClient.self) var dataClient

  var body: some HTML {
    MainNavigationBar(path: Home.generatePath(language:), language: language)

    ForEach(HomeSectionType.allCases) { sectionType in
      sectionType.generateContents(language: language, dataClient: dataClient)
    }
  }

  static func generatePath(language: SupportedLanguage) -> String {
    switch language {
    case .ja: "/"
    case .en: "/en"
    }
  }
}
