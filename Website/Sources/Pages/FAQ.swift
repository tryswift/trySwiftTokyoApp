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
    switch language {
    case .ja: return "/faq"
    case .en: return "/faq_en"
    }
  }

  var body: some HTML {
    MainNavigationBar(language: language)

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

    ZStack(alignment: .bottom) {
      Section {
        Spacer()
        Image("/images/footer.png", description: "background image of footer")
          .resizable()
          .frame(width: .percent(100%))
      }
      Section {
        MainFooter()
          .foregroundStyle(.white)
        IgniteFooter()
          .foregroundStyle(.white)
      }
      .horizontalAlignment(.center)
      .margin(.top, 160)
    }
    .ignorePageGutters()
    .margin(.top, 160)
    .background(
      Gradient(
        colors: [.limeGreen, .skyBlue],
        type: .linear(angle: 0)
      )
    )
  }
}
