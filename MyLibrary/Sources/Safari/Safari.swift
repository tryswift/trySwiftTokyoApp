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

extension UIApplication {
  var firstKeyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
          .compactMap { $0 as? UIWindowScene }
          .filter { $0.activationState == .foregroundActive }
          .first?.keyWindow
  }
    
  public func openInSFSafariViewIfEnabled(url: URL) -> Bool {
    #if os(iOS) || os(macOS)
      let viewController = SFSafariViewController(url: url)
      firstKeyWindow?.rootViewController?.present(viewController, animated: true)
      return true
    #elseif os(visionOS)
      return false
    #endif
  }
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
