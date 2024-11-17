//
//  ProductView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProductView: View {
    var product: Product
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 50){
                VStack(alignment: .leading){
                    Text("$"+String(format: "%.2f", product.getMostRecentPrice() ?? 0.00))
                        .font(.system(size: 32))
                        .bold()
                    
                    ChartView(topText: "Welcome", allData: product.priceData)
                }
                
                VStack(alignment: .leading){
                    Text("Trends")
                        .font(.system(size: 24))
                        .bold()
                    Text("\(product.name) is increasing in price.")
                }
                
                VStack(alignment: .leading){
                    Text("Substitute Products")
                        .font(.system(size: 24))
                        .bold()
                    ForEach(product.getSubstitutes(), id: \.self){ product in
                        ProductListView(product: product)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ProductView(product: Product())
}
