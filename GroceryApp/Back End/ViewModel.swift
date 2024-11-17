//
//  ViewModel.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation
import SwiftUI

public class ViewModel: ObservableObject {
    @Published var localUser: User
    @Published var products: [Product]
    @Published var stores: [Store]
    @Published var coupons: [Coupon]
    @Published var inflation: [PriceIncrement]
    @Published var analysisText: String

    init() {
        // Initialize default values for properties
        self.products = []
        self.localUser = User(id: 1, grocery_list: [], recent_searches: [])
        self.inflation = []  // Default empty inflation data
        self.analysisText = ""
        self.stores = []
        self.coupons = []
        
        if let product_data = readSampleData(){
            self.products = product_data
            self.localUser = User(id: 1, grocery_list: Array(product_data.shuffled().prefix(20)), recent_searches: [])
        }

        // Create initial store objects
        var walmartStore = Store(id: 1, image: Image("walmartLogo"), name: "Walmart", products: [])
        var cvsStore = Store(id: 2, image: Image("cvsLogo"), name: "CVS", products: [])
        var randallsStore = Store(id: 3, image: Image("randallsLogo"), name: "Randalls", products: [])
        var HEBStore = Store(id: 4, image: Image("HEBLogo"), name: "H-E-B", products: [])

        // Fetch and populate products and inflation data asynchronously
        PinataService.fetchFile(from: "QmWVEJ5AdJnVvTMjGecWRWbkg6GUchirghcVa7MQdnDtkd") { [weak self] data in
            guard let self = self else { return } // Prevent retain cycles

            if let product_data = readSampleDataFromPinata(data: data ?? Data()) {
                // Use local variables to store updated data
                var products = product_data
                var localUser = User(id: 1, grocery_list: Array(product_data.shuffled().prefix(20)), recent_searches: [])

                // Populate store products
                for product in product_data {
                    switch product.store {
                    case 1:
                        walmartStore.products.append(product)
                    case 2:
                        cvsStore.products.append(product)
                    case 3:
                        randallsStore.products.append(product)
                    case 4:
                        HEBStore.products.append(product)
                    default:
                        continue
                    }
                }

                // Assign the fetched product data and stores after processing
                DispatchQueue.main.async {
                    self.products = products
                    self.localUser = localUser
                    self.stores = [walmartStore, cvsStore, randallsStore, HEBStore]
                }
            } else {
                // Handle error case for product data on the main thread
                DispatchQueue.main.async {
                    self.products = []
                    self.localUser = User(id: 1, grocery_list: [], recent_searches: [])
                }
            }
        }

        // Fetch inflation data asynchronously
        PinataService.fetchFile(from: "QmVRXUTS1vViPsB2ePWZ9WpYjpxmT46d7GXXpuNya6Rr6X") { [weak self] data in
            guard let self = self else { return } // Prevent retain cycles
            
            if let inflation_data = readInflationDataFromPinata(data: data ?? Data()) {
                // Assign the inflation data after it's processed
                DispatchQueue.main.async {
                    self.inflation = inflation_data
                }
            } else {
                // Handle error case for inflation data on the main thread
                DispatchQueue.main.async {
                    self.inflation = []
                }
            }
        }

        // Initialize coupons (static data, does not depend on async loading)
        self.coupons = [
            Coupon(id: 1, store: walmartStore, description: "Get 20% off on electronics!", url: "https://www.walmart.com"),
            Coupon(id: 2, store: cvsStore, description: "Save $10 on your first order!", url: "https://www.cvs.com"),
            Coupon(id: 3, store: randallsStore, description: "Buy one, get one free on toys!", url: "https://www.randalls.com"),
            Coupon(id: 4, store: HEBStore, description: "Free shipping on orders over $50!", url: "https://www.heb.com")
        ]
    }
    
    func getSubstitutes(product: Product) -> [Product] {
        let product_store_id = product.store
        let category = product.category
        let recent_price = product.getMostRecentPrice() ?? 0.0
        
        var subs: [Product] = []
        
        for possible in self.products {
            let possible_price = possible.getMostRecentPrice() ?? 10000.0
            if possible.category == category && possible.store == product_store_id && possible_price < recent_price {
                subs.append(possible)
            }
            
            if subs.count > 4 { break }
        }
        
        return subs
    }
    
    func isIdealProduct(product: Product) -> Bool {
        let product_name = product.name
        let product_store = product.store
        
        if let price = product.getMostRecentPrice(){
            for possible in self.products {
                if possible.name == product_name, possible.store != product_store {
                    if let possible_price = possible.getMostRecentPrice(), possible_price < price {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func getProductsAcrossStores(product: Product) -> [Product] {
        let product_name = product.name
        
        var subs: [Product] = []
        
        for possible in self.products {
            if possible.name == product_name {
                subs.append(possible)
            }
        }
        
        return subs
    }
    
    func getMultiLineChartData() -> [MultiLineChartData]{
        let allAvailableColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
        
        var allData: [MultiLineChartData] = []
        
        var lookup: [String: MultiLineChartType] = [
            "HEB": .heb,
            "CVS": .cvs,
            "Randalls": .randalls,
            "Walmart": .walmart,
        ]
        
        for store in stores {
            for datum in store.getPriceIncrementData(){
                allData.append(MultiLineChartData(date: datum.timestamp, value: datum.price, type: lookup[store.name] ?? .heb))

            }
        }
        return allData
    }
    
    func generateInsights() -> String {
        var allInsights: [String] = []
        
        for store in stores{
            var storeInsights: [String] = []
            let allCategories = ["Snacks", "Produce", "Pet", "Supplies", "Personal Care", "Meat", "Household Items", "Hardware", "Grains", "Dairy", "Beverage", "Bakery"]
            
            for category in allCategories {
                let insight = getCategoryInsights(store: store, category: category)
                if insight > 1 {
                    storeInsights.append(category + " prices have risen by " + String(format: "%.1f", insight) + " percent")
                } else if insight < -1 {
                    storeInsights.append(category + " prices have lowered by " + String(format: "%.1f", insight) + " percent")
                }
            }

            allInsights.append(store.name+" reports the following price fluctuations: "+storeInsights.joined(separator: ", "))
        }
        
        let ans = allInsights.joined(separator: "\n\n")
        
        return ans
    }
    
    func getCategoryInsights(store: Store, category: String) -> Double {
        let filtered = store.products.filter { product in
            let prod_category = product.category
            return category == prod_category
        }
        
        let analyzed = filtered.map { $0.getOneMonthPriceChangePercent() }
        
        return analyzed.reduce(0.0, { $0 + Double($1) }) / Double(analyzed.count)
    }
}
