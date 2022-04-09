//
//  AccountActions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/18/22.
//

import Foundation

class AccountActions: ObservableObject {
    static var updatedUser: User = emptyUser()
    
    @Published var action: Action?
    @Published var errorMessage = ""
    @Published var user: User = emptyUser()
    @Published var currentPassword = ""
    @Published var newPassword = ""
    
    func setAction(action: Action) {
        self.action = action
        AccountActions.updatedUser = emptyUser()
    }
    
    func callAction(authentication: Authentication) {
        switch action {
        case .updateAccount:
            if user.username.isEmpty || user.email.isEmpty || user.phone.isEmpty {
                errorMessage = "User info is empty"
                break
            }
            let actions = Actions()
            actions.updateUser(userEmail: authentication.user!.email, newUser: user)
            errorMessage = actions.errorMessage
            if errorMessage.isEmpty {
                authentication.setUser(user: user)
                UserDefaults.standard.set(user.email, forKey: "userEmail")
                AccountActions.updatedUser = user
            }
            break
        case .updatePassword:
            if authentication.user!.password == currentPassword {
                if authentication.user!.password == newPassword {
                    errorMessage = "New Password can not be the same as old"
                    break
                }
                var newUser = authentication.user
                if newUser != nil {
                    errorMessage = ""
                    newUser?.password = newPassword
                    let actions = Actions()
                    actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!)
                    errorMessage = actions.errorMessage
                    if errorMessage.isEmpty {
                        authentication.setUser(user: newUser!)
                        AccountActions.updatedUser = newUser!
                    }
                } else {
                    errorMessage = "Error updating password"
                }
            } else {
                errorMessage = "Current Password is incorrect"
            }
            break
        case .deleteAccount:
            if authentication.user != nil {
                errorMessage = ""
                let actions = Actions()
                actions.deleteUser(userEmail: authentication.user!.email)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    authentication.setUser(user: emptyUser())
                    authentication.updateValidation(success: false)
                    UserDefaults.standard.set("", forKey: "userEmail")
                }
            } else {
                errorMessage = "Error deleting password"
            }
            break
        default:
            print("NOT OPTION FOUND")
        }
    }
}
