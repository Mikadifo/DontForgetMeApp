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
    @State var notificationAccessGranted = false
    
    var body: some Scene {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                notificationAccessGranted = granted
        }
        
        return WindowGroup {
            if !notificationAccessGranted {
                VStack {
                    Text("You must enable notifications to use this app").bold()
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    } label: {
                        FillButton(text: "Activate Notifications", color: Color("Orange"))
                    }.padding([.top, .bottom])
                }
            } else {
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
}
