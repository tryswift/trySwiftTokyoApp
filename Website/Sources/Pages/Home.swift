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

    let day1 = try! dataClient.fetchDay1()
    let day2 = try! dataClient.fetchDay2()
    let speakers: [Speaker] = [day1, day2]
      .flatMap(\.schedules)
      .flatMap(\.sessions)
      .compactMap(\.speakers)
      .flatMap { $0 }
    let uniqueSpeakers = Array(Dictionary(grouping: speakers, by: \.name).mapValues { $0.first! }.values)

    Section {
      for speaker in uniqueSpeakers {
        Group() {
          Button(
            Image(speaker.imageFilename, description: speaker.name)
              .resizable()
              .frame(maxWidth: 240, maxHeight: 240)
              .cornerRadius(120)
              .width(64)
              .margin(.bottom, 16)
          ) {
            ShowModal(id: speaker.name)
          }
        }
      }
    }
    .columns(4)
    .horizontalAlignment(.center)

    Alert {
      for speaker in speakers {
        Modal(id: speaker.name) {
          speaker.bio ?? ""
        }
        .size(.large)
      }
    }

    let sponsors = try! dataClient.fetchSponsors()
      for plan in Plan.allCases {
        Text(plan.rawValue.localizedCapitalized)
          .font(.title2)
          .fontWeight(.bold)
          .padding()
          .horizontalAlignment(.center)

        for splittedSponsors in sponsors.allPlans[plan]!.splitBy(subSize: plan.columnCount) {
          Section {
            for sponsor in splittedSponsors {
              Group() {
                var image: InlineElement {
                  Image(sponsor.imageFilename, description: sponsor.name)
                    .resizable()
                    .frame(maxWidth: Int(plan.maxSize.width), maxHeight: Int(plan.maxSize.height))
                    .width(plan.padding)
                    .margin(.bottom, 16)
                }
                if let target = sponsor.link?.absoluteString {
                  Link(image, target: target)
                    .target(.newWindow)
                } else {
                  image
                }
              }
            }
          }
          .columns(splittedSponsors.count)
          .horizontalAlignment(.center)
        }

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

private extension Sponsor {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}

private extension Speaker {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}
