import DataClient
import Dependencies
import Foundation
import Ignite
import SharedModels

struct Home: StaticLayout {
  let language: Language
  var title = "try! Swift Tokyo 2025"

  var path: String {
    Home.generatePath(language: language)
  }

  @Dependency(DataClient.self) var dataClient

  var body: some HTML {
    MainNavigationBar(path: Home.generatePath(language:), language: language)

    ForEach(HomeSectionType.allCases) { sectionType in
      sectionType.generateContents(language: language, dataClient: dataClient)
    }
  }

  static func generatePath(language: Language) -> String {
    switch language {
    case .ja: "/"
    case .en: "/en"
    }
  }
}
