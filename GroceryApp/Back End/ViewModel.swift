//
//  ViewModel.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import Foundation

public class ViewModel: ObservableObject {
    @Published var localUser: User
    
    init() {
        self.localUser = User()
    }
    
    init(localUser: User) {
        self.localUser = localUser
    }
}
