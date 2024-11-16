//
//  ProductListView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProductListView: View {
    var product: Product
    
    var screenWidth: Double = UIScreen.main.bounds.width

    var body: some View {
        HStack{
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
            }
            
            VStack(alignment: .leading, spacing: 2){
                Text(product.name)
                    .bold()
                
                HStack(alignment: .center, spacing: 5){
                    Text("from \(product.getBrand())")
                        .font(.system(size: 12))
                    Circle().frame(width: 2, height: 2)
                    Text(product.brand)
                        .font(.system(size: 12))
                }
                
            }

            Spacer()
            
            VStack(alignment: .leading){
                Text("$" + String(format: "%.2f", product.getMostRecentPrice() ?? 0.00))
                    .font(.system(size: 18))
                    .bold()
            }
        }
        .frame(height: screenWidth * 0.10)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
    }
}

#Preview {
    ProductListView(product: Product(id: 1, name: "Fuji Apple", brand: "Apple Company", category: "Produce", store: 1, image_url: "https://i5.walmartimages.com/seo/Fresh-Gala-Apple-Each_f46d4fa7-6108-4450-a610-cc95a1ca28c5_3.38c2c5b2f003a0aafa618f3b4dc3cbbd.jpeg", priceData: []))
}
