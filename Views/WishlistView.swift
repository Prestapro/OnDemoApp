import SwiftUI

struct WishlistView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileManager = UserProfileManager.shared
    
    var body: some View {
        NavigationStack {
            if userProfileManager.wishlistItems.isEmpty {
                ContentUnavailableView(
                    "No Wishlist Items",
                    systemImage: "heart",
                    description: Text("Items you save will appear here.")
                )
            } else {
                List(userProfileManager.wishlistItems) { item in
                    WishlistItemRowView(item: item) {
                        userProfileManager.removeFromWishlist(productId: item.productId)
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
    }
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
                Text(item.productName)
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