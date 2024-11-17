//
//  PinataService.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/17/24.
//

import Foundation
import SwiftUI

class PinataService {
    static func fetchFile(from cid: String, completion: @escaping (Data?) -> Void) {
        let urlString = "https://gateway.pinata.cloud/ipfs/\(cid)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
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
                    print("Response from pinata:: "+responseString)
                    completion(data)

                } else {
                    print("Unable to retrieve response from pinata.")
                }
            }


        }.resume()
    }
}
