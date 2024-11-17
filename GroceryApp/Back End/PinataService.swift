//
//  PinataService.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/17/24.
//

import Foundation
import SwiftUI

class PinataService {
    // Replace this with your actual Pinata API key

    static func fetchFile(from cid: String, completion: @escaping (Data?) -> Void) {
        if let filePath = Bundle.main.path(forResource: "PinataKey", ofType: "txt"){
            do {
                let api_key = try String(contentsOfFile: filePath, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
                
                let urlString = "https://gateway.pinata.cloud/ipfs/\(cid)"
                guard let url = URL(string: urlString) else {
                    print("Invalid URL.")
                    completion(nil)
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                // Set the API key in the Authorization header
                request.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error fetching file: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Invalid response from server.")
                        completion(nil)
                        return
                    }
                    
                    if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response from Pinata: \(responseString)")
                            completion(data)
                        } else {
                            print("Unable to retrieve response from Pinata.")
                            completion(nil)
                        }
                    }
                }.resume()
            }
            catch{
                print("error in getting api key")
            }
        }
    }
}
