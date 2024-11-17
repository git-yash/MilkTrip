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

    init() {
        let walmartStore = Store(id: 1, image: Image("walmartLogo"), name: "Walmart", products: [])
        let cvsStore = Store(id: 2, image: Image("cvsLogo"), name: "CVS", products: [])
        let randallsStore = Store(id: 3, image: Image("randallsLogo"), name: "Randalls", products: [])
        let HEBStore = Store(id: 4, image: Image("HEBLogo"), name: "H-E-B", products: [])
        
        if let product_data = readSampleData(){
            self.products = product_data
            self.localUser = User(id: 1, grocery_list: Array(product_data.shuffled().prefix(20)), recent_searches: [])
            
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
                    // nothing
                    continue
                }
            }
            
        } else {
            self.products = []
            self.localUser = User(id: 1, grocery_list: [], recent_searches: [])
        }
        
        self.stores = [walmartStore, cvsStore, randallsStore, HEBStore]
        
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
    
    func getMultiLineChartData() -> [MultiLineChartDictKey:[PriceIncrement]]{
        let allAvailableColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
        
        var allData: [MultiLineChartDictKey:[PriceIncrement]] = [:]
        
        var ind = 0
        for store in stores {
            let key = MultiLineChartDictKey(name: store.name, color: allAvailableColors[ind])
            allData[key] = store.getPriceIncrementData()
        }
        return allData
    }
}
