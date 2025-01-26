import Ignite

struct AccessComponent: RootHTML {
  let language: Language
  private let mapUrl = "https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d12959.484415464616!2d139.4122493!3d35.7047894!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6018e16a387013a3%3A0xcd9c50e33a16ff6b!2sTachikawa%20Stage%20Garden!5e0!3m2!1sen!2sjp!4v1720059016768!5m2!1sen!2sjp"

  var body: some HTML {
    ZStack(alignment: .bottom) {
      Section {
        Spacer()
        Image("/images/footer.png", description: "background image of footer")
          .resizable()
          .frame(width: .percent(100%))
      }
      VStack {
        Text(String(forKey: "access", language: language))
          .horizontalAlignment(.center)
          .font(.title1)
          .foregroundStyle(.white)
          .padding(.vertical, 80)

        Grid {
          Image("/images/tachikawa_stage_garden.jpg", description: "images of the venue")
            .resizable()
            .aspectRatio(3 / 2, contentMode: .fit)
            .margin(.bottom, 16)
          Embed(title: "map", url: mapUrl)
            .aspectRatio(.r4x3)
            .frame(width: .percent(90%))
            .margin(.bottom, 16)
        }
        .columns(2)
        .horizontalAlignment(.center)
        .frame(width: .percent(100%))
        .padding(.bottom, 8)

        Section {
          Text(String(forKey: "venue_name", language: language))
            .font(.title2)
            .foregroundStyle(.white)
          Text(String(forKey: "venue_address", language: language))
            .font(.lead)
            .foregroundStyle(.white)
        }
        .horizontalAlignment(.leading)

        Section {
          MainFooter()
            .foregroundStyle(.white)
          IgniteFooter()
            .foregroundStyle(.white)
        }.margin(.top, 160)
      }
      .frame(width: .percent(100%))
      .ignorePageGutters(false)
    }
    .background(
      Gradient(
        colors: [.limeGreen, .skyBlue],
        type: .linear(angle: 0)
      )
    )
  }
}
