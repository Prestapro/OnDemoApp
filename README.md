# OnDemoApp - iOS 26 Refactored

A modern iOS shopping app built with SwiftUI and enhanced for iOS 26 with advanced features, improved architecture, and modern design patterns.

## 🚀 What's New in iOS 26 Refactor

### ✨ Modern iOS 26 Features
- **Observation Framework**: Replaced `@ObservableObject` with `@Observable` for better performance
- **Async/Await**: Modern concurrency patterns throughout the app
- **NavigationStack**: Updated navigation with modern iOS patterns
- **ContentUnavailableView**: Enhanced empty states and error handling

### 🏗️ Improved Architecture
- **MVVM Pattern**: Clean separation of concerns with ViewModels and Services
- **Centralized Services**: `ProductService` for data management
- **Enhanced Models**: Rich `Product` model with categories, ratings, and stock status
- **Modular Components**: Reusable UI components for better maintainability

### 🎨 Enhanced UI/UX
- **Modern Design**: Updated with iOS 26 design guidelines
- **Dark Mode Support**: Full support for light and dark themes
- **Smooth Animations**: Custom animation system with haptic feedback
- **Improved Cart**: Quantity controls, better item management
- **Enhanced Search**: Category filtering and real-time search
- **Rich Product Details**: Ratings, stock status, quantity selection

### 🛡️ Robust Error Handling
- **Custom Error Types**: Comprehensive error handling system
- **Validation**: Input validation for forms and data
- **User Feedback**: Clear error messages and recovery suggestions
- **Logging**: Debug logging for better troubleshooting

### 📱 Performance Optimizations
- **Efficient State Management**: Optimized with Observation framework
- **Lazy Loading**: Improved list performance
- **Memory Management**: Better resource handling
- **Smooth Scrolling**: Optimized animations and transitions

## 🏛️ Architecture Overview

```
OnDemoApp/
├── Models/
│   ├── Product.swift          # Enhanced product model
│   └── CartManager.swift      # Modern cart management
├── Services/
│   └── ProductService.swift   # Centralized data service
├── Views/
│   ├── Components/            # Reusable UI components
│   │   ├── ProductRowView.swift
│   │   └── CartItemRowView.swift
│   ├── HomeView.swift         # Enhanced home screen
│   ├── SearchView.swift       # Advanced search with filters
│   ├── CartView.swift         # Improved cart management
│   ├── ProductDetailView.swift # Rich product details
│   └── ProfileView.swift      # Modern profile interface
├── Utils/
│   ├── Theme.swift           # Design system
│   ├── Animations.swift      # Animation utilities
│   └── ErrorHandler.swift    # Error handling system
└── OnDemoAppApp.swift        # App entry point
```

## 🎯 Key Features

### 🛒 Shopping Experience
- **Product Catalog**: Browse products with categories and ratings
- **Smart Search**: Real-time search with category filtering
- **Cart Management**: Add, remove, and adjust quantities
- **Product Details**: Rich product information with stock status

### 🎨 Modern UI
- **Adaptive Design**: Works on all iOS devices
- **Dark Mode**: Full support for system appearance
- **Smooth Animations**: Delightful micro-interactions
- **Haptic Feedback**: Tactile feedback for actions

### 🔧 Developer Experience
- **Clean Code**: Well-documented and maintainable
- **Modular Architecture**: Easy to extend and modify
- **Error Handling**: Comprehensive error management
- **Performance**: Optimized for smooth user experience

## 🚀 Getting Started

1. **Requirements**: iOS 17.0+ (iOS 26 features)
2. **Xcode**: Latest version with iOS 26 SDK
3. **Build**: Open `OnDemoApp.xcodeproj` and build

### 🔐 Code Signing Troubleshooting

If you have imported the bundled `OnDemoApp.p12` certificate but Xcode still reports a
code-signing error, try the following steps:

1. **Install to the Login Keychain**: Double-click the `.p12` file and install it into the
   `login` keychain, making sure the private key appears directly under *My Certificates*.
2. **Trust Settings**: Open Keychain Access, locate the *OnDemoApp* certificate, open the
   info panel, and ensure the certificate is set to *Use System Defaults*. If a warning is
   shown, expand *Trust* and select *Always Trust*, then restart Xcode.
3. **Refresh Signing Assets**: In Xcode, go to *Settings ▸ Accounts*, select your Apple ID,
   and press *Download Manual Profiles* to refresh provisioning profiles that match the
   imported certificate.
4. **Select the Signing Identity**: In the project editor, select the *OnDemoApp* target,
   open the *Signing & Capabilities* tab, and explicitly choose the *OnDemoApp* team and
   signing certificate from the *Signing Certificate* dropdown.
5. **Clean Derived Data**: From the Xcode menu choose *Product ▸ Clean Build Folder* and,
   if the error persists, remove the project's Derived Data from *Settings ▸ Locations ▸
   Derived Data*. Relaunch Xcode before rebuilding.

These steps usually clear residual signing errors after importing a `.p12` file. If the
problem remains, confirm that the provisioning profile includes the correct bundle
identifier (`com.example.OnDemoApp`) and that the certificate has not expired.

## 📱 Screenshots

The app features:
- Modern tab-based navigation
- Rich product listings with ratings
- Advanced search and filtering
- Intuitive cart management
- Beautiful product detail views
- Comprehensive user profile

## 🔮 Future Enhancements

- [ ] User authentication
- [ ] Payment integration
- [ ] Order tracking
- [ ] Push notifications
- [ ] Offline support
- [ ] Social features

## 📄 License

This project is for demonstration purposes and showcases modern iOS development practices with iOS 26.

---

**Built with ❤️ using SwiftUI and iOS 26**