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
                .badge(cartManager.itemCount > 0 ? cartManager.itemCount : nil)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(CartManager())
            .environment(ProductService())
    }
}