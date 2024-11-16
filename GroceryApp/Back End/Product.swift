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
    
    var id: UUID = UUID()
    var name: String
    var store: UUID
    
    var priceData: [PriceIncrement]
    
    init(id: UUID, name: String, store: UUID, priceData: [PriceIncrement]) {
        self.id = id
        self.name = name
        self.store = store
        self.priceData = priceData
    }
}
