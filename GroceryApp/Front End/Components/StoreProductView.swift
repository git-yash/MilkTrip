//
//  StoreProductView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct StoreProductView: View {
    var product: Product

    var screenWidth: Double = UIScreen.main.bounds.width

    var body: some View {
        HStack {
            // Image Section
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
                .frame(width: 50, height: 50)
                .cornerRadius(5)

            } else {
                // If the URL is invalid, show a placeholder
                Color.gray
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            }

            // Product Info Section
            Text(product.getStore())
                .bold()
                .frame(width: screenWidth * 0.20)

            Spacer()

            // Price Section
            VStack(alignment: .leading) {
                Text("$" + String(format: "%.2f", product.getMostRecentPrice() ?? 0.00))
                    .font(.system(size: 18))
                    .bold()
            }
            .frame(width: screenWidth * 0.20)

            
            Spacer()
            
            let percentChange = product.getOneMonthPriceChangePercent()
            Text(String(format: "%.2f", percentChange) + "%")
                .font(.system(size: 16))
                .foregroundStyle(percentChange > 0 ? .red : .green)
                .frame(width: screenWidth * 0.20)

        }
        .frame(height: screenWidth * 0.10)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 10) // Apply rounded rectangle
                .fill(Color(hex: "#393e46")) // Background color
        )
    }
}

#Preview {
    StoreProductView(product: Product())
}
