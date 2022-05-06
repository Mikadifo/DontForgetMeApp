//
//  Actions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

enum Action {
    case newThing, updateThing, deleteThing,
         newSchedule, updateSchedule, removeSchedule,
         updateAccount, deleteAccount, updatePassword,
         newContact, updateContact, removeContact
}

class Actions: ObservableObject {
    @Published var action: Action?
    @Published var modalTitle = ""
    @Published var errorMessage = ""
    @Published var lastValue = ""
    @Published var inputValue = ""
    
    func setAction(action: Action) {
        self.action = action
    }
    
    func callAction(authentication: Authentication) {
        switch action {
        case .newThing:
            var newUser = authentication.user
            let newArray = newUser?.things.filter { thing in
                thing.lowercased() == inputValue.lowercased()
            }
            if !newArray!.isEmpty {
                errorMessage = "\(inputValue) already exists"
            } else {
                if newUser != nil {
                    errorMessage = ""
                    newUser?.things.append(inputValue)
                    updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                    if errorMessage.isEmpty {
                        authentication.setUser(user: newUser!)
                        authentication.updateToast(showing: true, message: "\(inputValue) created")
                    }
                } else {
                    errorMessage = "Error adding thing"
                }
            }
            break
        case .updateThing:
            var newUser = authentication.user
            let newArray = newUser?.things.filter { thing in
                thing.lowercased() == inputValue.lowercased()
            }
            if !newArray!.isEmpty {
                errorMessage = "\(inputValue) already exists"
            } else {
                var valueIndex = -1
                for (index, thing) in newUser!.things.enumerated() {
                    if thing.lowercased() == lastValue.lowercased() {
                        valueIndex = index
                    }
                }
                if newUser != nil && valueIndex != -1 {
                    errorMessage = ""
                    newUser?.things[valueIndex] = inputValue
                    updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                    if errorMessage.isEmpty {
                        authentication.setUser(user: newUser!)
                        authentication.updateToast(showing: true, message: "\(inputValue) updated")
                    }
                } else {
                    errorMessage = "Error updating \(lastValue)"
                }
            }
            break
        case .deleteThing:
            var newUser = authentication.user
            let newArray = newUser?.things.filter { thing in
                thing.lowercased() == inputValue.lowercased()
            }
            if !newArray!.isEmpty {
                var valueIndex = -1
                for (index, thing) in newUser!.things.enumerated() {
                    if thing.lowercased() == inputValue.lowercased() {
                        valueIndex = index
                    }
                }
                if newUser != nil && valueIndex != -1 {
                    errorMessage = ""
                    newUser?.things.remove(at: valueIndex)
                    updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                    if errorMessage.isEmpty {
                        authentication.setUser(user: newUser!)
                        authentication.updateToast(showing: true, message: "\(inputValue) deleted")
                    }
                } else {
                    errorMessage = "Error deleting \(inputValue)"
                }
            } else {
                errorMessage = "Error deleting \(inputValue)"
            }
            break
        default:
            authentication.updateToast(showing: true, message: "Can't found option (\(String(describing: action)))")
        }
    }
    
    func updateUser(userEmail: String, newUser: User, token: String) {
        UserService().updateUser(userEmail: userEmail, newUser: newUser, token: token) { (response) in
            if (!response.statusOk! || response.errorMessagge != nil) {
                self.errorMessage = response.errorMessagge!
            } else {
                self.errorMessage = ""
            }
        }
    }
    
    func deleteUser(userEmail: String, token: String) {
        UserService().deleteUser(userEmail: userEmail, token: token) { (response) in
            if (!response.statusOk! || response.errorMessagge != nil) {
                self.errorMessage = response.errorMessagge!
            } else {
                self.errorMessage = ""
            }
        }
    }
}
