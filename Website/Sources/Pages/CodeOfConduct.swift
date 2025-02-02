import Ignite

enum CodeOfConductSectionType: String, StringEnum {
  case communityParticipation = "community_participation"
  case harassmentFree = "harassment_free"
  case forSpeakers = "for_speakers"
  case forAttendees = "for_attendees"
  case reportingMisconduct = "reporting_misconduct"
  case license = "license"
}

struct CodeOfConduct: StaticLayout {
  let language: Language
  let title: String

  var path: String {
    generatePath(language: language)
  }

  init(language: Language) {
    self.language = language
    self.title = String(forKey: "code_of_conduct", language: language)
  }

  var body: some HTML {
    MainNavigationBar(path: generatePath(language:), language: language)

    let sectionTypes = CodeOfConductSectionType.allCases
    SectionListComponent(title: title, dataSource: sectionTypes, language: language)

    MainFooterWithBackground(language: language)
      .margin(.top, 160)
  }

  private func generatePath(language: Language) -> String {
    switch language {
    case .ja: "/code-of-conduct"
    case .en: "/code-of-conduct_en"
    }
  }
}
