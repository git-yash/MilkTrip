//
//  ViewModel.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

public class ViewModel: ObservableObject {
    @Published var localUser: User
    @Published var productData: [Product]
    
    init() {
        if let products = readSampleData(){
            self.productData = products
            self.localUser = User(id: 1, grocery_list: Array(products.shuffled().prefix(5)))
        } else {
            self.productData = []
            self.localUser = User(id: 1, grocery_list: [])
        }
    }

    init(localUser: User) {
        self.localUser = localUser
        if let products = readSampleData(){
            self.productData = products
        }else{
            self.productData = []
        }
    }    
}
