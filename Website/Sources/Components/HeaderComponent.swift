import Ignite

struct HeaderComponent: RootHTML {
  let language: Language

  var body: some HTML {
    ZStack(alignment: .bottom) {
      Image("/images/head.png", description: "background image of header")
        .resizable()
        .aspectRatio(178 / 100, contentMode: .fit)
        .frame(width: .percent(100%), height: .percent(100%))
        .ignorePageGutters(false)
      Section {
        Section {
          Image("/images/title.png", description: "title image")
            .resizable()
            .aspectRatio(260 / 100, contentMode: .fit)
            .frame(width: .percent(50%))
            .margin(.top, .px(100))
        }
        .frame(width: .percent(100%))
        .ignorePageGutters(false)
        ZStack(alignment: .bottom) {
          Section {
            Spacer()
            Image("/images/intersect.svg", description: "decoration image of header")
              .resizable()
          }
          Text(String(forKey: "about", language: language))
            .font(.title1)
            .fontWeight(.bold)
            .foregroundStyle(.bootstrapPurple)
            .margin(.bottom, .px(20))
        }
        .horizontalAlignment(.center)
        .ignorePageGutters(false)
      }
    }.background(.darkBlue)
  }
}
