import Ignite

enum CodeOfConductSectionType: String, CaseIterable {
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

    Text(String(forKey: "code_of_conduct", language: language))
      .horizontalAlignment(.center)
      .font(.title1)
      .fontWeight(.bold)
      .foregroundStyle(.bootstrapPurple)
      .padding(.top, 140)

    ForEach(CodeOfConductSectionType.allCases) { sectionType in
      Section {
        Text(String(forKey: sectionType.rawValue, language: language))
          .horizontalAlignment(.center)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundStyle(.bootstrapPurple)
          .padding(.top, 80)
          .padding(.bottom, 16)

        let description = String(forKey: "\(sectionType.rawValue)_text", language: language)
        Text(markdown: description)
          .horizontalAlignment(description.count > 100 ? .leading : .center)
          .font(.body)
          .foregroundStyle(.dimGray)
      }
    }

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
