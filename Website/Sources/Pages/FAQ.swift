import Ignite

enum FAQSectionType: String, StringEnum {
  case aboutTrySwift = "about_try_swift"
  case conferenceLanguages = "conference_languages"
  case ticketCancellationPolicy = "ticket_cancellation_policy"
  case ticketTransfer = "ticket_transfer"
  case receiptAndInvoice = "receipt_and_invoice"
  case visaSupport = "visa_support"
  case beginnerParticipation = "beginner_participation"
  case preparationBeforeEvent = "preparation_before_event"
}

struct FAQ: StaticLayout {
  let language: SupportedLanguage
  let title: String

  var path: String {
    generatePath(language: language)
  }

  init(language: SupportedLanguage) {
    self.language = language
    self.title = String(forKey: "faq", language: language)
  }

  var body: some HTML {
    MainNavigationBar(path: generatePath(language:), language: language)

    let sectionTypes = FAQSectionType.allCases.filter { section in
      switch language {
      case .ja: section != .visaSupport
      case .en: true
      }
    }
    SectionListComponent(title: title, dataSource: sectionTypes, language: language)
      .margin(.top, .px(140))

    MainFooterWithBackground(language: language)
      .margin(.top, .px(160))
  }

  private func generatePath(language: SupportedLanguage) -> String {
    switch language {
    case .ja: "/faq"
    case .en: "/faq_en"
    }
  }
}
