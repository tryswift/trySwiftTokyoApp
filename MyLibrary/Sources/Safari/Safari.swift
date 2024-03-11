import ComposableArchitecture
import SwiftUI
import SafariServices

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
