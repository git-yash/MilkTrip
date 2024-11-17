//
//  StoreSubView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/17/24.
//

import SwiftUI

struct StoreSubView: View {
    var store: Store
    
    var screenWidth: Double = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            store.image
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(5)

            // Product Info Section
            Text(store.name)
                .bold()
                .frame(width: screenWidth * 0.20)

            Spacer()

            // Price Section
            VStack(alignment: .leading) {
                Text("$" + String(format: "%.2f", 1.2 ?? 0.00))
                    .font(.system(size: 18))
                    .bold()
            }
            .frame(width: screenWidth * 0.20)

            
            Spacer()
        }
        .frame(height: screenWidth * 0.10)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 10) // Apply rounded rectangle
                .fill(Color(hex: "#393e46")) // Background color
        )
    }
}
