//
//  Store.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation
import SwiftUI

class Store: Identifiable, Hashable {
    var id: Int
    var image: Image
    var name: String
    var products: [Product]
    
    // Initializer to set up 'Store' object with an image
    init(id: Int, image: Image, name: String, products: [Product]) {
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
        
        for i_week in 0..<99{
            var current_price: Double = 0
            
            for product in products {
                current_price += product.priceData[99-i_week].price
            }
            
            let i_date = calendar.date(byAdding: .day, value: -7 * i_week, to: now)!
            increments.append(PriceIncrement(timestamp: i_date, price: current_price))
        }
        
        return increments
    }
    
    func getPriceOneMonthAgo() -> Double {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        
        var price: Double = 0.0
        
        for product in products {
            let filtered = product.priceData.filter { $0.timestamp >= oneMonthAgo }
            let relevant = filtered.sorted { $0.timestamp < $1.timestamp }
            
            price += relevant[0].price
        }

        
        return price

    }
    
    func getOneMonthPriceChangePercent() -> Double {
        let final: Double = getCurrentPrice()
        let initial: Double = getPriceOneMonthAgo()

        return ((final - initial) / initial) * 100
    }

}
