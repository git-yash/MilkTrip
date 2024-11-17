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
                    ForEach(viewModel.stores, id: \.self){ store in
                        VStack(alignment: .leading, spacing: 10){
                            Text(store.name)
                                .font(.system(size: 18))
                                .bold()
                            ChartView(topText: "Welome", allData: store.getPriceIncrementData())
                        }
                    }
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
