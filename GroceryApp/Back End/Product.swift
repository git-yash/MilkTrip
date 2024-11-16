//
//  Product.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

class Product: Identifiable, Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int
    var name: String
    var brand: String
    var category: String
    var store: Int
    
    var priceData: [PriceIncrement]
    
    init(id: Int, name: String, brand: String, category: String, store: Int, priceData: [PriceIncrement]) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.store = store
        self.priceData = priceData
    }
}
