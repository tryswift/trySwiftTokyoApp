import Ignite

struct SectionHeader: HTML {
  let id: String
  let title: String

  var body: some HTML {
    ZStack(alignment: .center) {
      Text(markdown: "\n---")
      Text(title)
        .horizontalAlignment(.center)
        .font(.title1)
        .fontWeight(.bold)
        .foregroundStyle(.bootstrapPurple)
    }
    .padding(.top, 80)
    .padding(.bottom, 16)
    .id(id)
  }
}
