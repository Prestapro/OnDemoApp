import SwiftUI

/// Displays user profile information with modern iOS 26 features.
///
/// Enhanced with settings, order history, and improved user experience.
struct ProfileView: View {
    @Environment(CartManager.self) private var cartManager
    @State private var showingSettings = false
    @State private var showingOrderHistory = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("John Doe")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Premium Member")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top)
                    
                    // Quick Stats
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(cartManager.uniqueItemCount)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("In Cart")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack {
                            Text("12")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Orders")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack {
                            Text("4.8")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Rating")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ProfileMenuItem(
                            icon: "person.circle",
                            title: "Personal Information",
                            subtitle: "Update your details"
                        ) {
                            // Handle personal info
                        }
                        
                        Divider()
                            .padding(.leading, 50)
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Payment Methods",
                            subtitle: "Manage payment options"
                        ) {
                            // Handle payment methods
                        }
                        
                        Divider()
                            .padding(.leading, 50)
                        
                        ProfileMenuItem(
                            icon: "shippingbox",
                            title: "Order History",
                            subtitle: "View past orders"
                        ) {
                            showingOrderHistory = true
                        }
                        
                        Divider()
                            .padding(.leading, 50)
                        
                        ProfileMenuItem(
                            icon: "heart",
                            title: "Wishlist",
                            subtitle: "Your saved items"
                        ) {
                            // Handle wishlist
                        }
                        
                        Divider()
                            .padding(.leading, 50)
                        
                        ProfileMenuItem(
                            icon: "gearshape",
                            title: "Settings",
                            subtitle: "App preferences"
                        ) {
                            showingSettings = true
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Information")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("john.doe@example.com")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "phone")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("+1 (555) 123-4567")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("San Francisco, CA")
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        // Handle edit profile
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingOrderHistory) {
                OrderHistoryView()
            }
        }
    }
}

/// A reusable menu item component for the profile view
struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Placeholder views for settings and order history
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Settings")
                .navigationTitle("Settings")
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
}

struct OrderHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Order History")
                .navigationTitle("Order History")
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}