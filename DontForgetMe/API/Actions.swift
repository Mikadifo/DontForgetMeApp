//
//  Actions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

enum Action {
    case newThing, updateThing
}

class Actions: ObservableObject {
    @Published var action: Action?
    @Published var modalTitle = ""
    @Published var errorMessage = ""
    
    func setAction(action: Action) {
        self.action = action
    }
    
    func callAction(authentication: Authentication, inputValue: String) {
        switch action {
        case .newThing:
            print("NEW")
            let newArray = authentication.user?.things.filter {thing in thing == inputValue}
            print(newArray!.isEmpty)
            if newArray!.isEmpty {
                errorMessage = "\(inputValue) already exists"
            } else {
                authentication.user?.things.append(inputValue)
            }
            break
        case .updateThing:
            print(authentication.user?.username ?? "NO USER")
            authentication.user?.username = inputValue
            print("UPDATING")
            break
        default:
            print("NO ACTION")
        }
    }
}
