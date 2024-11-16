//
//  GroceryAppApp.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import SwiftUI

@main
struct GroceryAppApp: App {
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                TrendsView()
                    .tabItem {
                        Label("Trends", systemImage: "chart.line.uptrend.xyaxis")
                    }
            }
            .environmentObject(viewModel)
        }
    }
}
