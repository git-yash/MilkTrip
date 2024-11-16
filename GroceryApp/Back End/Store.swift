//
//  Store.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

class Store: Identifiable, Hashable {
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int
    var name: String
    var products: [Product]
    
    init(id: Int, name: String, products: [Product]) {
        self.id = id
        self.name = name
        self.products = products
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
