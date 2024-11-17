//
//  Util.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/16/24.
//

import Foundation
import SwiftUI
import Vision
import UIKit

public func getDataAsString(pathName: String) -> String {
    let fileURL = URL(fileURLWithPath: pathName)
    
    do {
        return try String(contentsOf: fileURL, encoding: .utf8)
    } catch {
        return "Error reading file: \(error.localizedDescription)"
    }
}


private func getProductIDsString() -> String {
    let viewModel = ViewModel()
    var productIDsString: String = ""
    let products = viewModel.products
    
    for product in products {
        productIDsString += "\(product.id), "
    }
    
    return productIDsString
}

public func generateAnalysisPrompt(shoppingCart: String, insights: String) -> String {
    let prompt = "(Talk in 1st person) Provide a brief analysis on what stores the user should be going to based on their shopping cart and recent store price insights. \n\nShopping Cart: \(shoppingCart) \n\nInsights: \(insights)"
    
    return prompt
}


func detectBarcode(in image: UIImage) {
    guard let cgImage = image.cgImage else { return }
    
    // Create a request to detect barcodes
    let barcodeRequest = VNDetectBarcodesRequest { (request, error) in
        if let error = error {
            print("Barcode detection error: \(error)")
            return
        }
        
        // Process the results
        for observation in request.results as? [VNBarcodeObservation] ?? [] {
            if let payload = observation.payloadStringValue {
                print("Detected barcode payload: \(payload)")
                print("Symbology: \(observation.symbology.rawValue)")
                print("Bounding box: \(observation.boundingBox)")
            }
        }
    }
    
    // Create a request handler
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    // Perform the request
    do {
        try handler.perform([barcodeRequest])
    } catch {
        print("Failed to perform barcode request: \(error)")
    }
}


extension String {
    public func formatDayAndMonthStrings() -> String {
        return String(self.prefix(3))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255.0
        g = Double((int >> 8) & 0xFF) / 255.0
        b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
