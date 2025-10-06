import SwiftUI

/// Shows the contents of the user's shopping cart.
///
/// Enhanced with modern iOS 26 features including quantity controls,
/// improved empty state, and better cart management.
struct CartView: View {
    @Environment(CartManager.self) private var cartManager
    @State private var showingClearConfirmation = false
    @State private var showingCheckout = false

    var body: some View {
        NavigationStack {
            Group {
                if cartManager.cartItems.isEmpty {
                    ContentUnavailableView(
                        "Your Cart is Empty",
                        systemImage: "cart",
                        description: Text("Add some products to get started!")
                    )
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(cartManager.cartItems) { cartItem in
                                CartItemRowView(cartItem: cartItem)
                            }
                        }
                        
                        // Cart Summary
                        VStack(spacing: 12) {
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(cartManager.itemCount) items")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Total: $\(cartManager.total, specifier: "%.2f")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                                
                                Button("Checkout") {
                                    showingCheckout = true
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                            }
                            .padding()
                        }
                        .background(Color(.systemBackground))
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !cartManager.cartItems.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            showingClearConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .confirmationDialog("Clear Cart", isPresented: $showingClearConfirmation) {
                Button("Clear All Items", role: .destructive) {
                    cartManager.clearCart()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to remove all items from your cart?")
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutSheetView()
            }
        }
    }
}

struct CheckoutSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CartManager.self) private var cartManager
    @State private var userProfileManager = UserProfileManager.shared
    @State private var orderManager = OrderManager.shared
    @State private var selectedPaymentMethod: PaymentMethod?
    @State private var showingOrderConfirmation = false
    @State private var isProcessingOrder = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Order Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Summary")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ForEach(cartManager.cartItems) { cartItem in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cartItem.product.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("Qty: \(cartItem.quantity)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("$\(cartItem.product.price * Double(cartItem.quantity), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total (\(cartManager.itemCount) items)")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("$\(cartManager.total, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Shipping Address
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shipping Address")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            Text(userProfileManager.profile.address)
                                .font(.subheadline)
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Payment Method
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        if let selectedPayment = selectedPaymentMethod {
                            HStack {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(selectedPayment.maskedCardNumber)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(selectedPayment.cardholderName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if selectedPayment.isDefault {
                                    Text("DEFAULT")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        } else {
                            Text("No payment method selected")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Place Order Button
                    Button(action: {
                        placeOrder()
                    }) {
                        HStack {
                            if isProcessingOrder {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            
                            Text(isProcessingOrder ? "Processing..." : "Place Order")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPaymentMethod != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(selectedPaymentMethod == nil || isProcessingOrder)
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadDefaultPaymentMethod()
            }
            .alert("Order Placed Successfully!", isPresented: $showingOrderConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your order has been placed and you will receive a confirmation email shortly.")
            }
        }
    }
    
    private func loadDefaultPaymentMethod() {
        selectedPaymentMethod = userProfileManager.paymentMethods.first { $0.isDefault }
    }
    
    private func placeOrder() {
        guard let paymentMethod = selectedPaymentMethod else { return }
        
        isProcessingOrder = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Create order from cart items
            let orderItems = cartManager.cartItems.map { cartItem in
                OrderItem(
                    productId: cartItem.product.id.uuidString,
                    productName: cartItem.product.name,
                    price: cartItem.product.price,
                    quantity: cartItem.quantity,
                    imageURL: cartItem.product.imageName
                )
            }
            
            // Generate order number
            let orderNumber = "ORD-\(String(Int.random(in: 1000...9999)))"
            
            // Create new order
            let newOrder = Order(
                orderNumber: orderNumber,
                date: Date(),
                status: .pending,
                totalAmount: cartManager.total,
                items: orderItems,
                shippingAddress: userProfileManager.profile.address,
                paymentMethod: paymentMethod.maskedCardNumber
            )
            
            // Add order to manager
            orderManager.addOrder(newOrder)
            
            // Clear cart
            cartManager.clearCart()
            
            // Show confirmation
            isProcessingOrder = false
            showingOrderConfirmation = true
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environment(CartManager())
    }
}