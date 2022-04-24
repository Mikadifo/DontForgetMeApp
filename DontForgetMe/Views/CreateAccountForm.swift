//
//  CreateAccountForm.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct CreateAccountForm: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var response: Response = Response()
    @EnvironmentObject var authentication: Authentication
    
    private var buttonDisabled: Bool {
        return Validation.textsAreNotEmpty(username, email, phone, password) &&
               (validPhone && validEmail && validUsername)
    }
    
    private var validEmail: Bool {
        if email.isEmpty { return true }
        return Validation.isValid(text: email, pattern: Validation.EMAIL)
    }
    
    private var validUsername: Bool {
        if username.isEmpty { return true }
        return Validation.isValid(text: username, pattern: Validation.USERNAME)
    }
    
    private var validPhone: Bool {
        if phone.isEmpty { return true }
        return Validation.isValid(text: phone, pattern: Validation.PHONE)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Create Account").font(.largeTitle)
                if !(response.statusOk ?? true) {
                    Text(response.errorMessagge ?? "Error while creating account, try again later").font(.headline).foregroundColor(.red).padding([.trailing, .leading])
                }
                RoundedField(inputValue: $username, fieldLabel: "Username (Only alphanumerics)", placeholder: "Rick_4103", invalid: !validUsername).padding([.top, .bottom])
                RoundedField(inputValue: $email, fieldLabel: "Email", placeholder: "example@exp.com", invalid: !validEmail).padding([.top, .bottom])
                RoundedField(inputValue: $phone, fieldLabel: "Phone", placeholder: "1234567891", invalid: !validPhone).padding([.top, .bottom]).keyboardType(.numberPad)
                RoundedField(inputValue: $password, fieldLabel: "Password", placeholder: "", isPassword: true).padding([.top, .bottom])
                Button {
                    createAccount()
                } label: {
                    FillButton(text: "Create Account", color: .blue, maxWidth: true, trailingIcon: true, disabled: !buttonDisabled).padding([.leading, .trailing])
                }.disabled(buttonDisabled)
            }
        }.onTapGesture { hideKeyboard() }
    }
    
    func createAccount() {
        UIApplication.shared.endEditing()
        let user = User(username: username, email: email.lowercased(), phone: phone, password: password, things: [], emergencyContacts: [], schedules: [])
        UserService().createAccount(user: user) { (response) in
            self.response = response
            if (response.user != nil) {
                UserDefaults.standard.set(response.user?.email, forKey: "userEmail")
                authentication.setUser(user: response.user!)
            }
            authentication.updateValidation(success: response.statusOk ?? false)
        }
    }
}

struct CreateAccountForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountForm().environmentObject(Authentication())
    }
}
