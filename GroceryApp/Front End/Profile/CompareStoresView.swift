//
//  CompareStoresView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct CompareStoresView: View {
    @EnvironmentObject var viewModel: ViewModel
    var product: Product
    
    @State private var allProducts: [Product] = []
    @State private var sortOption = SortOption.none

    enum SortOption {
        case none
        case amountHighToLow
        case amountLowToHigh
    }

    var sortedGroups: [Product] {
        switch sortOption {
        case .none:
            return allProducts
        case .amountHighToLow:
            return allProducts.sorted {
                if let price_one = $0.getMostRecentPrice(), let price_two = $1.getMostRecentPrice(){
                    return price_one > price_two
                }
                return false
            }
        case .amountLowToHigh:
            return allProducts.sorted {
                if let price_one = $0.getMostRecentPrice(), let price_two = $1.getMostRecentPrice(){
                    return price_one < price_two
                }
                return false
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack{
                    Menu {
                        Button("Default") {
                            sortOption = .none
                        }
                        Button("Highest Amount") {
                            sortOption = .amountHighToLow
                        }
                        Button("Lowest Amount") {
                            sortOption = .amountLowToHigh
                        }
                    } label: {
                        HStack {
                            Text(sortOption == .none ? "Default" :
                                    sortOption == .amountHighToLow ? "Highest Amount" : "Lowest Amount")
                            .fontWeight(.semibold)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#393e46"))
                        )
                    }
                    Spacer()
                }
                
                HStack{
                    Text("Store")
                        .font(.system(size: 12))
                    Spacer()
                    Spacer()
                    Text("Price")
                        .font(.system(size: 12))
                    Spacer()
                    Text("Change (1 mo)")
                        .font(.system(size: 12))
                }
                
                VStack {
                    ForEach(sortedGroups, id: \.self) { product in
                        NavigationLink(destination: ProductView(product: product)) {
                            StoreProductView(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }

            }
            .padding()
            .navigationTitle("Compare Stores")
            .navigationBarTitleDisplayMode(.large)
            .onAppear{
                allProducts = viewModel.getProductsAcrossStores(product: product)
            }
        }.withScreenBackground()
    }
}

#Preview {
    CompareStoresView(product: Product())
}
