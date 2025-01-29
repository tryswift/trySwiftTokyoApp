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
        .foregroundStyle(.orange)
    }
    .horizontalAlignment(.center)
  }
}

struct SpeakerModal: HTML {
  let speaker: Speaker
  let language: Language
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
            .font(.title2)
            .foregroundStyle(.bootstrapPurple)
          if let bio = speaker.bio {
            Text(bio)
              .font(.body)
              .fontWeight(.regular)
              .foregroundStyle(.dimGray)
          }
          if let link = speaker.links?.first {
            Link(link.name, target: link.url)
              .target(.newWindow)
              .role(.secondary)
          }
        }.margin(.leading, imageSize + 20)
      }
      .padding(.all, 16)
      Grid {
        Button(String(forKey: "close", language: language)) {
          DismissModal(id: speaker.name)
        }
        .role(.light)
        .foregroundStyle(.dimGray)
        Text("try! Swift Tokyo 2025")
          .horizontalAlignment(.trailing)
          .font(.body)
          .fontWeight(.bold)
          .foregroundStyle(.dimGray)
      }
      .columns(2)
      .padding(.all, 16)
    }.size(.large)
  }
}

private extension Speaker {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}
