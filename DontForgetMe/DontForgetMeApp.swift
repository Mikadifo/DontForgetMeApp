//
//  DontForgetMeApp.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

@main
struct DontForgetMeApp: App {
    @AppStorage("userEmail") var userEmail: String = ""
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            Group {
            if authentication.isValidated {
                ContentView().environmentObject(authentication)
            } else {
                LoginView().environmentObject(authentication)
            }
            }.onAppear() {
                if !userEmail.isEmpty && authentication.user == nil {
                    authentication.setUserByEmail(email: userEmail)
                }
            }
        }
    }
}
