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
                // CheckoutView() // TODO: Add CheckoutView to project
                Text("Checkout functionality coming soon!")
                    .navigationTitle("Checkout")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingCheckout = false
                            }
                        }
                    }
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environment(CartManager())
    }
}