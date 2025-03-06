import Ignite

struct MainLayout: Layout {
  @Environment(\.siteConfiguration) private var siteConfiguration
  let title: String
  let ogpLink: String

  var body: some HTML {
    HTMLDocument {
      HTMLHead(for: page, with: siteConfiguration) {
        MetaTag(name: "og:image", content: ogpLink)
        MetaTag(name: "twitter:title", content: title)
        MetaTag(name: "twitter:image", content: ogpLink)
      }

      HTMLBody {
        Section(page.body)
      }.class("container")
    }
  }
}
