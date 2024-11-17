import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var searchText: String = ""
    @FocusState private var searchFieldIsFocused: Bool
    @State private var isNavigationActive = false
    @ObservedObject var reloadViewHelper = ReloadViewHelper()
    @State var suggestedProducts: [Product] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 50) {
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
            }
            .navigationTitle("Search Products")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                searchFieldIsFocused = true
                generateSuggestedProducts()  // Generate random products when view appears
            }
            .withScreenBackground()
        }
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

