//
//  Authentication.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import SwiftUI

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var user: User?
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func setUserByEmail(email: String) {
        UserService().userByEmail(email: email) { (response) in
            if (response.user != nil) {
                self.user = response.user
                self.isValidated = true
            }
        }
    }
}
