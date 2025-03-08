import Ignite

struct Border: BlockHTML {
  var columnWidth = ColumnWidth.automatic
  var hex: String

  var body: some HTML {
    Text(markdown: "<hr style=\"border: 1px solid \(hex);\">")
  }
}
