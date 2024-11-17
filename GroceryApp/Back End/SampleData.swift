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
                                          image_url: String(columns[5]),
                                          priceData: generatePriceIncrements(base_price: Double(columns[4]) ?? 5.0, store_index: i))

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
func generatePriceIncrements(base_price: Double, store_index: Int) -> [PriceIncrement] {
    var increments: [PriceIncrement] = []
    var prices: [Double] = []

    let currentDate = Date()
    
    var prev_price: Double = base_price

    for i in 0..<100 {
        if let this_date = Calendar.current.date(byAdding: .day, value: -7 * i, to: currentDate) {
            
            // prices slightly increase over time, so we multiply by a random double, but it is
            // slightly more likely to be greater than 1 than less than 1
            var this_price: Double = 0

            switch store_index{
            case 1: this_price = prev_price * Double.random(in: 0.98...1.015) // walmart
            case 2: this_price = prev_price * Double.random(in: 0.983...1.01) // cvs
            case 3: this_price = prev_price * Double.random(in: 0.97...1.01) // randalls
            case 4: this_price = prev_price * Double.random(in: 0.98...1.012) // heb
            default: this_price = prev_price * Double.random(in: 0.98...1.01)
            }
            
            increments.append(PriceIncrement(timestamp: this_date, price: this_price))
            prices.append(this_price)
            
            prev_price = this_price
        }
    }
        
    return increments
}
