import Ignite

struct OutlineComponent: HTML {
  let language: SupportedLanguage

  var body: some HTML {
    Table {
      Row {
        Column {
          String("Date and time", language: language)
        }
        .fontWeight(.bold)
        .foregroundStyle(.dimGray)
        Column {
          String("Apr. 9th - 11th, 2025", language: language)
        }
        .foregroundStyle(.dimGray)
      }
      Row {
        Column {
          String("Venue", language: language)
        }
        .fontWeight(.bold)
        .foregroundStyle(.dimGray)
        Column {
          String("TACHIKAWA STAGE GARDEN<br>N1, 3-3, Midori-cho, Tachikawa, Tokyo 190-0014", language: language)
        }
        .foregroundStyle(.dimGray)
      }
    }
  }
}
