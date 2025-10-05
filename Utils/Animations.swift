import SwiftUI

/// Custom animations for the app with consistent timing and easing.
struct AppAnimations {
    // MARK: - Timing
    static let quick: Double = 0.2
    static let standard: Double = 0.3
    static let slow: Double = 0.5
    static let verySlow: Double = 0.8
    
    // MARK: - Easing
    static let easeInOut = Animation.easeInOut(duration: standard)
    static let easeOut = Animation.easeOut(duration: standard)
    static let easeIn = Animation.easeIn(duration: standard)
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.9)
    
    // MARK: - Specific Animations
    static let fadeIn = Animation.easeIn(duration: quick)
    static let fadeOut = Animation.easeOut(duration: quick)
    static let slideIn = Animation.easeOut(duration: standard)
    static let slideOut = Animation.easeIn(duration: standard)
    static let scaleIn = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let scaleOut = Animation.easeIn(duration: quick)
}

/// Custom view modifiers for animations
extension View {
    /// Applies a fade in animation
    func fadeIn(delay: Double = 0) -> some View {
        self
            .opacity(0)
            .animation(AppAnimations.fadeIn.delay(delay), value: UUID())
            .onAppear {
                withAnimation(AppAnimations.fadeIn.delay(delay)) {
                    // Animation will be triggered by the value change
                }
            }
    }
    
    /// Applies a slide in animation from the specified edge
    func slideIn(from edge: Edge, delay: Double = 0) -> some View {
        self
            .offset(
                x: edge == .leading ? -UIScreen.main.bounds.width : 
                   edge == .trailing ? UIScreen.main.bounds.width : 0,
                y: edge == .top ? -UIScreen.main.bounds.height : 
                   edge == .bottom ? UIScreen.main.bounds.height : 0
            )
            .animation(AppAnimations.slideIn.delay(delay), value: UUID())
            .onAppear {
                withAnimation(AppAnimations.slideIn.delay(delay)) {
                    // Animation will be triggered by the value change
                }
            }
    }
    
    /// Applies a scale animation
    func scaleIn(delay: Double = 0) -> some View {
        self
            .scaleEffect(0)
            .animation(AppAnimations.scaleIn.delay(delay), value: UUID())
            .onAppear {
                withAnimation(AppAnimations.scaleIn.delay(delay)) {
                    // Animation will be triggered by the value change
                }
            }
    }
    
    /// Applies a bounce animation
    func bounceIn(delay: Double = 0) -> some View {
        self
            .scaleEffect(0)
            .animation(AppAnimations.bouncy.delay(delay), value: UUID())
            .onAppear {
                withAnimation(AppAnimations.bouncy.delay(delay)) {
                    // Animation will be triggered by the value change
                }
            }
    }
}

/// Haptic feedback utilities
struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}