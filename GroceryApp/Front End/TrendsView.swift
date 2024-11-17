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
                VStack(alignment: .leading, spacing: 50){
                    VStack(alignment: .leading){
                        Text("Historical Inflation, Nearby Stores")
                            .font(.system(size: 18))
                            .bold()
                        
                        MultiLineChartView(topText: "", allData: viewModel.getMultiLineChartData())
                    }

                    VStack(alignment: .leading){
                        Text("Analysis")
                            .font(.system(size: 24))
                            .bold()
                        
                        HStack{
                            Text("Analysis failed to load")
                                .font(.system(size: 14))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                        .background(Color(hex: "#494C52"))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Price Trends")
            .navigationBarTitleDisplayMode(.large)
            .withScreenBackground()
        }
    }
}

#Preview {
    TrendsView()
}
