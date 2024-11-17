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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 50) {
                    TextField("Search Products...", text: $searchText)
                        .padding(8)
                        .padding(.horizontal, 24)
                        .background(Color(.systemGray6))
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
                    
                    if !searchFieldIsFocused && searchText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Coupons")
                                .font(.system(size: 24))
                                .bold()
                            
                            CouponCarousel(coupons: viewModel.coupons)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Previous Searches")
                                .font(.system(size: 24))
                                .bold()
                            
                            let recent_searches = viewModel.localUser.recent_searches
                            if recent_searches.isEmpty {
                                HStack{
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
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            // Remove the search from the list of recent searches
                                            print(viewModel.localUser.recent_searches)
                                            if let index = viewModel.localUser.recent_searches.firstIndex(of: search) {
                                                viewModel.localUser.recent_searches.remove(at: index)
                                            }
                                            reloadViewHelper.reloadView()
                                            print("removed:")
                                            print(viewModel.localUser.recent_searches)
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
                    } else {
                        VStack(alignment: .leading) {
                            Text("Search Results")
                                .font(.system(size: 24))
                                .bold()
                            
                            let results = getSearchResults(searchText: searchText)
                            
                            if results.isEmpty {
                                HStack{
                                    Text("No search results.")
                                        .font(.system(size: 14))
                                        .padding()
                                    Spacer()
                                }
                                    .background(Color(hex: "#393e46"))
                                    .cornerRadius(5)
                            } else {
                            // Display search results with custom navigation handling
                                ForEach(results, id: \.self) { product in
                                    NavigationLink {
                                        ProductView(product: product)
                                            .onDisappear {
                                                // Append the search text and trigger navigation
                                                if (!viewModel.localUser.recent_searches.contains(product.name)) {
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
                }
                .padding()
            }
            .navigationTitle("Search Products")
            .navigationBarTitleDisplayMode(.large)
            .withScreenBackground()
        }
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
