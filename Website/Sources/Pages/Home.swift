import DataClient
import Dependencies
import Foundation
import Ignite
import SharedModels

struct Home: StaticLayout {
  let language: Language
  var title = "try! Swift Tokyo 2025"

  @Dependency(DataClient.self) var dataClient

  var body: some HTML {
    NavigationBar(logo: Text(String(forKey: "title", language: language)).font(.title1)) {}

    let day1 = try! dataClient.fetchDay1()
    let day2 = try! dataClient.fetchDay2()
    let speakers: [Speaker] = [day1, day2]
      .flatMap(\.schedules)
      .flatMap(\.sessions)
      .compactMap(\.speakers)
      .flatMap { $0 }
      .filter { $0.bio != nil }

    // This is a workaround to center when the number of elements is less than `columns`
    let splittedSpeakers = speakers.splitBy(subSize: 4)
    ForEach(splittedSpeakers) { speakers in
      Grid {
        ForEach(speakers) { speaker in
          SpeakerCell(speaker: speaker)
            .margin(.bottom, 32)
            .onClick {
              ShowModal(id: speaker.name)
            }
        }
      }
      .columns(speakers.count)
    }

    Alert {
      speakers.map { speaker in
        Modal(id: speaker.name) {
          speaker.bio ?? ""
        }
        .size(.large)
      }
    }

    let sponsors = try! dataClient.fetchSponsors()
    ForEach(Plan.allCases) { plan in
      Text(plan.rawValue.localizedCapitalized)
        .horizontalAlignment(.center)
        .font(.title2)
        .fontWeight(.bold)
        .padding()

      // This is a workaround to center when the number of elements is less than `columns`
      let splittedSponsors = sponsors.allPlans[plan]!.splitBy(subSize: plan.columnCount)
      ForEach(splittedSponsors) { sponsors in
        Grid {
          ForEach(sponsors) { sponsor in
            var image: any InlineHTML {
              Image(sponsor.imageFilename, description: sponsor.name)
                .resizable()
                .frame(maxWidth: Int(plan.maxSize.width), maxHeight: Int(plan.maxSize.height))
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
        .columns(sponsors.count)
        .horizontalAlignment(.center)
        .padding(.horizontal, plan.padding)
      }

      Spacer(size: 160)
    }

    Embed(title: "ticket", url: "https://lu.ma/embed/event/evt-iaERdyhafeQdV5f/simple")
      .aspectRatio(.square)
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
