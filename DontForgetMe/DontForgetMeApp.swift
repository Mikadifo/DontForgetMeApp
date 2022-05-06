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
    @AppStorage("userToken") var userToken: String = ""
    @StateObject var authentication = Authentication()
    @State var notificationAccessGranted = false
    @State var delegate = NotificationDelegate()
    
    var body: some Scene {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                notificationAccessGranted = granted
        }
        UNUserNotificationCenter.current().delegate = delegate
        
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
                    if !userEmail.isEmpty && !userToken.isEmpty && authentication.user == nil {
                        authentication.updateToken(token: userToken)
                        authentication.setUserByEmail(email: userEmail)
                    }
                }
            }
        }
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // before show alert call a function to stop time counter for notification
        print("nOTMAL FROM APP")
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "FORGOT" {
            print("FORGOT")
            completionHandler()
            return
            //NOTIFY USERS
        }
        
        // before show alert call a function to stop time counter for notification
        print("CONTINUE NORMAL")
        completionHandler()
    }
}
