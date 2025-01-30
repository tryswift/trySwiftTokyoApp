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
    let links: [String] = ["about", "outline", "tickets", "speaker", "sponsor", "access"]
    NavigationBar {
      for link in links {
        Link(String(forKey: link, language: language), target: "#\(link)")
          .role(.light)
      }
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
      .foregroundStyle(.dimGray)
      .margin(.top, .px(20))
      .margin(.horizontal, .px(50))

    SectionHeader(id: "outline", title: String(forKey: "outline", language: language))
    OutlineComponent(language: language)

    SectionHeader(id: "tickets", title: String(forKey: "tickets", language: language))
    TicketsComponent(language: language)

    SectionHeader(id: "speaker", title: String(forKey: "speaker", language: language))

    let speakers = try! dataClient.fetchSpeakers()
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
      // TODO: Remove `plan != .individual`
      if let sponsors = sponsors.allPlans[plan], !sponsors.isEmpty, plan != .individual {
        Text(plan.rawValue.localizedCapitalized.uppercased())
          .horizontalAlignment(.center)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundStyle(plan.titleColor)
          .padding()

        CenterAlignedGrid(sponsors, columns: plan.columnCount) { sponsor in
          Section {
            SponsorComponent(sponsor: sponsor, size: plan.maxSize, language: language)
          }
        }.margin(.bottom, 160)
      }
    }

    AccessComponent(language: language)
      .ignorePageGutters()
      .id("access")
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

  var titleColor: Color {
    switch self {
    case .platinum: .lightSlateGray
    case .gold: .goldenrod
    case .silver: .silver
    case .bronze: .saddleBrown
    case .diversityAndInclusion, .student, .community, .individual: .steelBlue
    }
  }
}
