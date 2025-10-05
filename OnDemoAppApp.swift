import SwiftUI

/// Entry point for the OnDemoApp application.
///
/// This struct creates the main window for the app and injects a shared
/// instance of ``CartManager`` into the environment so that all
/// views can access and modify the current cart. The `@main` attribute
/// instructs the Swift compiler to use this struct as the app’s entry
/// point.
@main
struct OnDemoAppApp: App {
    /// Shared cart manager that holds the items added to the cart.
    @State private var cartManager = CartManager()
    
    /// Shared product service that manages product data.
    @State private var productService = ProductService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cartManager)
                .environment(productService)
        }
    }
}

