import SwiftUI

/// Allows users to search for products by name and category.
///
/// Enhanced with modern iOS 26 features including real-time search,
/// category filtering, and improved search experience.
struct SearchView: View {
    @Environment(ProductService.self) private var productService
    @State private var query: String = ""
    @State private var selectedCategory: ProductCategory? = nil
    @State private var showingCategoryFilter = false

    /// Products that match the current query and category filter
    var filteredProducts: [Product] {
        var products = productService.products
        
        // Filter by category
        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }
        
        // Filter by search query
        if !query.isEmpty {
            products = products.filter { product in
                product.name.localizedCaseInsensitiveContains(query) ||
                product.description.localizedCaseInsensitiveContains(query)
            }
        }
        
        return products
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search products…", text: $query)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button(action: {
                        showingCategoryFilter = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(selectedCategory != nil ? .blue : .primary)
                    }
                }
                .padding()
                
                // Category Filter Chips
                if selectedCategory != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("All")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == nil ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(selectedCategory == nil ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            
                            ForEach(ProductCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: category.iconName)
                                            .font(.caption)
                                        Text(category.rawValue)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == category ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Results
                Group {
                    if productService.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if filteredProducts.isEmpty {
                        ContentUnavailableView(
                            query.isEmpty ? "No Products" : "No Results",
                            systemImage: query.isEmpty ? "tray" : "magnifyingglass",
                            description: Text(query.isEmpty ? 
                                "No products available at the moment." : 
                                "No products match your search."
                            )
                        )
                    } else {
                        List(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductRowView(product: product)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query, prompt: "Search products...")
            .confirmationDialog("Filter by Category", isPresented: $showingCategoryFilter) {
                Button("All Categories") {
                    selectedCategory = nil
                }
                
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Button(category.rawValue) {
                        selectedCategory = category
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            }
            .task {
                if productService.products.isEmpty {
                    productService.loadProducts()
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(CartManager())
            .environment(ProductService())
    }
}