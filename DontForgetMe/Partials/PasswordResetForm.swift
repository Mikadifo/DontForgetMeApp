//
//  PasswordResetForm.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct PasswordResetForm: View {
    @Binding var showingModal: Bool
    @Binding var currentPassword: String
    @Binding var newPassword: String
    
    var body: some View {
        VStack {
            Text("Change Password").font(.largeTitle)
            RoundedField(inputValue: $currentPassword, fieldLabel: "Current Password", placeholder: "", isPassword:  true).padding([.top])
            RoundedField(inputValue: $currentPassword, fieldLabel: "New Password", placeholder: "", isPassword: true).padding([.top])
            
            Button {
                showingModal = false
                currentPassword = ""
                newPassword = ""
            } label: {
                HStack {
                    FillButton(text: "Cancel", iconName: "xmark", color: .red)
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue)
                }.padding()
            }
        }
    }
}

struct PasswordResetForm_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetForm(showingModal: .constant(false), currentPassword: .constant(""), newPassword: .constant(""))
    }
}
