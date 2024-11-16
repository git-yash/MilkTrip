//
//  UserGroceriesChartView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct UserGroceriesChartView: View {
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack{
            Spacer()
            Text("user chart goes here")
            Spacer()
        }
        .frame(height: screenWidth * 0.50)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

    }
}

#Preview {
    UserGroceriesChartView()
}
