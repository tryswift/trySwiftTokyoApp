import Ignite

struct MainLayout: Layout {
  @Environment(\.siteConfiguration) private var siteConfiguration
  let title: String
  let ogpLink: String

  var body: some HTML {
    HTMLDocument {
      HTMLHead(for: page, with: siteConfiguration) {
        MetaTag(property: "og:image", content: ogpLink)
        MetaTag(property: "twitter:title", content: title)
        MetaTag(property: "twitter:image", content: ogpLink)
      }

      HTMLBody {
        Section(page.body)
      }.class("container")
    }
  }
}
