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
            self.localUser = User(id: 1, grocery_list: Array(product_data.shuffled().prefix(5)))
            
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
            self.localUser = User(id: 1, grocery_list: [])
        }
        
        self.stores = [walmartStore, cvsStore, randallsStore, HEBStore]
        
        self.coupons = [
            Coupon(id: 1, store: walmartStore, description: "Get 20% off on electronics!", url: "https://www.walmart.com"),
            Coupon(id: 2, store: cvsStore, description: "Save $10 on your first order!", url: "https://www.walmart.com"),
            Coupon(id: 3, store: randallsStore, description: "Buy one, get one free on toys!", url: "https://www.walmart.com"),
            Coupon(id: 4, store: HEBStore, description: "Free shipping on orders over $50!", url: "https://www.walmart.com")
        ]
    }
}
