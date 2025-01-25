import Foundation
import Ignite
import SharedModels

struct SponsorComponent: HTML {
  let sponsor: Sponsor
  let size: CGSize

  var body: some HTML {
    var image: any InlineHTML {
      Image(sponsor.imageFilename, description: sponsor.name)
        .resizable()
        .frame(maxWidth: Int(size.width), maxHeight: Int(size.height))
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

private extension Sponsor {
  var imageFilename: String {
    "/images/from_app/\(imageName).png"
  }
}
