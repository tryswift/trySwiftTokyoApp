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

        if page.url.pathComponents.last == "_en" {
          RedirectMetaTag()
        }
      }

      HTMLBody {
        Section(page.body)
      }.class("container")
    }
  }
}

private struct RedirectMetaTag: HeadElement, Sendable {
  var body: some HTML { self }

  func render(context: PublishingContext) -> String {
    """
    <meta http-equiv="refresh" content="0;url=https://tryswift.jp/en/">
    """
  }
}
