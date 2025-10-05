import SwiftUI

/// The primary landing page for the app.
///
/// Displays a list of featured products with modern iOS 26 features including
/// pull-to-refresh, loading states, and improved error handling.
struct HomeView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(ProductService.self) private var productService
    
    var body: some View {
        NavigationStack {
            Group {
                if productService.isLoading {
                    ProgressView("Loading products...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = productService.error {
                    ErrorView(error: error) {
                        Task {
                            await productService.loadProducts()
                        }
                    }
                } else if productService.products.isEmpty {
                    ContentUnavailableView(
                        "No Products",
                        systemImage: "tray",
                        description: Text("No products available at the moment.")
                    )
                } else {
                    List(productService.products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRowView(product: product)
                        }
                    }
                }
            }
            .navigationTitle("On Store")
            .refreshable {
                await productService.refreshProducts()
            }
            .task {
                if productService.products.isEmpty {
                    await productService.loadProducts()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(CartManager())
            .environment(ProductService())
    }
}