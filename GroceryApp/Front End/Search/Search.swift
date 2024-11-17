//
//  Search.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import Foundation

func getSearchResults(searchText: String) -> [Product] {
    let viewModel = ViewModel()
    let products = viewModel.products
    let maxSearchResults = 15
    
    // Filter products based on search text (case insensitive)
    let filteredProducts = products.filter { product in
        // Check if searchText matches any part of the name or brand
        product.name.lowercased().contains(searchText.lowercased()) ||
        product.brand.lowercased().contains(searchText.lowercased())
    }
    
    return Array(filteredProducts.prefix(maxSearchResults))
}
