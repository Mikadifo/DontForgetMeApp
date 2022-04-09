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
    
    var body: some View {
        ScrollView {
            VStack {
                RoundedField(inputValue: $actionCallback.user.username, fieldLabel: "Username", placeholder: "Rick_4103").padding([.top])
                RoundedField(inputValue: $actionCallback.user.email, fieldLabel: "Email", placeholder: "example@exp.com").padding([.top])
                RoundedField(inputValue: $actionCallback.user.phone, fieldLabel: "Phone", placeholder: "(###) ###-####").padding([.top, .bottom])
                Text(!actionCallback.errorMessage.isEmpty ? actionCallback.errorMessage : "").font(.headline).padding(8).foregroundColor(.red)
            
                if dataIsUpdated {
                    Button {
                        actionCallback.setAction(action: .updateAccount)
                        actionCallback.callAction(authentication: authentication)
                    } label: {
                        FillButton(text: "Save Changes", iconName: "square.and.arrow.down", color: .blue, maxWidth: true).padding([.leading, .trailing, .top])
                    }
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
                    authentication.updateValidation(success: false)
                    UserDefaults.standard.set("", forKey: "userEmail")
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
