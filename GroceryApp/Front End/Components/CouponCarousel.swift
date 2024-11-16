//
//  CouponCarousel.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import SwiftUI

let walmartStore = Store(id: UUID(), image: Image("walmartLogo"), name: "Walmart")
let cvsStore = Store(id: UUID(), image: Image("cvsLogo"), name: "CVS")
let randallsStore = Store(id: UUID(), image: Image("randallsLogo"), name: "Randalls")
let HEBStore = Store(id: UUID(), image: Image("HEBLogo"), name: "H-E-B")

let sampleCoupons: [Coupon] = [
    Coupon(id: 1, store: walmartStore, description: "Get 20% off on electronics!", url: "https://www.walmart.com"),
    Coupon(id: 2, store: cvsStore, description: "Save $10 on your first order!", url: "https://www.walmart.com"),
    Coupon(id: 3, store: randallsStore, description: "Buy one, get one free on toys!", url: "https://www.walmart.com"),
    Coupon(id: 4, store: HEBStore, description: "Free shipping on orders over $50!", url: "https://www.walmart.com")
]

// CouponCarousel View
import SwiftUI

import SwiftUI

struct CouponCarousel: View {
    var coupons: [Coupon]
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(coupons, id: \.id) { coupon in
                    CouponView(coupon: coupon)
                        .frame(width: 300, height: 150)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            }
            .scrollTargetLayout()
            .statusBar(hidden: true)
        }
        .scrollTargetBehavior(.viewAligned)
    }
}




#Preview {
    CouponCarousel(coupons: sampleCoupons)
}
