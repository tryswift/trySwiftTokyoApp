import Ignite

struct SectionHeader: HTML {
  let type: HomeSectionType
  let language: SupportedLanguage

  var body: some HTML {
    ZStack(alignment: .center) {
      Border(hex: "#6f42c1")
      Text(String(type.rawValue, language: language))
        .horizontalAlignment(.center)
        .font(.title1)
        .fontWeight(.bold)
        .foregroundStyle(.bootstrapPurple)
    }
    .padding(.top, .px(80))
    .padding(.bottom, .px(16))
    .id(type.htmlId)
  }
}
