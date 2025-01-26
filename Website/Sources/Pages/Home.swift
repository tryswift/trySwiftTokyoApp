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
    NavigationBar {
      Link(String(forKey: "about", language: language), target: "#about")
      Link(String(forKey: "outline", language: language), target: "#outline")
      Link(String(forKey: "tickets", language: language), target: "#tickets")
      Link(String(forKey: "speaker", language: language), target: "#speaker")
      Link(String(forKey: "sponsor", language: language), target: "#sponsor")
    } logo: {
      LanguageSelector(currentLanguage: language)
    }
    .navigationItemAlignment(.center)
    .navigationBarStyle(.dark)
    .background(.darkBlue.opacity(0.7))
    .position(.fixedTop)

    HeaderComponent(language: language)
      .ignorePageGutters()
      .id("about")

    Text(String(forKey: "about_text", language: language))
      .horizontalAlignment(.center)
      .font(.lead)
      .margin(.top, .px(20))
      .margin(.horizontal, .px(50))

    SectionHeader(id: "outline", title: String(forKey: "outline", language: language))
    OutlineComponent(language: language)

    SectionHeader(id: "tickets", title: String(forKey: "tickets", language: language))
    TicketsComponent(language: language)

    SectionHeader(id: "speaker", title: String(forKey: "speaker", language: language))

    let day1 = try! dataClient.fetchDay1()
    let day2 = try! dataClient.fetchDay2()
    let speakers: [Speaker] = [day1, day2]
      .flatMap(\.schedules)
      .flatMap(\.sessions)
      .compactMap(\.speakers)
      .flatMap { $0 }
      .filter { $0.bio != nil }

    CenterAlignedGrid(speakers, columns: 4) { speaker in
      SpeakerComponent(speaker: speaker)
        .margin(.bottom, 32)
        .onClick {
          ShowModal(id: speaker.name)
        }
    }

    Alert {
      speakers.map { speaker in
        SpeakerModal(speaker: speaker, language: language)
      }
    }

    SectionHeader(id: "sponsor", title: String(forKey: "sponsor", language: language))

    let sponsors = try! dataClient.fetchSponsors()
    ForEach(Plan.allCases) { plan in
      Text(plan.rawValue.localizedCapitalized)
        .horizontalAlignment(.center)
        .font(.title2)
        .fontWeight(.bold)
        .padding()

      CenterAlignedGrid(sponsors.allPlans[plan]!, columns: plan.columnCount) { sponsor in
        Section {
          SponsorComponent(sponsor: sponsor, size: plan.maxSize)
        }
      }

      Spacer(size: 160)
    }
  }
}

private extension Plan {
  var columnCount: Int {
    switch self {
    case .platinum, .gold:
      return 3
    case .silver:
      return 4
    case .bronze, .diversityAndInclusion, .community, .student:
      return 5
    case .individual:
      return 6
    }
  }

  var maxSize: CGSize {
    switch self {
    case .platinum:
      return .init(width: 260, height: 146)
    case .gold:
      return .init(width: 200, height: 112)
    case .silver:
      return .init(width: 160, height: 90)
    case .bronze, .diversityAndInclusion, .community, .student:
      return .init(width: 130, height: 72)
    case .individual:
      return .init(width: 100, height: 100)
    }
  }
}
