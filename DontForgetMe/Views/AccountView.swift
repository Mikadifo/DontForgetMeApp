//
//  AccountView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct AccountView: View {
    @State var showingModal = false
    @State var showingAlert = false
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var actionCallback = AccountActions()
    
    init() {
        if !AccountActions.updatedUser.username.isEmpty {
            actionCallback.user = AccountActions.updatedUser
        }
    }
    
    private var dataIsUpdated: Bool {
        return authentication.user?.username != actionCallback.user.username ||
        authentication.user?.email != actionCallback.user.email ||
        authentication.user?.phone != actionCallback.user.phone
    }
    
    private var buttonDisabled: Bool {
        return (actionCallback.user.username.isEmpty ||
                actionCallback.user.email.isEmpty ||
                actionCallback.user.phone.isEmpty) ||
               (!validPhone || !validEmail || !validUsername)
    }
    
    private var validEmail: Bool {
        let range = NSRange(location: 0, length: actionCallback.user.email.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^\\w+\\.?\\w+@[A-z]+\\.\\w+$")

        if actionCallback.user.email.isEmpty { return true }
        return regex.firstMatch(in: actionCallback.user.email, options: [], range: range) != nil
    }
    
    private var validUsername: Bool {
        let range = NSRange(location: 0, length: actionCallback.user.username.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[A-z]+\\w+$")

        if actionCallback.user.username.isEmpty { return true }
        return regex.firstMatch(in: actionCallback.user.username, options: [], range: range) != nil
    }
    
    private var validPhone: Bool {
        let range = NSRange(location: 0, length: actionCallback.user.phone.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^\\d{3,15}$")

        if actionCallback.user.phone.isEmpty { return true }
        return regex.firstMatch(in: actionCallback.user.phone, options: [], range: range) != nil
    }
    
    var body: some View {
        ScrollView {
            VStack {
                RoundedField(inputValue: $actionCallback.user.username, fieldLabel: "Username (Only alphanumerics)", placeholder: "Rick_4103", invalid: !validUsername).padding([.top])
                RoundedField(inputValue: $actionCallback.user.email, fieldLabel: "Email", placeholder: "example@exp.com", invalid: !validEmail).padding([.top])
                RoundedField(inputValue: $actionCallback.user.phone, fieldLabel: "Phone", placeholder: "1234567891", invalid: !validPhone).padding([.top, .bottom])
                Text(!actionCallback.errorMessage.isEmpty ? actionCallback.errorMessage : "").font(.headline).padding(8).foregroundColor(.red)
            
                if dataIsUpdated {
                    Button {
                        actionCallback.setAction(action: .updateAccount)
                        actionCallback.callAction(authentication: authentication)
                    } label: {
                        FillButton(text: "Save Changes", iconName: "square.and.arrow.down", color: .blue, maxWidth: true, disabled: buttonDisabled).padding([.leading, .trailing, .top])
                    }.disabled(buttonDisabled)
                }
                Button {
                    showingModal = true
                } label: {
                    FillButton(text: "Change Password", iconName: "lock.rotation", color: .blue, maxWidth: true).padding([.leading, .trailing])
                }
                Button {
                    actionCallback.setAction(action: .deleteAccount)
                    showingAlert = true
                } label: {
                    FillButton(text: "Delete Account", iconName: "trash", color: .red, maxWidth: true).padding([.leading, .trailing])
                }
                Button {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    authentication.updateValidation(success: false)
                    UserDefaults.standard.set("", forKey: "userEmail")
                    UserDefaults.standard.set("", forKey: "userToken")
                } label: {
                    FillButton(text: "Log out", iconName: "power", color: .red, maxWidth: true).padding([.leading, .trailing])
                }
            }
                .sheet(isPresented: $showingModal) {
                    PasswordResetForm(showingModal: $showingModal)
                }
                .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Deleting Account"),
                            message: Text("Are you sure tu delete your account ?"),
                            primaryButton: .destructive(Text("Delete")) {
                                actionCallback.callAction(authentication: authentication)
                            },
                            secondaryButton: .cancel()
                        )
                }
        }.navigationTitle("My Account")
            .onAppear() {
                actionCallback.user = authentication.user!
                actionCallback.errorMessage = ""
            }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = Authentication()
        auth.user = User(username: "Mikad", email: "mfdsa@fsdafa", phone: "749821798", password: "fdsafa", things: ["keys"], emergencyContacts: [], schedules: [])
        
        return AccountView().environmentObject(auth)
    }
}
