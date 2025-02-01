import Ignite

enum FAQSectionType: String, CaseIterable {
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
  let language: Language
  let title: String

  init(language: Language) {
    self.language = language
    self.title = String(forKey: "faq", language: language)
  }

  var path: String {
    generatePath(language: language)
  }

  var body: some HTML {
    MainNavigationBar(path: generatePath(language:), language: language)

    Text(String(forKey: "faq", language: language))
      .horizontalAlignment(.center)
      .font(.title1)
      .fontWeight(.bold)
      .foregroundStyle(.bootstrapPurple)
      .padding(.top, 140)

    let sectionTypes = FAQSectionType.allCases.filter { section in
      switch language {
      case .ja: section != .visaSupport
      case .en: true
      }
    }

    ForEach(sectionTypes) { sectionType in
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
    MainFooterWithBackground()
      .margin(.top, 160)
  }

  private func generatePath(language: Language) -> String {
    switch language {
    case .ja: "/faq"
    case .en: "/faq_en"
    }
  }
}
