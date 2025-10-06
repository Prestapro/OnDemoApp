import SwiftUI

struct WishlistView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var wishlistItems: [WishlistItem] = []
    
    var body: some View {
        NavigationStack {
            if wishlistItems.isEmpty {
                ContentUnavailableView(
                    "No Wishlist Items",
                    systemImage: "heart",
                    description: Text("Items you save will appear here.")
                )
            } else {
                List(wishlistItems) { item in
                    WishlistItemRowView(item: item) {
                        removeFromWishlist(item)
                    }
                }
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .onAppear {
            loadWishlistItems()
        }
    }
    
    private func loadWishlistItems() {
        // Sample wishlist items
        wishlistItems = [
            WishlistItem(
                id: "1",
                name: "iPhone 15 Pro",
                price: 999.99,
                imageURL: nil,
                addedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            ),
            WishlistItem(
                id: "2",
                name: "MacBook Air M2",
                price: 1199.99,
                imageURL: nil,
                addedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            )
        ]
    }
    
    private func removeFromWishlist(_ item: WishlistItem) {
        wishlistItems.removeAll { $0.id == item.id }
    }
}

struct WishlistItem: Identifiable {
    let id: String
    let name: String
    let price: Double
    let imageURL: String?
    let addedDate: Date
}

struct WishlistItemRowView: View {
    let item: WishlistItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Product image placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text("Added \(item.addedDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack {
                Button(action: onRemove) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                
                Button("Add to Cart") {
                    // Add to cart functionality
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}