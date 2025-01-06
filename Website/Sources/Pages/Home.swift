import DataClient
import Dependencies
import Foundation
import Ignite
import SharedModels

struct Home: StaticPage {
  let language: Language
  var title = "try! Swift Tokyo 2025"

  @Dependency(DataClient.self) var dataClient

  func body(context: PublishingContext) -> [BlockElement] {
    NavigationBar(logo: Text(String(forKey: "title", language: language)).font(.title1)) {}

    let sponsors = try! dataClient.fetchSponsors()
      for plan in Plan.allCases {
        Text(plan.rawValue.localizedCapitalized)
          .font(.title2)
          .fontWeight(.bold)
          .padding()
          .horizontalAlignment(.center)
        Section {
          for sponsor in sponsors.allPlans[plan]! {
            Image("/images/from_app/\(sponsor.imageName).png", description: sponsor.name)
              .resizable()
              .frame(maxWidth: Int(plan.maxSize.width), maxHeight: Int(plan.maxSize.height))
              .width(plan.padding)
          }
        }
        .columns(plan.columnCount)
        .horizontalAlignment(.center)

        Spacer(size: 160)
      }

    Embed(title: "ticket", url: "https://lu.ma/embed/event/evt-iaERdyhafeQdV5f/simple")
      .aspectRatio(.r16x9)
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

  var padding: Int {
    switch self {
    case .platinum:
      return 90
    case .gold:
      return 88
    case .silver:
      return 72
    case .bronze, .diversityAndInclusion, .community, .student, .individual:
      return 64
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
