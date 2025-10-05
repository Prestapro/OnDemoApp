import Foundation
import Observation

/// Service responsible for managing product data and operations.
/// Uses the new Observation framework for iOS 26 for better performance.
@Observable
@MainActor
final class ProductService {
    /// Current list of products in the catalog
    var products: [Product] = []
    
    /// Loading state for async operations
    var isLoading: Bool = false
    
    /// Error state for handling failures
    var error: AppError?
    
    private let sampleProducts: [Product] = [
        Product(name: "Running Shoe",
                description: "Lightweight running shoe with breathable mesh upper and responsive cushioning.",
                price: 129.99,
                imageName: "figure.walk",
                category: .shoes,
                isInStock: true,
                rating: 4.5,
                reviewCount: 128),
        Product(name: "Trail Shoe",
                description: "Durable trail running shoe with aggressive tread pattern and waterproof protection.",
                price: 149.99,
                imageName: "hare",
                category: .shoes,
                isInStock: true,
                rating: 4.8,
                reviewCount: 89),
        Product(name: "Cloud Jacket",
                description: "Lightweight running jacket with weather protection and breathable fabric.",
                price: 99.99,
                imageName: "cloud.rain",
                category: .clothing,
                isInStock: true,
                rating: 4.2,
                reviewCount: 67),
        Product(name: "Performance Shorts",
                description: "Moisture-wicking shorts with built-in compression for optimal performance.",
                price: 49.99,
                imageName: "figure.run",
                category: .clothing,
                isInStock: false,
                rating: 4.0,
                reviewCount: 45),
        Product(name: "Hydration Pack",
                description: "Lightweight hydration pack with 2L capacity and multiple storage compartments.",
                price: 79.99,
                imageName: "drop.fill",
                category: .accessories,
                isInStock: true,
                rating: 4.7,
                reviewCount: 156)
    ]
    
    init() {
        Task { @MainActor [weak self] in
            await self?.loadProducts()
        }
    }

    /// Loads products from the data source
    func loadProducts() async {
        isLoading = true
        error = nil

        defer { isLoading = false }

        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            // Simulate occasional network errors (10% chance)
            if Int.random(in: 1...10) == 1 {
                throw AppError.networkError("Failed to load products")
            }

            products = sampleProducts
        } catch {
            self.error = error as? AppError ?? .unknownError
            ErrorHandler.logError(error, context: "ProductService.loadProducts")
        }
    }

    /// Searches for products by name
    /// - Parameter query: Search query string
    /// - Returns: Filtered array of products
    func searchProducts(query: String) -> [Product] {
        guard !query.isEmpty else { return products }
        
        return products.filter { product in
            product.name.localizedCaseInsensitiveContains(query) ||
            product.description.localizedCaseInsensitiveContains(query)
        }
    }
    
    /// Gets a product by its ID
    /// - Parameter id: Product identifier
    /// - Returns: Product if found, nil otherwise
    func getProduct(by id: UUID) -> Product? {
        products.first { $0.id == id }
    }
    
    /// Refreshes the product catalog
    func refreshProducts() async {
        await loadProducts()
    }
}

