//
//  SampleData.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

func readSampleData() -> [Product]? {
    if let filePath = Bundle.main.path(forResource: "SampleData", ofType: "csv"){
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = fileContents.split(separator: "\r\n")
            
            var products: [Product] = []
                        
            // Process each row, assuming the first row is a header and can be ignored
            for row in rows.dropFirst() {
                // ID    Name    Brand    Category    Base Price
                let columns = row.split(separator: ",")
                
                // for each store (stores carry the same products)
                for i in 1...4 {
                    let product = Product(id: Int(columns[0])!,
                                          name: String(columns[1]),
                                          brand: String(columns[2]),
                                          category: String(columns[3]),
                                          store: i,
                                          priceData: generatePriceIncrements(base_price: Double(columns[4]) ?? 5.0))
                    
                    products.append(product)
                }
            }
                        
            return products
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    
    print("Could not get filepath when reading sample data")
    
    return []
}

// to create trends (randomly generated)
func generatePriceIncrements(base_price: Double) -> [PriceIncrement] {
    var increments: [PriceIncrement] = []
    var prices: [Double] = []

    let currentDate = Date()
    
    var prev_price: Double = base_price
    for i in 0..<100 {
        if let this_date = Calendar.current.date(byAdding: .day, value: -7 * i, to: currentDate) {
            
            // prices slightly increase over time, so we multiply by a random double, but it is
            // slightly more likely to be greater than 1 than less than 1
            let this_price = prev_price * Double.random(in: 0.985...1.02)
            
            increments.append(PriceIncrement(timestamp: this_date, price: this_price))
            prices.append(this_price)
            
            prev_price = this_price
        }
    }
        
    return increments
}
