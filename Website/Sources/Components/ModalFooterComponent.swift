import Ignite

struct ModalFooterComponent: HTML {
  let modalId: String
  let language: SupportedLanguage

  var body: some HTML {
    Grid {
      Button(String("Close", language: language)) {
        DismissModal(id: modalId)
      }
      .role(.light)
      .foregroundStyle(.dimGray)
      Text("try! Swift Tokyo 2025")
        .horizontalAlignment(.trailing)
        .font(.body)
        .fontWeight(.bold)
        .foregroundStyle(.dimGray)
    }.columns(2)
  }
}
