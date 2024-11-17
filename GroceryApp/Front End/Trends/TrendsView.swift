//
//  TrendsView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var analysisService = AnalysisService()

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 50){
                    VStack(alignment: .leading){
                        Text("Historical Inflation, Nearby Stores")
                            .font(.system(size: 18))
                            .bold()
                        
                        MultiLineChartView(allData: viewModel.getMultiLineChartData())
                    }
                    
                    VStack(alignment: .leading){
                        Text("Analysis")
                            .font(.system(size: 24))
                            .bold()
                        
                        if viewModel.analysisText == ""{
                            VStack(alignment: .leading) {
                                Text("Placeholder")
                                    .font(.system(size: 16))
                                    .bold()
                                    .padding(.bottom, 5)
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                                Text("Lorem ipsum dolor sit amet consectetur adipisicing elit")
                                    .font(.system(size: 20))
                                    .bold()
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                            }
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                            .background(Color(hex: "#494C52"))
                            .cornerRadius(10)
                        } else {
                            VStack(alignment: .leading, spacing: 20){
                                Text(viewModel.analysisText)
                                    .font(.system(size: 16))
                                
                                Text("Powered by OpenAI")
                                    .font(.system(size: 14))
                                    .bold()
                            }
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                            .background(Color(hex: "#494C52"))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Price Trends")
            .navigationBarTitleDisplayMode(.large)
            .withScreenBackground()
            .onAppear {
                if(viewModel.analysisText.isEmpty) {
                    analysisService.sendTextToOpenAI(prompt: generateAnalysisPrompt(shoppingCart: viewModel.localUser.generateShoppingCart(), insights: viewModel.generateInsights())) { result, error in
                        DispatchQueue.main.async {
                            if error != nil {
                                viewModel.analysisText = "Failed to fetch analysis."
                            } else if let result = result {
                                viewModel.analysisText = result
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TrendsView()
}
