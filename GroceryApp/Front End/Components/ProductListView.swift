//
//  ProductListView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProductListView: View {
    var screenWidth = UIScreen.main.bounds.width

    var body: some View {
        HStack{
            Spacer()
            Text("product goes here")
            Spacer()
        }
        .frame(height: screenWidth * 0.10)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
    }
}

#Preview {
    ProductListView()
}
