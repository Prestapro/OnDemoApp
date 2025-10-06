import Foundation

/// Represents a customer order
struct Order: Identifiable, Codable {
    let id = UUID()
    let orderNumber: String
    let date: Date
    let status: OrderStatus
    let totalAmount: Double
    let items: [OrderItem]
    let shippingAddress: String
    let paymentMethod: String
    
    init(orderNumber: String, date: Date, status: OrderStatus, totalAmount: Double, items: [OrderItem], shippingAddress: String, paymentMethod: String) {
        self.orderNumber = orderNumber
        self.date = date
        self.status = status
        self.totalAmount = totalAmount
        self.items = items
        self.shippingAddress = shippingAddress
        self.paymentMethod = paymentMethod
    }
}

/// Order status enumeration
enum OrderStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .processing: return "blue"
        case .shipped: return "purple"
        case .delivered: return "green"
        case .cancelled: return "red"
        }
    }
}

/// Represents an item within an order
struct OrderItem: Identifiable, Codable {
    let id = UUID()
    let productId: String
    let productName: String
    let price: Double
    let quantity: Int
    let imageURL: String?
    
    var totalPrice: Double {
        return price * Double(quantity)
    }
}

/// Manager for handling orders
@Observable
class OrderManager {
    static let shared = OrderManager()
    
    private(set) var orders: [Order] = []
    
    private init() {
        loadSampleOrders()
    }
    
    /// Load sample orders for demonstration
    private func loadSampleOrders() {
        // Generate some sample orders with realistic product IDs
        let sampleOrders = [
            Order(
                orderNumber: "ORD-001",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                status: .delivered,
                totalAmount: 299.99,
                items: [
                    OrderItem(productId: UUID().uuidString, productName: "iPhone 15 Pro", price: 999.99, quantity: 1, imageURL: "iphone"),
                    OrderItem(productId: UUID().uuidString, productName: "AirPods Pro", price: 249.99, quantity: 1, imageURL: "airpods")
                ],
                shippingAddress: "123 Main St, San Francisco, CA 94102",
                paymentMethod: "Credit Card ****1234"
            ),
            Order(
                orderNumber: "ORD-002",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                status: .shipped,
                totalAmount: 149.99,
                items: [
                    OrderItem(productId: UUID().uuidString, productName: "MacBook Air", price: 1199.99, quantity: 1, imageURL: "laptop")
                ],
                shippingAddress: "123 Main St, San Francisco, CA 94102",
                paymentMethod: "PayPal"
            ),
            Order(
                orderNumber: "ORD-003",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                status: .processing,
                totalAmount: 79.99,
                items: [
                    OrderItem(productId: UUID().uuidString, productName: "Apple Watch", price: 399.99, quantity: 1, imageURL: "watch")
                ],
                shippingAddress: "123 Main St, San Francisco, CA 94102",
                paymentMethod: "Apple Pay"
            )
        ]
        
        orders = sampleOrders
    }
    
    /// Get total number of orders
    var totalOrders: Int {
        return orders.count
    }
    
    /// Get orders by status
    func orders(by status: OrderStatus) -> [Order] {
        return orders.filter { $0.status == status }
    }
    
    /// Add a new order
    func addOrder(_ order: Order) {
        orders.append(order)
    }
}