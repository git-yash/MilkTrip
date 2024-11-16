//
//  Store.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation
import SwiftUI

class Store: Identifiable, Hashable {
    var id: UUID
    var image: Image
    var name: String
    
    // Initializer to set up 'Store' object with an image
    init(id: UUID = UUID(), image: Image, name: String) {
        self.id = id
        self.image = image
        self.name = name
    }
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
