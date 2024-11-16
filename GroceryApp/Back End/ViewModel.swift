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
        self.localUser = User()
        if let products = readSampleData(){
            self.productData = products
        }else{
            self.productData = []
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
