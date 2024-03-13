import ComposableArchitecture
import SafariServices
import SwiftUI

@Reducer
public struct Safari {
  @ObservableState
  public struct State: Equatable {
    public var url: URL

    public init(url: URL) {
      self.url = url
    }
  }

  public enum Action {}

  public init() {}
}

public struct SafariView: View {

  public var store: StoreOf<Safari>

  public init(store: StoreOf<Safari>) {
    self.store = store
  }

  public var body: some View {
    SafariViewRepresentation(url: store.url)
  }
}

public struct SafariViewRepresentation: UIViewControllerRepresentable {

  public var url: URL

  public init(url: URL) {
    self.url = url
  }

  public func makeUIViewController(context: Context) -> SFSafariViewController {
    let viewController = SFSafariViewController(url: url)
    return viewController
  }

  public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

  }

  public func makeCoordinator() {
  }
}

public extension View {
  func safari<T: Identifiable & Equatable, V: View>(
    item: Binding<T?>,
    sheetContent: @escaping (T) -> V,
    action: @escaping (T) -> Void
  ) -> some View {
    self.modifier(SafariModifier(item: item, sheetContent: sheetContent, action: action))
  }
}

struct SafariModifier<T: Identifiable & Equatable, V: View>: ViewModifier {
  let item: Binding<T?>
  let sheetContent: (T) -> V
  let action: (T) -> Void
  
  func body(content: Content) -> some View {
    content
      #if os(iOS) || os(macOS)
      .sheet(item: item, content: sheetContent)
      #elseif os(visionOS)
      .onChange(of: item.wrappedValue) { _, newValue in
        guard let newValue else { return }
        action(newValue)
      }
      #endif
  }
}
