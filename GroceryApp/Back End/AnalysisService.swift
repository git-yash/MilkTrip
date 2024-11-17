//
//  AnalysisService.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/17/24.
//

import Foundation
import OpenAI

class AnalysisService {
    public func sendTextToOpenAI(prompt: String, completion: @escaping (String?, Error?) -> Void) {
        let api_key: String = getDataAsString(pathName: "/Users/yashshah/Desktop/GroceryApp/GroceryApp/Keys.txt").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Use the correct endpoint for chat-based completions
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set authorization and content type
        request.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the JSON body with the model and the prompt
        let jsonBody: [String: Any] = [
            "model": "gpt-3.5-turbo", // Use gpt-3.5-turbo or another supported model
            "messages": [
                [
                    "role": "system", "content": "You are a helpful assistant."
                ],
                [
                    "role": "user", "content": prompt
                ]
            ]
        ]
        
        // Set the request body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        } catch {
            completion(nil, error)
            return
        }
        
        // Send the request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Check for valid response
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            // Parse the response data
            if let data = data {
                do {
                    // Define the response structure
                    struct OpenAIResponse: Decodable {
                        struct Choice: Decodable {
                            let message: Message
                        }
                        struct Message: Decodable {
                            let content: String
                        }
                        
                        let choices: [Choice]
                    }
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OpenAIResponse.self, from: data)
                    
                    // Get the text completion result
                    if let resultText = response.choices.first?.message.content {
                        completion(resultText, nil)
                    } else {
                        completion(nil, NSError(domain: "OpenAIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No text completion found"]))
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }

    // MARK: - Response Structure for Decoding

    struct OpenAIResponse: Decodable {
        struct Choice: Decodable {
            let text: String
        }
        
        let choices: [Choice]
    }
}
