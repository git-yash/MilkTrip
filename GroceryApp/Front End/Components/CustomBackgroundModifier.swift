//
//  CustomBackgroundModifier.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import SwiftUI

struct ScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(hex: "#13171c") // Background color
                .ignoresSafeArea()
            SharedViews.motionAnimator
                .blur(radius: 100)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func withScreenBackground() -> some View {
        self.modifier(ScreenBackground())
    }
}
