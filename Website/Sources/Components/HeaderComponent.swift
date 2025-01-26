import Ignite

struct HeaderComponent: RootHTML {
  let language: Language

  var body: some HTML {
    ZStack(alignment: .bottom) {
      Image("/images/head.png")
        .resizable()
        .aspectRatio(178 / 100, contentMode: .fit)
        .frame(width: .percent(100%), height: .percent(100%))
        .ignorePageGutters(false)
      Section {
        Section {
          Image("/images/title.png")
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
            Image("/images/intersect.svg")
              .resizable()
          }
          Text(String(forKey: "about", language: language))
            .font(.title1)
            .margin(.bottom, .px(20))
        }
        .horizontalAlignment(.center)
        .ignorePageGutters(false)
      }
    }.background(.darkBlue)
  }
}
