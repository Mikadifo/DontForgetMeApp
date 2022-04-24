//
//  LoginView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var response: Response = Response()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login").font(.largeTitle).padding([.bottom], 1)
                if !(response.statusOk ?? true) {
                    Text(response.errorMessagge ?? "Error in login, try again later").font(.headline).foregroundColor(.red).padding([.trailing, .leading])
                }
                RoundedField(inputValue: $username, fieldLabel: "Username / Email", placeholder: "").padding([.top])
                RoundedField(inputValue: $password, fieldLabel: "Password", placeholder: "", isPassword: true).padding([.top, .bottom])
                Button {
                    login()
                } label: {
                    FillButton(text: "Login", iconName: "arrow.forward", color: .blue, maxWidth: true, trailingIcon: true, disabled: username.isEmpty || password.isEmpty)
                        .padding([.leading, .trailing, .bottom])
                }.disabled(username.isEmpty || password.isEmpty)
                Group {
                    Text("If you don't have an account yet.")
                    NavigationLink(destination: CreateAccountForm()) {
                        Text("Create account")
                    }
                }.padding([.trailing, .leading])
            }
        }
    }
    
    func login() {
        UIApplication.shared.endEditing()
        UserService().login(username: username, password: password) { (response) in
            self.response = response
            if (response.user != nil) {
                UserDefaults.standard.set(response.user?.email, forKey: "userEmail")
                authentication.setUser(user: response.user!)
                authentication.user?.schedules.forEach { schedule in
                    _ = ScheduleActions
                        .setUpNotifications(schedule: schedule, scheduleTime: SchedulesView.getFormattedDate(time: schedule.time), authentication: authentication, notificationIdArray: schedule.notifications)
                }
            }
            authentication.updateValidation(success: response.statusOk ?? false)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(Authentication())
    }
}
