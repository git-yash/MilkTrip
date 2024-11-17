//
//  User.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

class User {
    var id: Int
    @Published var grocery_list: [Product] = []
    @Published var recent_searches: [String] = []
    
    init(id: Int, grocery_list: [Product], recent_searches: [String]) {
        self.id = id
        self.grocery_list = grocery_list
        self.recent_searches = recent_searches
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
        
        for i_week in 0..<99{
            var current_price: Double = 0
            
            for product in grocery_list {
                current_price += product.priceData[99-i_week].price
            }
            
            let i_date = calendar.date(byAdding: .day, value: -7 * i_week, to: now)!
            increments.append(PriceIncrement(timestamp: i_date, price: current_price))
        }
        
        return increments
    }
    
    func isWatchingProduct(product: Product) -> Bool {
        for item in self.grocery_list {
            if item.id == product.id{
                return true
            }
        }
        return false
    }
    
    // Method to remove a product from the grocery list
    func removeProduct(product: Product) {
        if let index = grocery_list.firstIndex(where: { $0.id == product.id }) {
            grocery_list.remove(at: index)
        }
    }
    
    // Method to add a product to the grocery list
    func addProduct(product: Product) {
        if !isWatchingProduct(product: product) {
            grocery_list.append(product)
        }
    }
}
