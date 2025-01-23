import Ignite
import SharedModels

struct SpeakerCell: HTML {
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

private extension Speaker {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}
