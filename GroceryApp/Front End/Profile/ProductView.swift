//
//  ProductView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI
import Shimmer

struct ProductView: View {
    @EnvironmentObject var viewModel: ViewModel
    var product: Product
    @ObservedObject var reloadViewHelper = ReloadViewHelper()
    
    // State variables for showing the alert
    @State private var showAlert = false
    @State private var isRemoving = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                // Product Image and Info Section (same as before)
                HStack(alignment: .center, spacing: 20){
                    Spacer()
                    if let url = URL(string: product.image_url) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(100)
                                    .shimmering()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(100)
                            case .failure:
                                Color.gray
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(100)
                                    .shimmering()
                            @unknown default:
                                Color.gray
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(100)
                                    .shimmering()
                            }
                        }
                    } else {
                        Color.gray
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                            .shimmering()
                    }
                    Spacer()
                }

                // Product Details Section (same as before)
                VStack(spacing: 20){
                    HStack{
                        Spacer()
                        VStack(alignment: .center){
                            Text("Category")
                                .font(.system(size: 12))
                                .opacity(0.70)
                            Text("\(product.category)")
                                .font(.system(size: 16))
                                .bold()
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 100)
                        
                        Spacer()
                        VStack(alignment: .center){
                            Text("Distributed by")
                                .font(.system(size: 12))
                                .opacity(0.70)
                            Text("\(product.brand)")
                                .font(.system(size: 16))
                                .bold()
                                .multilineTextAlignment(.center)

                        }
                        .frame(width: 100)

                        Spacer()
                        VStack(alignment: .center){
                            Text("Store")
                                .font(.system(size: 12))
                                .opacity(0.70)
                            Text("\(product.getStore())")
                                .font(.system(size: 16))
                                .bold()
                                .multilineTextAlignment(.center)

                        }
                        .frame(width: 100)

                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#494C52"))
                    .cornerRadius(10)

                    // Watchlist Button with Alert
                    if viewModel.localUser.isWatchingProduct(product: product) {
                        Button {
                            // Set state to show the alert for removing
                            isRemoving = true
                            showAlert = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Remove from your watchlist")
                                Spacer()
                            }
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button {
                            // Set state to show the alert for adding
                            isRemoving = false
                            showAlert = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Add to your watchlist")
                                Spacer()
                            }
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Price and Analysis Sections (same as before)
                VStack(alignment: .leading){
                    Text("Price Trends")
                        .font(.system(size: 24))
                        .bold()
                    ChartView(topText: "$"+String(format: "%.2f", product.getMostRecentPrice() ?? 0.00), allData: product.priceData)
                }

                VStack(alignment: .leading){
                    Text("Compare")
                        .font(.system(size: 24))
                        .bold()
                    
                    NavigationLink {
                        CompareStoresView(product: product)
                    } label: {
                        let isIdealProduct = viewModel.isIdealProduct(product: product)
                        if isIdealProduct {
                            HStack(spacing: 10){
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.accentColor)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 3){
                                    Text("This product is cheapest at your selected store")
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 16))
                                        .bold()
                                    
                                    Text("Tap to analyze this product")
                                        .font(.system(size: 12))
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(hex: "#494C52"))
                            .cornerRadius(10)
                        } else {
                            HStack{
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 3){
                                    Text("This product is cheaper at other stores!")
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 16))
                                        .bold()

                                    Text("Tap to analyze this product")
                                        .font(.system(size: 12))
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(hex: "#494C52"))
                            .cornerRadius(10)
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                // Substitutes Section (same as before)
                VStack(alignment: .leading){
                    Text("Substitutes from \(product.getStore())")
                        .font(.system(size: 24))
                        .bold()
                    
                    let subs = viewModel.getSubstitutes(product: product)
                    if subs.isEmpty {
                        HStack {
                            Text("We couldn't find any substitutes for this product.")
                                .font(.system(size: 14))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                        .background(Color(hex: "#494C52"))
                        .cornerRadius(10)

                    } else {
                        ForEach(viewModel.getSubstitutes(product: product), id: \.self){ product in
                            ProductListView(product: product)
                        }
                    }
                }
            }
            .padding(15)
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.large)
        .withScreenBackground()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isRemoving ? "Remove from Watchlist" : "Add to Watchlist"),
                message: Text(isRemoving ? "Are you sure you want to remove this product from your watchlist?" : "Are you sure you want to add this product to your watchlist?"),
                primaryButton: .destructive(Text(isRemoving ? "Remove" : "Add")) {
                    // Perform the action based on whether it's removing or adding
                    if isRemoving {
                        viewModel.localUser.removeProduct(product: product)
                    } else {
                        viewModel.localUser.addProduct(product: product)
                    }
                    reloadViewHelper.reloadView()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    ProductView(product: Product())
}
