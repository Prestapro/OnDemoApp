import Foundation
import Observation

/// Manages the contents of the shopping cart.
///
/// Uses the new Observation framework for iOS 26 for better performance
/// and cleaner code. Provides methods to add, remove and clear items,
/// as well as computed properties for cart statistics.
@Observable
@MainActor
final class CartManager {
    /// List of products currently in the cart with quantities
    private(set) var cartItems: [CartItem] = []
    
    /// Error state for handling cart operations
    var error: Error?
    
    /// Adds a product to the cart or increases its quantity
    func addToCart(_ product: Product) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
    }
    
    /// Removes a product from the cart or decreases its quantity
    func removeFromCart(_ product: Product) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if cartItems[existingIndex].quantity > 1 {
                cartItems[existingIndex].quantity -= 1
            } else {
                cartItems.remove(at: existingIndex)
            }
        }
    }
    
    /// Removes all instances of a product from the cart
    func removeAllInstances(of product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
    }
    
    /// Clears all items from the cart
    func clearCart() {
        cartItems.removeAll()
    }
    
    /// Updates the quantity of a specific product
    func updateQuantity(for product: Product, to quantity: Int) {
        if quantity <= 0 {
            removeAllInstances(of: product)
        } else if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity = quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    /// The total price of all items in the cart
    var total: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    /// The total number of items in the cart
    var itemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    /// The number of unique products in the cart
    var uniqueItemCount: Int {
        cartItems.count
    }
    
    /// Checks if a product is in the cart
    func isInCart(_ product: Product) -> Bool {
        cartItems.contains { $0.product.id == product.id }
    }
    
    /// Gets the quantity of a specific product in the cart
    func quantity(for product: Product) -> Int {
        cartItems.first { $0.product.id == product.id }?.quantity ?? 0
    }
}

/// Represents an item in the cart with its quantity
struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    var quantity: Int
}