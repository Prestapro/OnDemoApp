import Foundation

/// A model representing a product in the store.
///
/// Each product has a unique identifier, a name, description, price and
/// the name of a system image to display. Enhanced for iOS 26 with
/// better conformance to protocols and additional metadata.
struct Product: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: ProductCategory
    let isInStock: Bool
    let rating: Double
    let reviewCount: Int
    
    init(name: String, description: String, price: Double, imageName: String, 
         category: ProductCategory = .general, isInStock: Bool = true, 
         rating: Double = 0.0, reviewCount: Int = 0) {
        self.name = name
        self.description = description
        self.price = price
        self.imageName = imageName
        self.category = category
        self.isInStock = isInStock
        self.rating = rating
        self.reviewCount = reviewCount
    }
}

/// Categories for product organization
enum ProductCategory: String, CaseIterable, Codable {
    case shoes = "Shoes"
    case clothing = "Clothing"
    case accessories = "Accessories"
    case general = "General"
    
    var iconName: String {
        switch self {
        case .shoes: return "shoe.2"
        case .clothing: return "tshirt"
        case .accessories: return "bag"
        case .general: return "star"
        }
    }
}