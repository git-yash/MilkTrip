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
                                Text("No recent searches")
                                    .font(.system(size: 12))
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
                        Text("Search Results")
                            .font(.system(size: 24))
                            .bold()
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
