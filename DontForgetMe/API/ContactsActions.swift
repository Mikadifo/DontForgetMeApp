//
//  ContactsActions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/24/22.
//

import Foundation

class ContactsActions: ObservableObject {
    @Published var action: Action?
    @Published var modalTitle = ""
    @Published var errorMessage = ""
    @Published var contact: Contact = Contact(nickname: "", email: "")
    @Published var oldContact: Contact = Contact(nickname: "", email: "")
    
    func setAction(action: Action) {
        self.action = action
    }
    
    func callAction(authentication: Authentication) {
        switch action {
        case .newContact:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                if contact.email == newUser?.email {
                    errorMessage = "Can't use your own email"
                    break
                }
                let contactsWithSameInfo = newUser?.emergencyContacts.filter{ contact in
                    contact.email == self.contact.email ||
                    contact.nickname == self.contact.nickname
                }
                if contactsWithSameInfo!.count > 0 {
                    errorMessage = "Nickname or email already exist in your list"
                    break
                }
                contact.id = UUID().uuidString
                newUser?.emergencyContacts.append(contact)
                let actions = Actions()
                actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    authentication.setUser(user: newUser!)
                    authentication.updateToast(showing: true, message: "\(contact.nickname) created")
                }
            } else {
                errorMessage = "Error adding contact"
            }
            break
        case .updateContact:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                if contact.email == newUser?.email {
                    errorMessage = "Can't use your own email"
                    break
                }
                let contactsWithSameInfo = newUser?.emergencyContacts.filter{ contact in
                    contact.id != self.contact.id &&
                    (contact.email == self.contact.email ||
                    contact.nickname == self.contact.nickname)
                }
                if contactsWithSameInfo!.count > 0 {
                    errorMessage = "Nickname or email already exist in your list"
                    break
                }
                let newArray = newUser?.emergencyContacts.filter { contact in
                    self.contact.id == contact.id
                }
                if !newArray!.isEmpty {
                    var valueIndex = -1
                    for (index, contact) in newUser!.emergencyContacts.enumerated() {
                        if self.contact.id == contact.id {
                            valueIndex = index
                        }
                    }
                    if newUser != nil && valueIndex != -1 {
                        errorMessage = ""
                        newUser?.emergencyContacts[valueIndex] = contact
                        let actions = Actions()
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            authentication.setUser(user: newUser!)
                            authentication.updateToast(showing: true, message: "Contact updated")
                        }
                    } else {
                        errorMessage = "Error updating \(contact.nickname)"
                    }
                } else {
                    errorMessage = "Schedule not found"
                }
            } else {
                errorMessage = "Error adding schedule"
            }
            break
        case .removeContact:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                let newArray = newUser?.emergencyContacts.filter { contact in
                    self.contact.id == contact.id
                }
                if !newArray!.isEmpty {
                    var valueIndex = -1
                    for (index, contact) in newUser!.emergencyContacts.enumerated() {
                        if self.contact.id == contact.id {
                            valueIndex = index
                        }
                    }
                    if newUser != nil && valueIndex != -1 {
                        errorMessage = ""
                        newUser?.emergencyContacts.remove(at: valueIndex)
                        let actions = Actions()
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            authentication.setUser(user: newUser!)
                            authentication.updateToast(showing: true, message: "\(contact.nickname) removed")
                        }
                    } else {
                        errorMessage = "Error deleting \(contact.nickname)"
                    }
                } else {
                    errorMessage = "Contact not found"
                }
            } else {
                errorMessage = "Error deleting schedule"
            }
            break
        default:
            authentication.updateToast(showing: true, message: "Can't found option (\(String(describing: action)))")
        }
    }
}
