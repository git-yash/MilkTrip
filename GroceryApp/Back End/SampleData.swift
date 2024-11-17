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
                    let product = Product(id: Int(columns[0])! + (i - 1) * 100,
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

    for i in (0..<100).reversed() {
        if let this_date = Calendar.current.date(byAdding: .day, value: -7 * i, to: currentDate) {
            
            // prices slightly increase over time, so we multiply by a random double, but it is
            // slightly more likely to be greater than 1 than less than 1
            var this_price: Double = 0

            switch store_index{
            case 1: this_price = prev_price * Double.random(in: 0.98...1.021) // walmart
            case 2: this_price = prev_price * Double.random(in: 0.98...1.022) // cvs
            case 3: this_price = prev_price * Double.random(in: 0.98...1.0232) // randalls
            case 4: this_price = prev_price * Double.random(in: 0.98...1.0215) // heb
            default: this_price = prev_price * Double.random(in: 0.98...1.02)
            }
            
            increments.append(PriceIncrement(timestamp: this_date, price: this_price))
            prices.append(this_price)
            
            prev_price = this_price
        }
    }
        
    return increments
}


func readInflationData() -> [PriceIncrement] {
    if let filePath = Bundle.main.path(forResource: "InflationData", ofType: "csv"){
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = fileContents.split(separator: "\r\n")
            
            var increments: [PriceIncrement] = []
            
            var prev_price = 1.0
            // Process each row, assuming the first row is a header and can be ignored
            for row in rows.dropFirst() {
                // Year    Month    Inflation
                let columns = row.split(separator: ",")
                
                // for each week
                for i in 1...4 {
                    var components = DateComponents()
                    components.year = Int(columns[0])
                    components.month = Int(columns[1])
                    components.weekOfMonth = i
                    
                    let timestep = Calendar.current.date(from: components) ?? Date()
                    let current_price = prev_price * (Double(columns[2]) ?? 1.0)
                    let inflationPoint = PriceIncrement(timestamp: timestep, price: current_price)

                    increments.append(inflationPoint)
                    
                    prev_price = current_price
                }
            }
             
            print(increments)
            
            return increments
        } catch {
            print("Error reading inflation: \(error.localizedDescription)")
        }
    }
    
    print("Could not get filepath when reading inflation data")
    
    return []
}
