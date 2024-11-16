//
//  User.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

class User {
    var id: Int
    var grocery_list: [Product] = []
    
    init(id: Int, grocery_list: [Product]) {
        self.id = id
        self.grocery_list = grocery_list
    }
    
    func getCurrentPrice() -> Double {
        var current_price: Double = 0
        
        for product in grocery_list {
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
            
            for product in grocery_list {
                current_price += product.priceData[i_day].price
            }
            
            let i_date = calendar.date(byAdding: .day, value: -i_day, to: now)!
            increments.append(PriceIncrement(timestamp: i_date, price: current_price))
        }
        
        return increments
    }
}
