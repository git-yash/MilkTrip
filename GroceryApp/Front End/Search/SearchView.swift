//
//  SearchView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//


import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var searchText: String = ""
    @FocusState private var searchFieldIsFocused: Bool
    @State private var isNavigationActive = false
    @ObservedObject var reloadViewHelper = ReloadViewHelper()
    @State var suggestedProducts: [Product] = []
    @State private var isShowingScanner = false
    @State private var scannedBarcode = ""
    @State var navigateToProductView: Bool = false


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Search Bar
                    TextField("Search Products...", text: $searchText)
                        .padding(8)
                        .padding(.horizontal, 24)
                        .background(Color(hex: "#393e46"))
                        .cornerRadius(8)
                        .focused($searchFieldIsFocused)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                
                                if !searchText.isEmpty {
                                    Button(action: {
                                        searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                
                    // Barcode Scanner Section
                    Button {
                        isShowingScanner = true
                    } label: {
                        HStack{
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 2){
                                Text("Scan a barcode")
                                    .bold()
                                Text("Take a picture, view a product's details")
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .padding()
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    // Show Coupons when search bar is NOT focused and search text is empty
                    if !searchFieldIsFocused && searchText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Coupons")
                                .font(.system(size: 24))
                                .bold()
                            
                            CouponCarousel(coupons: viewModel.coupons)
                            
                            Text("Suggested Products")
                                .font(.system(size: 24))
                                .bold()
                                .padding(.top, 10)
                            
                            // Display suggested products
                            ForEach(suggestedProducts, id: \.self) { product in
                                NavigationLink {
                                    ProductView(product: product)
                                        .onDisappear{
                                            reloadViewHelper.reloadView()
                                        }
                                } label: {
                                    ProductListView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Show Previous Searches when search bar is focused and search text is empty
                    if searchFieldIsFocused && searchText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Previous Searches")
                                .font(.system(size: 24))
                                .bold()
                            
                            let recent_searches = viewModel.localUser.recent_searches
                            if recent_searches.isEmpty {
                                HStack {
                                    Text("No recent searches")
                                        .font(.system(size: 14))
                                        .padding()
                                    Spacer()
                                }
                                    .background(Color(hex: "#393e46"))
                                    .cornerRadius(5)
                            } else {
                                ForEach(recent_searches, id: \.self) { search in
                                    HStack {
                                        Text(search)
                                            .font(.system(size: 14))
                                            .onTapGesture {
                                                // Set search text and focus the search bar
                                                searchText = search
                                                searchFieldIsFocused = true
                                            }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            // Remove the search from the list of recent searches
                                            if let index = viewModel.localUser.recent_searches.firstIndex(of: search) {
                                                viewModel.localUser.recent_searches.remove(at: index)
                                            }
                                            reloadViewHelper.reloadView()
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding()
                                    .background(Color(hex: "#393e46"))
                                    .cornerRadius(5)
                                }
                            }
                        }
                    }
                    
                    // Show Search Results when search bar is focused and search text is NOT empty
                    if searchFieldIsFocused && !searchText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Search Results")
                                .font(.system(size: 24))
                                .bold()
                            
                            let results = getSearchResults(searchText: searchText)
                            
                            // Display search results with custom navigation handling
                            ForEach(results, id: \.self) { product in
                                NavigationLink {
                                    ProductView(product: product)
                                        .onDisappear {
                                            // Append the search text and trigger navigation
                                            if !viewModel.localUser.recent_searches.contains(product.name) {
                                                viewModel.localUser.recent_searches.append(product.name)
                                            }
                                            isNavigationActive = true  // Trigger the navigation
                                        }
                                } label: {
                                    ProductListView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
                
                NavigationLink(destination: ProductView(product: Product(id: 1000, name: "Nutri Grain Bar", brand: "Kellogs", category: "Snacks", store: 2, image_url: "https://s7d6.scene7.com/is/image/bjs/12332", priceData: generatePriceIncrements(base_price: 4.50, store_index: 2))), isActive: $navigateToProductView) {
                    EmptyView() // This link is not shown in the UI
                }

            }
            .navigationTitle("Search Products")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                searchFieldIsFocused = true
                generateSuggestedProducts()  // Generate random products when view appears
            }
            .withScreenBackground()
            .sheet(isPresented: $isShowingScanner) {
                BarcodeScannerView { barcode in
                    isShowingScanner = false
                    fetchBarcodeProductDetails(for: barcode) { result in
                        switch result {
                        case .success(let product):
                            print("Product Details:")
                            print("Name: \(product.name)")
                            print("Brand: \(product.brand)")
                            print("Description: \(product.description)")
                            if let imageURL = product.imageURL {
                                print("Image URL: \(imageURL)")
                            }
                            navigateToProductView = true

                        case .failure(let error):
                            print("Error fetching product: \(error.localizedDescription)")
                            navigateToProductView = true

                        }
                    }
                }
            }

        }
    }
    func getSearchResults(searchText: String) -> [Product] {
        let products = viewModel.products
        let maxSearchResults = 15
        
        // Filter products based on search text (case insensitive)
        let filteredProducts = products.filter { product in
            // Check if searchText matches any part of the name or brand
            product.name.lowercased().contains(searchText.lowercased()) ||
            product.brand.lowercased().contains(searchText.lowercased())
        }
        
        return Array(filteredProducts.prefix(maxSearchResults))
    }

    
    func generateSuggestedProducts() -> Void {
        let groceryList: [Product] = viewModel.localUser.grocery_list
        var products: [Product] = []
        
        for product in groceryList {
            if products.count >= 10 {
                break
            }
            
            let substitutes: [Product] = viewModel.getSubstitutes(product: product)
            
            for substitute in substitutes {
                if products.count < 10 {
                    products.append(substitute)
                } else {
                    break
                }
            }
            
            if products.count >= 10 {
                break
            }
        }
        
        
        suggestedProducts = products
    }

}

class ReloadViewHelper: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}

#Preview {
    SearchView()
}

