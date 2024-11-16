//
//  ViewModel.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

public class ViewModel: ObservableObject {
    @Published var localUser: User
    @Published var products: [Product]
    @Published var stores: [Store]

    init() {
        if let product_data = readSampleData(){
            self.products = product_data
            self.localUser = User(id: 1, grocery_list: Array(product_data.shuffled().prefix(5)))
        } else {
            self.products = []
            self.localUser = User(id: 1, grocery_list: [])
        }
        self.stores = []
    }

    init(localUser: User) {
        self.localUser = localUser
        if let product_data = readSampleData(){
            self.products = product_data
        }else{
            self.products = []
        }
        self.stores = []
    }
}
