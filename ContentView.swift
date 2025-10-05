import SwiftUI

/// Root view that defines the tab-based navigation structure.
///
/// Enhanced with modern iOS 26 features including cart badge indicators
/// and improved tab styling.
struct ContentView: View {
    @Environment(CartManager.self) private var cartManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            CartView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }
                .optionalBadge(cartManager.itemCount)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

private extension View {
    /// Conditionally applies a badge modifier when the provided count is greater than zero.
    /// - Parameter count: The badge value to display.
    /// - Returns: Either the original view or the view with a badge applied.
    @ViewBuilder
    func optionalBadge(_ count: Int) -> some View {
        if count > 0 {
            self.badge(count)
        } else {
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(CartManager())
            .environment(ProductService())
    }
}