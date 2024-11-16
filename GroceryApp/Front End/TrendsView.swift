//
//  TrendsView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    Text("Hello, World!")
                }
                .padding()
            }
            .navigationTitle("Price Trends")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    TrendsView()
}
