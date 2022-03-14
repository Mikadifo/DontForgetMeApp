//
//  AccountView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct AccountView: View {
    //TODO: Change to Binding user maybe using Environment in all app
    @State var showingModal = false
    @State var showingAlert = false
    @State var newUsername: String = ""
    @State var newEmail: String = ""
    @State var newPhone: String = ""
    @State var password: String //TODO: Take from real data
    @State var newPassword: String = ""
    @EnvironmentObject var authentication: Authentication
    
    private var dataIsUpdated: Bool {
        //TODO: Set correct data from user class
        // If user.data == newData return....
        return false
    }
    
    var body: some View {
        ScrollView {
        VStack {
            RoundedField(inputValue: $newUsername, fieldLabel: "Username", placeholder: "Rick_4103").padding([.top])
            RoundedField(inputValue: $newEmail, fieldLabel: "Email", placeholder: "example@exp.com").padding([.top])
            RoundedField(inputValue: $newPhone, fieldLabel: "Phone", placeholder: "(###) ###-####").padding([.top, .bottom])
            
            if dataIsUpdated {
                Button {
                    //TODO: Update user info
                    print("Updated info")
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
                showingAlert = true
            } label: {
                FillButton(text: "Delete Account", iconName: "trash", color: .red, maxWidth: true).padding([.leading, .trailing])
            }
            FillButton(text: "Log out", iconName: "power", color: .red, maxWidth: true).padding([.leading, .trailing])
        }
            .sheet(isPresented: $showingModal) {
                PasswordResetForm(showingModal: $showingModal, currentPassword: $password, newPassword: $newPassword)
            }
            .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Deleting Account ..."),
                        message: Text("Are you sure tu delete your account ?"),
                        primaryButton: .destructive(Text("Delete")) {
                        print("Deleted ITEM")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
            .navigationTitle("My Account")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(password: "")
    }
}
