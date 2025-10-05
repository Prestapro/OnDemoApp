import Foundation
import SwiftUI

/// Custom error types for the app
enum AppError: LocalizedError, Identifiable {
    case networkError(String)
    case validationError(String)
    case cartError(String)
    case productError(String)
    case unknownError
    
    var id: String { localizedDescription }
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .cartError(let message):
            return "Cart Error: \(message)"
        case .productError(let message):
            return "Product Error: \(message)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .validationError:
            return "Please check your input and try again."
        case .cartError:
            return "Please try again or contact support if the problem persists."
        case .productError:
            return "The product may be temporarily unavailable. Please try again later."
        case .unknownError:
            return "Please try again or contact support if the problem persists."
        }
    }
}

/// Error handling utilities
struct ErrorHandler {
    /// Shows an error alert
    static func showError(_ error: AppError, in viewController: UIViewController? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            if let recoverySuggestion = error.recoverySuggestion {
                alert.message = "\(error.localizedDescription)\n\n\(recoverySuggestion)"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if let viewController = viewController {
                viewController.present(alert, animated: true)
            } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }
    
    /// Logs an error for debugging
    static func logError(_ error: Error, context: String = "") {
        print("🚨 Error in \(context): \(error.localizedDescription)")
        #if DEBUG
        print("Stack trace: \(Thread.callStackSymbols)")
        #endif
    }
}

/// Validation utilities
struct Validator {
    /// Validates email format
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validates phone number format
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone.replacingOccurrences(of: " ", with: ""))
    }
    
    /// Validates price format
    static func isValidPrice(_ price: String) -> Bool {
        guard let priceValue = Double(price), priceValue >= 0 else { return false }
        return true
    }
    
    /// Validates quantity
    static func isValidQuantity(_ quantity: Int) -> Bool {
        return quantity > 0 && quantity <= 999
    }
}

/// Error view for displaying errors in SwiftUI
struct ErrorView: View {
    let error: AppError
    let retryAction: (() -> Void)?
    
    init(error: AppError, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(Theme.Colors.error)
            
            Text("Something went wrong")
                .font(Theme.Typography.title2)
                .multilineTextAlignment(.center)
            
            Text(error.localizedDescription)
                .font(Theme.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let recoverySuggestion = error.recoverySuggestion {
                Text(recoverySuggestion)
                    .font(Theme.Typography.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction = retryAction {
                Button("Try Again", action: retryAction)
                    .primaryButtonStyle()
            }
        }
        .padding(Theme.Spacing.lg)
    }
}