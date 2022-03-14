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
    
    var body: some View {
        VStack {
            Text("Create Account").font(.largeTitle)
            RoundedField(inputValue: $username, fieldLabel: "Username", placeholder: "Rick_4103").padding([.top, .bottom])
            RoundedField(inputValue: $email, fieldLabel: "Email", placeholder: "example@exp.com").padding([.top, .bottom])
            RoundedField(inputValue: $phone, fieldLabel: "Phone", placeholder: "(###) ###-####").padding([.top, .bottom])
            RoundedField(inputValue: $password, fieldLabel: "Password", placeholder: "", isPassword: true).padding([.top, .bottom])
            Button {
                //TODO: Create acconunt in db and validate form
            } label: {
                FillButton(text: "Create Account", color: .blue, maxWidth: true, trailingIcon: true).padding([.leading, .trailing])
            }
        }
    }
}

struct CreateAccountForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountForm()
    }
}
