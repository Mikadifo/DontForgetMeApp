//
//  PasswordResetForm.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct PasswordResetForm: View {
    @Binding var showingModal: Bool
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var actionCallback = AccountActions()
    
    private var hasEmptyInfo: Bool {
        return actionCallback.newPassword.isEmpty || actionCallback.currentPassword.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Change Password").font(.largeTitle)
            RoundedField(inputValue: $actionCallback.currentPassword, fieldLabel: "Current Password", placeholder: "", isPassword:  true).padding([.top])
            RoundedField(inputValue: $actionCallback.newPassword, fieldLabel: "New Password", placeholder: "", isPassword: true).padding([.top])
            if !actionCallback.errorMessage.isEmpty {
                Text(actionCallback.errorMessage).font(.headline).padding().foregroundColor(.red)
            }
            HStack {
                Button {
                    showingModal = false
                    actionCallback.errorMessage = ""
                } label: {
                    FillButton(text: "Cancel", iconName: "xmark", color: .red)
                }
                Button {
                    actionCallback.setAction(action: .updatePassword)
                    actionCallback.callAction(authentication: authentication)
                    showingModal = !actionCallback.errorMessage.isEmpty
                } label: {
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue, disabled: hasEmptyInfo)
                }.disabled(hasEmptyInfo)
            }.padding()
        }.onTapGesture{ hideKeyboard() }
    }
}

struct PasswordResetForm_Previews: PreviewProvider {
    static var previews: some View {
        let auth = Authentication()
        auth.user = User(username: "Mikad", email: "mfdsa@fsdafa", phone: "749821798", password: "fdsafa", things: ["keys"], emergencyContacts: [], schedules: [])
        
        return PasswordResetForm(showingModal: .constant(false)).environmentObject(auth)
    }
}
