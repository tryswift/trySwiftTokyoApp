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
        .margin(.bottom, .px(16))
      Text(speaker.name)
        .font(.title4)
        .fontWeight(.medium)
        .foregroundStyle(.orangeRed)
      if let jobTitle = speaker.jobTitle {
        Text(jobTitle)
          .font(.body)
          .fontWeight(.thin)
          .foregroundStyle(.gray)
      }
    }
    .horizontalAlignment(.center)
  }
}

struct SpeakerModal: HTML {
  let speaker: Speaker
  let language: SupportedLanguage
  private let imageSize = 75

  var body: some HTML {
    Modal(id: speaker.modalId) {
      ZStack(alignment: .topLeading) {
        Image(speaker.imageFilename, description: speaker.name)
          .resizable()
          .frame(maxWidth: imageSize, maxHeight: imageSize)
          .cornerRadius(imageSize / 2)
        Section {
          Text(speaker.name)
            .font(.title2)
            .foregroundStyle(.bootstrapPurple)
          if let bio = speaker.getLocalizedBio(language: language) {
            Text(markdown:bio)
              .font(.body)
              .fontWeight(.regular)
              .foregroundStyle(.dimGray)
          }
          if let links = speaker.links {
            Row {
              ForEach(links) { link in
                Link(link.name, target: link.url)
                  .target(.newWindow)
                  .role(.secondary)
                  .margin(.trailing, .px(4))
              }
            }
          }
        }.margin(.leading, .px(imageSize + 20))
      }
      .padding(.all, .px(16))

      Grid {
        Button(String("Close", language: language)) {
          DismissModal(id: speaker.modalId)
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
      .padding(.all, .px(16))
    }.size(.large)
  }
}

extension Speaker {
  func getLocalizedBio(language: SupportedLanguage) -> String? {
    switch language {
    case .ja: japaneseBio
    case .en: bio
    }
  }

  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }

  var modalId: String {
    name.replacingOccurrences(of: "'", with: "")
  }
}
