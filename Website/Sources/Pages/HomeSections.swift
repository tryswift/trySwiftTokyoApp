import DataClient
import Foundation
import Ignite
import SharedModels

enum HomeSectionType: String, CaseIterable {
  case about
  case outline
  case tickets
  case speaker
  case sponsor
  case access
}

extension HomeSectionType {
  @MainActor
  @HTMLBuilder
  func generateContents(language: Language, dataClient: DataClient) -> some HTML {
    switch self {
    case .about:
      HeaderComponent(language: language)
        .ignorePageGutters()
        .id(rawValue)

      Text(String(forKey: "about_text", language: language))
        .horizontalAlignment(.center)
        .font(.lead)
        .foregroundStyle(.dimGray)
        .margin(.top, .px(20))
        .margin(.horizontal, .px(50))
    case .outline:
      SectionHeader(type: self, language: language)
      OutlineComponent(language: language)
    case .tickets:
      SectionHeader(type: self, language: language)
      TicketsComponent(language: language)
    case .speaker:
      SectionHeader(type: .speaker, language: language)

      let speakers = try! dataClient.fetchSpeakers()
      CenterAlignedGrid(speakers, columns: 4) { speaker in
        SpeakerComponent(speaker: speaker)
          .margin(.bottom, .px(32))
          .onClick {
            ShowModal(id: speaker.name)
          }
      }

      Text("And more...!")
        .horizontalAlignment(.center)
        .font(.title3)
        .foregroundStyle(.dimGray)
        .margin(.top, .px(32))

      Alert {
        speakers.map { speaker in
          SpeakerModal(speaker: speaker, language: language)
        }
      }
    case .sponsor:
      SectionHeader(type: .sponsor, language: language)

      let sponsors = try! dataClient.fetchSponsors()
      ForEach(Plan.allCases) { plan in
        // TODO: Remove `plan != .individual`
        if let sponsors = sponsors.allPlans[plan], !sponsors.isEmpty, plan != .individual {
          Text(plan.rawValue.localizedCapitalized.uppercased())
            .horizontalAlignment(.center)
            .font(.title1)
            .fontWeight(.bold)
            .foregroundStyle(plan.titleColor)
            .margin(.all, .px(32))

          CenterAlignedGrid(sponsors, columns: plan.columnCount) { sponsor in
            Section {
              SponsorComponent(sponsor: sponsor, size: plan.maxSize, language: language)
            }
          }.margin(.bottom, .px(160))
        }
      }
    case .access:
      AccessComponent(language: language)
        .ignorePageGutters()
        .id(rawValue)
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
