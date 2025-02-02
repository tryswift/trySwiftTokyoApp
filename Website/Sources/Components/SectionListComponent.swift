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
          .padding(.top, 80)
          .padding(.bottom, 16)

        let description = String(forKey: "\(sectionType.rawValue)_text", language: language)
        Text(markdown: description)
          .horizontalAlignment(description.count > 100 ? .leading : .center)
          .font(.body)
          .foregroundStyle(.dimGray)
      }
    }
  }
}
