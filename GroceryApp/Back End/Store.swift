//
//  Store.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation
import SwiftUI

class Store: Identifiable, Hashable {
    var id: UUID
    var image: Image
    var name: String
    var products: [Product]
    
    // Initializer to set up 'Store' object with an image
    init(id: UUID = UUID(), image: Image, name: String, products: [Product]) {
        self.id = id
        self.image = image
        self.name = name
        self.products = products
    }
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func getCurrentPrice() -> Double {
        var current_price: Double = 0
        
        for product in products {
            current_price += product.getMostRecentPrice() ?? 0.0
        }

        return current_price
    }
    
    func getPriceIncrementData() -> [PriceIncrement] {
        var increments: [PriceIncrement] = []
        let calendar = Calendar.current
        let now = Date()
        
        for i_day in 0..<99{
            var current_price: Double = 0
            
            for product in products {
                current_price += product.priceData[i_day].price
            }
            
            let i_date = calendar.date(byAdding: .day, value: -i_day, to: now)!
            increments.append(PriceIncrement(timestamp: i_date, price: current_price))
        }
        
        return increments
    }
}
