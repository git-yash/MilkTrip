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
                        Text("$123.45")
                            .font(.system(size: 32))
                            .bold()
                        
                        ChartView()
                    }
                    
                    VStack(alignment: .leading){
                        Text("Products")
                            .font(.system(size: 24))
                            .bold()
                        
                        ForEach(1...3, id: \.self) { _ in
                            ProductListView(product: viewModel.productData.randomElement() ?? Product())
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
