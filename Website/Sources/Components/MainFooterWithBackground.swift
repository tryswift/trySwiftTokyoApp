import Ignite

struct MainFooterWithBackground: HTML {
  var body: some HTML {
    ZStack(alignment: .bottom) {
      Section {
        Spacer()
        Image("/images/footer.png", description: "background image of footer")
          .resizable()
          .frame(width: .percent(100%))
      }
      Section {
        MainFooter()
          .foregroundStyle(.white)
        IgniteFooter()
          .foregroundStyle(.white)
      }
      .horizontalAlignment(.center)
      .margin(.top, 160)
    }
    .ignorePageGutters()
    .background(
      Gradient(
        colors: [.limeGreen, .skyBlue],
        type: .linear(angle: 0)
      )
    )
  }
}
