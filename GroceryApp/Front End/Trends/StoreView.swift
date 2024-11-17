//
//  StoreView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/17/24.
//

import SwiftUI

struct StoreView: View {
    var store: Store
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StoreView(store: Store(id: 2, image: Image("HEBLogo"), name: "HEB", products: []))
}
