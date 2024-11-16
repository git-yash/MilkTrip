//
//  Util.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import Foundation
import SwiftUI

extension String {
    public func formatDayAndMonthStrings() -> String {
        return String(self.prefix(3))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255.0
        g = Double((int >> 8) & 0xFF) / 255.0
        b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
