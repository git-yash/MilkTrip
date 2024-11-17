//
//  ProfileView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var watchlist: [Product] = []
    @State private var sortOption = SortOption.none
    @ObservedObject var reloadViewHelper = ReloadViewHelper()
    @State private var isShowingScanner = false
    @State private var scannedBarcode = ""


    enum SortOption {
        case none
        case amountHighToLow
        case amountLowToHigh
    }

    var sortedGroups: [Product] {
            switch sortOption {
            case .none:
                return watchlist
            case .amountHighToLow:
                return watchlist.sorted {
                    if let price_one = $0.getMostRecentPrice(), let price_two = $1.getMostRecentPrice(){
                        return price_one > price_two
                    }
                    return false
                }
            case .amountLowToHigh:
                return watchlist.sorted {
                    if let price_one = $0.getMostRecentPrice(), let price_two = $1.getMostRecentPrice(){
                        return price_one < price_two
                    }
                    return false
                }
            }
        }

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 50){
                    // Barcode Scanner Section
                    VStack(spacing: 20) {
                        Button {
                            isShowingScanner = true
                        } label: {
                            Text("Scan Barcode")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
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
                                case .failure(let error):
                                    print("Error fetching product: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading){
                        ChartView(
                            topText: String(format: "$%.2f", viewModel.localUser.getCurrentPrice()),
                            allData: viewModel.localUser.getPriceIncrementData()
                        )
                    }
                    
                    VStack(alignment: .leading){
                        Text("Products")
                            .font(.system(size: 24))
                            .bold()
                        
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

                        
                        ForEach(sortedGroups, id: \.self) { product in
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
                .padding()
            }
            .navigationTitle("My Watchlist")
            .navigationBarTitleDisplayMode(.large)
            .withScreenBackground()
            .onAppear{
                watchlist = viewModel.localUser.grocery_list
            }
        }
    }
}

#Preview {
    ProfileView()
}

