import Ignite
import SharedModels

struct SpeakerComponent: HTML {
  let speaker: Speaker

  var body: some HTML {
    Section {
      Image(speaker.imageFilename, description: speaker.name)
        .resizable()
        .frame(maxWidth: 230, maxHeight: 230)
        .cornerRadius(115)
        .margin(.bottom, 16)
      Text(speaker.name)
        .font(.title6)
        .fontWeight(.bold)
    }
    .horizontalAlignment(.center)
  }
}

struct SpeakerModal: HTML {
  let speaker: Speaker
  private let imageSize = 75

  var body: some HTML {
    Modal(id: speaker.name) {
      ZStack(alignment: .topLeading) {
        Image(speaker.imageFilename, description: speaker.name)
          .resizable()
          .frame(maxWidth: imageSize, maxHeight: imageSize)
          .cornerRadius(imageSize / 2)
        Section {
          Text(speaker.name)
            .font(.title1)
          if let bio = speaker.bio {
            Text(bio)
              .font(.body)
          }
          if let link = speaker.links?.first {
            Link(link.name, target: link.url)
              .target(.newWindow)
          }
        }.margin(.leading, imageSize + 20)
      }
      Grid {
        Button("Close") {
          DismissModal(id: speaker.name)
        }
        Text("try! Swift Tokyo 2025")
          .horizontalAlignment(.trailing)
          .font(.body)
      }.columns(2)
    }.size(.large)
  }
}

private extension Speaker {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}
