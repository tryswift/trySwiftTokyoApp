import DataClient
import Dependencies
import Foundation
import Ignite
import SharedModels

struct Home: StaticLayout {
  let language: Language
  var title = "try! Swift Tokyo 2025"

  var path: String {
    switch language {
    case .ja: return "/"
    case .en: return "/en"
    }
  }

  @Dependency(DataClient.self) var dataClient

  var body: some HTML {
    MainNavigationBar(language: language)

    ForEach(HomeSectionType.allCases) { sectionType in
      sectionType.generateContents(language: language, dataClient: dataClient)
    }
  }
}
