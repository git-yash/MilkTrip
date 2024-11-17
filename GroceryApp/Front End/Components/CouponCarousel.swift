//
//  CouponCarousel.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import SwiftUI

struct CouponCarousel: View {
    var coupons: [Coupon]
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(coupons, id: \.id) { coupon in
                    CouponView(coupon: coupon)
                        .frame(width: 300)
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
    CouponCarousel(coupons: [])
}
