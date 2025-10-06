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
    @AppStorage("settings_notifications_enabled") private var notificationsEnabled = true
    @AppStorage("settings_promotional_notifications") private var promotionalNotificationsEnabled = false
    @AppStorage("settings_language") private var selectedLanguage = "English"
    @AppStorage("settings_text_scale") private var textScale = 1.0
    @AppStorage("settings_preferred_theme") private var preferredThemeRawValue = SettingsTheme.system.rawValue
    @State private var showingResetConfirmation = false

    private let availableLanguages = ["English", "Español", "Deutsch", "Français", "日本語"]

    private var preferredTheme: SettingsTheme {
        get { SettingsTheme(rawValue: preferredThemeRawValue) ?? .system }
        set { preferredThemeRawValue = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    Toggle(isOn: $notificationsEnabled) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Push Notifications")
                            Text("Get notified about order updates")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Toggle(isOn: $promotionalNotificationsEnabled) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Promotions & Offers")
                            Text("Receive personalized deals and discounts")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(!notificationsEnabled)
                    .opacity(notificationsEnabled ? 1 : 0.4)
                }

                Section("Display") {
                    Picker("Appearance", selection: Binding(
                        get: { preferredTheme },
                        set: { preferredTheme = $0 }
                    )) {
                        ForEach(SettingsTheme.allCases) { theme in
                            Text(theme.label).tag(theme)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Text Size")
                            Spacer()
                            Text(textScale.formatted(.number.precision(.fractionLength(1))))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }

                        Slider(value: $textScale, in: 0.8...1.4, step: 0.1) {
                            Text("Text Size")
                        }
                        Text("Adjust how large content appears in the app")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }

                Section("Localization") {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(availableLanguages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                }

                Section("Support") {
                    Link(destination: URL(string: "https://support.demoapp.example")!) {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }

                    Button {
                        showingResetConfirmation = true
                    } label: {
                        Label("Reset Settings", systemImage: "arrow.counterclockwise")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog("Reset all preferences?", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
                Button("Reset", role: .destructive) {
                    resetPreferences()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will restore the default settings for notifications, appearance, and language.")
            }
        }
    }

    private func resetPreferences() {
        let defaults = UserDefaults.standard

        defaults.set(true, forKey: "settings_notifications_enabled")
        defaults.set(false, forKey: "settings_promotional_notifications")
        defaults.set("English", forKey: "settings_language")
        defaults.set(1.0, forKey: "settings_text_scale")
        defaults.set(SettingsTheme.system.rawValue, forKey: "settings_preferred_theme")
    }
}

private enum SettingsTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system:
            return "Match System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
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