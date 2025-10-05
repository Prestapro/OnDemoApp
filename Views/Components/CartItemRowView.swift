import SwiftUI

/// A row view for displaying items in the shopping cart.
/// 
/// Provides quantity controls and remove functionality for cart items.
struct CartItemRowView: View {
    let cartItem: CartItem
    @Environment(CartManager.self) private var cartManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Product Image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 50, height: 50)
                
                Image(systemName: cartItem.product.imageName)
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("$\(cartItem.product.price, specifier: "%.2f") each")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Subtotal: $\(cartItem.product.price * Double(cartItem.quantity), specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Quantity Controls
            HStack(spacing: 8) {
                Button(action: {
                    withAnimation(AppAnimations.spring) {
                        cartManager.removeFromCart(cartItem.product)
                    }
                    HapticFeedback.light()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundColor(cartItem.quantity > 1 ? Theme.Colors.primary : Theme.Colors.error)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(cartItem.quantity)")
                    .font(.headline)
                    .frame(minWidth: 20)
                    .animation(AppAnimations.easeInOut, value: cartItem.quantity)
                
                Button(action: {
                    withAnimation(AppAnimations.spring) {
                        cartManager.addToCart(cartItem.product)
                    }
                    HapticFeedback.light()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(Theme.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Remove Button
            Button(action: {
                withAnimation(AppAnimations.easeOut) {
                    cartManager.removeAllInstances(of: cartItem.product)
                }
                HapticFeedback.medium()
            }) {
                Image(systemName: "trash")
                    .font(.title3)
                    .foregroundColor(Theme.Colors.error)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        CartItemRowView(cartItem: CartItem(
            product: Product(
                name: "Running Shoe",
                description: "Lightweight running shoe",
                price: 129.99,
                imageName: "figure.walk",
                category: .shoes,
                isInStock: true,
                rating: 4.5,
                reviewCount: 128
            ),
            quantity: 2
        ))
        .environment(CartManager())
    }
}