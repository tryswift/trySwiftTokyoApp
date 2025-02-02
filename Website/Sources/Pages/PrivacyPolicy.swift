import Ignite

enum PrivacyPolicySectionType: String, StringEnum {
  case announcementForUS = "announcement_for_us"
  case definition = "definition"
  case collectionOfPersonalData = "collection_of_personal_data"
  case useOfPersonalData = "use_of_personal_data"
  case managementOfPersonalData = "management_of_personal_data"
  case disclosureAndCorrection = "disclosure_and_correction"
  case changesToPolicy = "changes_to_policy"
  case contactForInquiries = "contact_for_inquiries"
}

struct PrivacyPolicy: StaticLayout {
  let language: SupportedLanguage
  let title: String

  var path: String {
    generatePath(language: language)
  }

  init(language: SupportedLanguage) {
    self.language = language
    self.title = String(forKey: "privacy_policy", language: language)
  }

  var body: some HTML {
    MainNavigationBar(path: generatePath(language:), language: language)

    Text(String(forKey: "privacy_policy_last_updated", language: language))
      .horizontalAlignment(.trailing)
      .font(.body)
      .foregroundStyle(.dimGray)
      .margin(.top, .px(100))

    let sectionTypes = PrivacyPolicySectionType.allCases.filter { section in
      switch language {
      case .ja: section != .announcementForUS
      case .en: true
      }
    }
    SectionListComponent(title: title, dataSource: sectionTypes, language: language)
      .margin(.top, .px(40))

    MainFooterWithBackground(language: language)
      .margin(.top, .px(160))
  }

  private func generatePath(language: SupportedLanguage) -> String {
    switch language {
    case .ja: "/privacy-policy"
    case .en: "/privacy-policy_en"
    }
  }
}
