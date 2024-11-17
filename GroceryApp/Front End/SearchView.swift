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

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 50){
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
                        VStack(alignment: .leading){
                            Text("Coupons")
                                .font(.system(size: 24))
                                .bold()
                            
                            CouponCarousel(coupons: viewModel.coupons)
                        }
                        
                        
                        VStack(alignment: .leading){
                            Text("Previous Searches")
                                .font(.system(size: 24))
                                .bold()
                            
                            ForEach(1...3, id: \.self) { _ in
                                ProductListView(product: Product())
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

#Preview {
    SearchView()
}
