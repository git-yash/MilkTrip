//
//  CouponView.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import SwiftUI

import SwiftUI

struct CouponView: View {
    var coupon: Coupon
    
    var body: some View {
        Button(action: {
            if let url = URL(string: coupon.url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                // Store logo rounded image
                coupon.store.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .padding(10)
                
                VStack(alignment: .leading) {
                    // Store name (using the Coupon's store)
                    Text(coupon.store.name)
                        .font(.headline)
                    
                    // Coupon description
                    Text(coupon.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Right arrow
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundColor(Color(hex: "#a3f7bf"))
                    .padding(10)
            }
            .background(Color(hex: "#393e46"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding([.trailing], 16)
        }
        .buttonStyle(PlainButtonStyle()) // To avoid the default button styling
    }
}

#Preview {
    CouponView(coupon: Coupon(id: 1, store: Store(image: Image("walmartLogo"), name: "Walmart"), description: "15% off of all eligible items if you use the code BUY24.", url: "https://www.walmart.com/"))
}
