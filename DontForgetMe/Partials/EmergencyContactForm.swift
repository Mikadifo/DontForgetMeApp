//
//  EmergencyContactForm.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/8/22.
//

import SwiftUI

struct EmergencyContactForm: View {
    @Binding var showingModal: Bool
    @ObservedObject var actionCallback: ContactsActions
    @EnvironmentObject var authentication: Authentication
    
    private var disabledSave: Bool {
        return actionCallback.contact.nickname.isEmpty
        || actionCallback.contact.email.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Emergency Contact").font(.largeTitle)
            RoundedField(inputValue: $actionCallback.contact.nickname, fieldLabel: "Nickname", placeholder: "Mom, Son, Anna").padding([.top])
            RoundedField(inputValue: $actionCallback.contact.email, fieldLabel: "Email", placeholder: "example@exp.com").padding([.top, .bottom])
            Text(!actionCallback.errorMessage.isEmpty ? actionCallback.errorMessage : "").font(.headline).padding().foregroundColor(.red)
            HStack {
                Button {
                    showingModal = false
                    actionCallback.errorMessage = ""
                } label: {
                    FillButton(text: "Cancel", iconName: "xmark", color: .red)
                }
                Button {
                    actionCallback.callAction(authentication: authentication)
                    showingModal = !actionCallback.errorMessage.isEmpty
                } label: {
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue, disabled: disabledSave)
                }.disabled(disabledSave)
            }.padding()
        }
    }
}

struct EmergencyContactForm_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactForm(showingModal: .constant(false), actionCallback: ContactsActions()).environmentObject(Authentication())
    }
}
