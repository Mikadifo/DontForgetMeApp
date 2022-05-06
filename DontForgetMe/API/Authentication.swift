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
    @Published var isShowingToast = false
    @Published var message: String = ""
    @Published var userToken: String = ""
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func updateToast(showing: Bool, message: String = "") {
        self.message = message
        isShowingToast = showing
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func updateToken(token: String) {
        userToken = token
    }
    
    func setUserByEmail(email: String) {
        UserService().userByEmail(email: email, token: userToken) { (response) in
            if (response.user != nil) {
                self.user = response.user
                self.isValidated = true
            }
        }
    }
}
