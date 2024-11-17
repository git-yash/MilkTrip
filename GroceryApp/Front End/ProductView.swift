//
//  ProductView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var viewModel: ViewModel
    var product: Product
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 50){
                HStack(alignment: .center, spacing: 20){
                    if let url = URL(string: product.image_url) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                // Placeholder: Gray square of size 50x50 pixels
                                Color.gray
                            case .success(let image):
                                // Loaded image
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                // Placeholder for failure case (optional)
                                Color.red
                            @unknown default:
                                Color.gray
                            }
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)

                    } else {
                        // If the URL is invalid, show a placeholder
                        Color.gray
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    }
                    
                    VStack(alignment: .leading){
                        Text("Category: \(product.category)")
                            .font(.system(size: 14))
                        Text("Distributed by: \(product.brand)")
                            .font(.system(size: 14))
                        Text("Store: \(product.getStore())")
                            .font(.system(size: 14))
                    }
                }
                
                VStack(alignment: .leading){
                    Text("Current Price: $"+String(format: "%.2f", product.getMostRecentPrice() ?? 0.00))
                        .font(.system(size: 24))
                        .bold()
                    
                    ChartView(topText: "Trends across time", allData: product.priceData)
                }
                
                VStack(alignment: .leading){
                    Text("Analysis")
                        .font(.system(size: 24))
                        .bold()
                    
                    NavigationLink {
                        CompareStoresView(product: product)
                    } label: {
                        let isIdealProduct = viewModel.isIdealProduct(product: product)
                        if isIdealProduct {
                            HStack{
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
                
                VStack(alignment: .leading){
                    Text("Substitutes from \(product.getStore())")
                        .font(.system(size: 24))
                        .bold()
                    
                    let subs = viewModel.getSubstitutes(product: product)
                    if subs.isEmpty{
                        HStack{
                            Text("We couldn't find any substitutes for this product.")
                                .font(.system(size: 16))
                                .bold()
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
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.large)
        .withScreenBackground()
    }
}

#Preview {
    ProductView(product: Product())
}
