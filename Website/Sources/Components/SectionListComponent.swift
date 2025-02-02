import Foundation
import Ignite

protocol StringEnum: RawRepresentable, CaseIterable where RawValue == String {}

struct SectionListComponent: HTML {
  let title: String
  let dataSource: [any StringEnum]
  let language: Language

  var body: some HTML {
    Text(title)
      .horizontalAlignment(.center)
      .font(.title1)
      .fontWeight(.bold)
      .foregroundStyle(.bootstrapPurple)

    ForEach(dataSource) { sectionType in
      Section {
        Text(String(forKey: sectionType.rawValue, language: language))
          .horizontalAlignment(.center)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundStyle(.bootstrapPurple)
          .margin(.top, .px(80))
          .margin(.bottom, .px(16))

        let description = String(forKey: "\(sectionType.rawValue)_text", language: language)
        Text(markdown: description)
          .horizontalAlignment(description.displayedCharacterCount() > 100 ? .leading : .center)
          .font(.body)
          .foregroundStyle(.dimGray)
      }
    }
  }
}

private extension String {
  func displayedCharacterCount() -> Int {
    guard let data = self.data(using: .utf8) else {
      return .zero
    }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)

    return attributedString?.string.count ?? .zero
  }
}
