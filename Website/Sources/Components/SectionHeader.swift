import Ignite

struct SectionHeader: HTML {
  let type: SectionType
  let language: Language

  var body: some HTML {
    ZStack(alignment: .center) {
      Text(markdown: "\n---")
      Text(String(forKey: type.rawValue, language: language))
        .horizontalAlignment(.center)
        .font(.title1)
        .fontWeight(.bold)
        .foregroundStyle(.bootstrapPurple)
    }
    .padding(.top, 80)
    .padding(.bottom, 16)
    .id(type.rawValue)
  }
}
