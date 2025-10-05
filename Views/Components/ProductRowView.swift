import SwiftUI

/// A reusable row view for displaying product information in lists.
/// 
/// This component provides a consistent layout for products across the app
/// with support for ratings, stock status, and cart interactions.
struct ProductRowView: View {
    let product: Product
    @Environment(CartManager.self) private var cartManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Product Image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                
                Image(systemName: product.imageName)
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if !product.isInStock {
                        Text("Out of Stock")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .clipShape(Capsule())
                    }
                }
                
                HStack {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if product.rating > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", product.rating))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                Text(product.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Cart Button
            if product.isInStock {
                Button(action: {
                    withAnimation(AppAnimations.spring) {
                        cartManager.addToCart(product)
                    }
                    HapticFeedback.light()
                }) {
                    Image(systemName: cartManager.isInCart(product) ? "cart.fill" : "cart")
                        .font(.title3)
                        .foregroundColor(cartManager.isInCart(product) ? Theme.Colors.primary : .primary)
                        .scaleEffect(cartManager.isInCart(product) ? 1.1 : 1.0)
                        .animation(AppAnimations.spring, value: cartManager.isInCart(product))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ProductRowView(product: Product(
            name: "Running Shoe",
            description: "Lightweight running shoe",
            price: 129.99,
            imageName: "figure.walk",
            category: .shoes,
            isInStock: true,
            rating: 4.5,
            reviewCount: 128
        ))
        .environment(CartManager())
    }
}