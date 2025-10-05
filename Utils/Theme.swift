import SwiftUI

/// Theme configuration for the app with support for light and dark modes.
/// 
/// Provides consistent colors, typography, and spacing throughout the app.
struct Theme {
    // MARK: - Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.secondary
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let groupedBackground = Color(.systemGroupedBackground)
        static let cardBackground = Color(.systemBackground)
        static let border = Color(.separator)
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue
        
        // Product category colors
        static let shoes = Color.blue
        static let clothing = Color.purple
        static let accessories = Color.orange
        static let general = Color.gray
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let full: CGFloat = 999
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let small = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
        static let large = Color.black.opacity(0.15)
    }
}

/// Extension to get category-specific colors
extension Theme.Colors {
    static func categoryColor(for category: ProductCategory) -> Color {
        switch category {
        case .shoes: return shoes
        case .clothing: return clothing
        case .accessories: return accessories
        case .general: return general
        }
    }
}

/// Custom view modifiers for consistent styling
extension View {
    /// Applies card styling with background, corner radius, and shadow
    func cardStyle() -> some View {
        self
            .background(Theme.Colors.cardBackground)
            .cornerRadius(Theme.CornerRadius.lg)
            .shadow(color: Theme.Shadow.small, radius: 1, x: 0, y: 1)
    }
    
    /// Applies primary button styling
    func primaryButtonStyle() -> some View {
        self
            .font(Theme.Typography.headline)
            .foregroundColor(.white)
            .padding(.vertical, Theme.Spacing.md)
            .padding(.horizontal, Theme.Spacing.lg)
            .background(Theme.Colors.primary)
            .cornerRadius(Theme.CornerRadius.md)
    }
    
    /// Applies secondary button styling
    func secondaryButtonStyle() -> some View {
        self
            .font(Theme.Typography.headline)
            .foregroundColor(Theme.Colors.primary)
            .padding(.vertical, Theme.Spacing.md)
            .padding(.horizontal, Theme.Spacing.lg)
            .background(Theme.Colors.primary.opacity(0.1))
            .cornerRadius(Theme.CornerRadius.md)
    }
}