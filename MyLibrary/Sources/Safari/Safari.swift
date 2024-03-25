import ComposableArchitecture
import SafariServices
import SwiftUI

#if os(iOS) || os(visionOS)
fileprivate typealias ViewRepresentable = UIViewControllerRepresentable
#elseif os(macOS)
fileprivate typealias ViewRepresentable = NSViewRepresentable
#endif

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

public struct SafariViewRepresentation: ViewRepresentable {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
#if os(iOS) || os(watchOS) || os(tvOS)
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
   
    
#elseif os(macOS)
    
    public func makeNSView(context: Context) -> some NSView {
        let viewController = NSView()
        return viewController
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {}
    
#endif
    
    public func makeCoordinator() {
    }
    
    
}
