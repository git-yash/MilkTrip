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
    var image_url: String
    
    var priceData: [PriceIncrement]
    
    init(id: Int, name: String, brand: String, category: String, store: Int, image_url: String, priceData: [PriceIncrement]) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.store = store
        self.image_url = image_url
        self.priceData = priceData
    }
    
    init() {
        self.id = 1
        self.name = "Fuji Apple"
        self.brand = "Apple Company"
        self.category = "Produce"
        self.store = 1
        self.image_url = "https://i5.walmartimages.com/seo/Fresh-Gala-Apple-Each_f46d4fa7-6108-4450-a610-cc95a1ca28c5_3.38c2c5b2f003a0aafa618f3b4dc3cbbd.jpeg"
        self.priceData = []
    }
    
    func getMostRecentPrice() -> Double? {
        // Ensure that the priceData is not empty
        guard !priceData.isEmpty else {
            return nil // Return nil if no price data is available
        }
        
        // Find the priceDatum with the most recent timestamp
        let mostRecentPriceDatum = priceData.max { (first, second) in
            first.timestamp < second.timestamp
        }

        // Return the price of the most recent priceDatum
        return mostRecentPriceDatum?.price
    }
    
    func getStore() -> String {
        switch self.store{
        case 1: return "HEB"
        case 2: return "Randalls"
        case 3: return "CVS"
        case 4: return "Walmart"
        default:
            return "HEB"
        }
    }    
    
    func getStoreImage() -> String {
        switch self.store{
        case 1: return "HEBLogo"
        case 2: return "randallsLogo"
        case 3: return "cvsLogo"
        case 4: return "walmartLogo"
        default:
            return "HEBLogo"
        }
    }

    
    func getOneMonthPriceChange() -> Double? {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate)!

        let filtered = priceData.filter { $0.timestamp >= oneMonthAgo }
        let relevant = filtered.sorted { $0.timestamp > $1.timestamp }
        
        return relevant[0].price - (relevant.last?.price ?? 0.0)
    }
    
    func getPriceOneMonthAgo() -> Double? {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate)!

        let filtered = priceData.filter { $0.timestamp >= oneMonthAgo }
        let relevant = filtered.sorted { $0.timestamp < $1.timestamp }
        
        return relevant[0].price
    }
    
    func getOneMonthPriceChangePercent() -> Double {
        let final: Double = getMostRecentPrice() ?? 1.0
        let initial: Double = getPriceOneMonthAgo() ?? 1.0

        return ((final - initial) / initial) * 100
    }
}
