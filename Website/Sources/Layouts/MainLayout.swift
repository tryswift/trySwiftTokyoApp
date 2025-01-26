import Ignite

struct MainLayout: Layout {
  @Environment(\.siteConfiguration) private var siteConfiguration

  var body: some HTML {
    HTMLDocument {
      HTMLHead(for: page, with: siteConfiguration)

      HTMLBody {
        Section(page.body)
      }.class("container")
    }
  }
}
