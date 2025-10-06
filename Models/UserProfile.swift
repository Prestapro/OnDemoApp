import Foundation

/// User profile information
@Observable
class UserProfile: Codable {
    var name: String
    var email: String
    var phone: String
    var address: String
    var membershipType: MembershipType
    var rating: Double
    var joinDate: Date
    
    init(name: String = "John Doe", 
         email: String = "john.doe@example.com", 
         phone: String = "+1 (555) 123-4567", 
         address: String = "123 Main St, San Francisco, CA 94102",
         membershipType: MembershipType = .premium,
         rating: Double = 4.8,
         joinDate: Date = Date()) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.membershipType = membershipType
        self.rating = rating
        self.joinDate = joinDate
    }
}

/// Membership types
enum MembershipType: String, CaseIterable, Codable {
    case basic = "Basic"
    case premium = "Premium"
    case vip = "VIP"
    
    var displayName: String {
        switch self {
        case .basic: return "Basic Member"
        case .premium: return "Premium Member"
        case .vip: return "VIP Member"
        }
    }
    
    var color: String {
        switch self {
        case .basic: return "gray"
        case .premium: return "blue"
        case .vip: return "purple"
        }
    }
}

/// Payment method information
struct PaymentMethod: Identifiable, Codable {
    let id = UUID()
    var cardNumber: String
    var cardholderName: String
    var expiryDate: String
    var isDefault: Bool
    
    var maskedCardNumber: String {
        let lastFour = String(cardNumber.suffix(4))
        return "**** **** **** \(lastFour)"
    }
}

/// Product review information
struct ProductReview: Identifiable, Codable {
    let id = UUID()
    let productId: String
    let productName: String
    let rating: Int
    let reviewText: String
    let reviewDate: Date
    let orderNumber: String
    
    init(productId: String, productName: String, rating: Int, reviewText: String, orderNumber: String) {
        self.productId = productId
        self.productName = productName
        self.rating = rating
        self.reviewText = reviewText
        self.reviewDate = Date()
        self.orderNumber = orderNumber
    }
}

/// Wishlist item with enhanced functionality
struct WishlistItem: Identifiable, Codable {
    let id = UUID()
    let productId: String
    let productName: String
    let price: Double
    let imageName: String
    let addedDate: Date
    let category: String
    
    init(productId: String, productName: String, price: Double, imageName: String, category: String) {
        self.productId = productId
        self.productName = productName
        self.price = price
        self.imageName = imageName
        self.addedDate = Date()
        self.category = category
    }
}

/// Manager for user profile and settings
@Observable
class UserProfileManager {
    static let shared = UserProfileManager()
    
    var profile: UserProfile
    var paymentMethods: [PaymentMethod] = []
    var wishlistItems: [WishlistItem] = []
    var productReviews: [ProductReview] = []
    
    private init() {
        // Load from UserDefaults or create default
        if let data = UserDefaults.standard.data(forKey: "user_profile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = profile
        } else {
            self.profile = UserProfile()
        }
        
        loadSamplePaymentMethods()
        loadSampleWishlistItems()
        loadSampleReviews()
    }
    
    /// Load sample payment methods
    private func loadSamplePaymentMethods() {
        paymentMethods = [
            PaymentMethod(cardNumber: "1234567890123456", cardholderName: "John Doe", expiryDate: "12/25", isDefault: true),
            PaymentMethod(cardNumber: "9876543210987654", cardholderName: "John Doe", expiryDate: "08/26", isDefault: false)
        ]
    }
    
    /// Load sample wishlist items
    private func loadSampleWishlistItems() {
        // Start with empty wishlist - items will be added when users save them
        wishlistItems = []
    }
    
    /// Load sample reviews
    private func loadSampleReviews() {
        // Start with empty reviews - they will be added when users actually review products
        productReviews = []
    }
    
    /// Save profile to UserDefaults
    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "user_profile")
        }
    }
    
    /// Update profile information
    func updateProfile(name: String, email: String, phone: String, address: String) {
        profile.name = name
        profile.email = email
        profile.phone = phone
        profile.address = address
        saveProfile()
    }
    
    /// Add new payment method
    func addPaymentMethod(_ method: PaymentMethod) {
        if method.isDefault {
            // Remove default from other methods
            for i in 0..<paymentMethods.count {
                paymentMethods[i].isDefault = false
            }
        }
        paymentMethods.append(method)
    }
    
    /// Remove payment method
    func removePaymentMethod(at index: Int) {
        guard index < paymentMethods.count else { return }
        paymentMethods.remove(at: index)
    }
    
    /// Set default payment method
    func setDefaultPaymentMethod(at index: Int) {
        guard index < paymentMethods.count else { return }
        
        // Remove default from all methods
        for i in 0..<paymentMethods.count {
            paymentMethods[i].isDefault = false
        }
        
        // Set new default
        paymentMethods[index].isDefault = true
    }
    
    // MARK: - Wishlist Management
    
    /// Add item to wishlist
    func addToWishlist(productId: String, productName: String, price: Double, imageName: String, category: String) {
        // Check if item already exists
        if !wishlistItems.contains(where: { $0.productId == productId }) {
            let wishlistItem = WishlistItem(
                productId: productId,
                productName: productName,
                price: price,
                imageName: imageName,
                category: category
            )
            wishlistItems.append(wishlistItem)
        }
    }
    
    /// Remove item from wishlist
    func removeFromWishlist(productId: String) {
        wishlistItems.removeAll { $0.productId == productId }
    }
    
    /// Check if item is in wishlist
    func isInWishlist(productId: String) -> Bool {
        return wishlistItems.contains { $0.productId == productId }
    }
    
    // MARK: - Review Management
    
    /// Add product review
    func addReview(productId: String, productName: String, rating: Int, reviewText: String, orderNumber: String) {
        // Remove existing review for this product if any
        productReviews.removeAll { $0.productId == productId }
        
        let review = ProductReview(
            productId: productId,
            productName: productName,
            rating: rating,
            reviewText: reviewText,
            orderNumber: orderNumber
        )
        productReviews.append(review)
    }
    
    /// Get review for product
    func getReview(for productId: String) -> ProductReview? {
        return productReviews.first { $0.productId == productId }
    }
    
    /// Check if product has been reviewed
    func hasReviewed(productId: String) -> Bool {
        return productReviews.contains { $0.productId == productId }
    }
    
    /// Get products that can be reviewed (from orders but not yet reviewed)
    func getReviewableProducts(from orders: [Order]) -> [OrderItem] {
        var reviewableItems: [OrderItem] = []
        
        for order in orders {
            for item in order.items {
                if !hasReviewed(productId: item.productId) {
                    reviewableItems.append(item)
                }
            }
        }
        
        return reviewableItems
    }
}