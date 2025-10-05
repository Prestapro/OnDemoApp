import SwiftUI

/// Displays detailed information about a selected product.
///
/// Enhanced with modern iOS 26 features including quantity controls,
/// stock status, ratings, and improved cart management.
struct ProductDetailView: View {
    @Environment(CartManager.self) private var cartManager
    let product: Product
    @State private var quantity: Int = 1
    @State private var showingAddedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 300)
                    
                    Image(systemName: product.imageName)
                        .font(.system(size: 80))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    // Product Name and Category
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(product.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if !product.isInStock {
                                Text("Out of Stock")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .clipShape(Capsule())
                            }
                        }
                        
                        Text(product.category.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Price and Rating
                    HStack {
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if product.rating > 0 {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                                Text("(\(product.reviewCount))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    // Description
                    Text(product.description)
                        .font(.body)
                        .lineSpacing(4)

                    // Quantity Selector
                    if product.isInStock {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quantity")
                                .font(.headline)
                            
                            HStack {
                                Button(action: {
                                    if quantity > 1 {
                                        quantity -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(quantity > 1 ? .blue : .gray)
                                }
                                .disabled(quantity <= 1)
                                
                                Text("\(quantity)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 40)
                                
                                Button(action: {
                                    quantity += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    // Add to Cart Button
                    if product.isInStock {
                        Button(action: {
                            for _ in 0..<quantity {
                                cartManager.addToCart(product)
                            }
                            showingAddedToCart = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Add \(quantity > 1 ? "\(quantity) " : "")to Cart")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .disabled(!product.isInStock)
                    } else {
                        Button(action: {}) {
                            HStack {
                                Spacer()
                                Text("Out of Stock")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                            .background(Color.gray)
                            .cornerRadius(12)
                        }
                        .disabled(true)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Added to Cart", isPresented: $showingAddedToCart) {
            Button("OK") { }
        } message: {
            Text("\(quantity) \(product.name) added to your cart")
        }
        .onAppear {
            quantity = max(1, cartManager.quantity(for: product))
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(
            name: "Running Shoe",
            description: "Lightweight running shoe with breathable mesh upper and responsive cushioning.",
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