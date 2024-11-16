//
//  ProfileView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 50){
                    VStack(alignment: .leading){
                        Text("$"+String(format: "%.2f", viewModel.localUser.getCurrentPrice()))
                            .font(.system(size: 32))
                            .bold()
                        
                        ChartView(allData: viewModel.localUser.getPriceIncrementData())
                    }
                    
                    VStack(alignment: .leading){
                        Text("Products")
                            .font(.system(size: 24))
                            .bold()
                        
                        ForEach(viewModel.localUser.grocery_list, id: \.self) { product in
                            NavigationLink {
                                ProductView(product: product)
                            } label: {
                                ProductListView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}
