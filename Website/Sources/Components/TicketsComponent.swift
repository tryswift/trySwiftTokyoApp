import Ignite

struct TicketsComponent: HTML {
  let language: Language

  var body: some HTML {
    Section {
      Text(markdown: String(forKey: "tickets_text", language: language))
        .font(.lead)
        .foregroundStyle(.dimGray)
        .margin(.bottom, .px(20))
      Embed(
        title: String(forKey: "tickets", language: language),
        url: "https://lu.ma/embed/event/evt-iaERdyhafeQdV5f/simple"
      )
      .aspectRatio(.square)
      .margin(.bottom, .px(120))
      Text(String(forKey: "official_sns", language: language))
        .font(.title3)
        .foregroundStyle(.dimGray)
        .margin(.bottom, .px(16))
      Link(
        String(forKey: "official_sns_button", language: language),
        target: "https://x.com/tryswiftconf"
      )
      .linkStyle(.button)
      .role(.light)
      .font(.lead)
      .fontWeight(.bold)
      .foregroundStyle(.orangeRed)
    }.horizontalAlignment(.center)
  }
}
