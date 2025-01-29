import Ignite

struct OutlineComponent: HTML {
  let language: Language

  var body: some HTML {
    Table {
      Row {
        Column {
          String(forKey: "date_and_time", language: language)
        }
        .fontWeight(.bold)
        .foregroundStyle(.dimGray)
        Column {
          String(forKey: "date_and_time_text", language: language)
        }
        .foregroundStyle(.dimGray)
      }
      Row {
        Column {
          String(forKey: "venue", language: language)
        }
        .fontWeight(.bold)
        .foregroundStyle(.dimGray)
        Column {
          String(forKey: "venue_text", language: language)
        }
        .foregroundStyle(.dimGray)
      }
    }
  }
}
