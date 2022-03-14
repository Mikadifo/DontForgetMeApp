//
//  EmergencyContactForm.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/8/22.
//

import SwiftUI

struct EmergencyContactForm: View {
    @Binding var showingModal: Bool
    @State var fieldInput = "" //TODO: Change to user data
    
    var body: some View {
        VStack {
            Text("Emergency Contact").font(.largeTitle)
            RoundedField(inputValue: $fieldInput, fieldLabel: "Nickname", placeholder: "Mom, Son, Anna").padding([.top])
            RoundedField(inputValue: $fieldInput, fieldLabel: "Email", placeholder: "example@exp.com").padding([.top, .bottom])
            Button {
                showingModal = false
                fieldInput = ""
            } label: {
                HStack {
                    FillButton(text: "Cancel", iconName: "xmark", color: .red)
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue)
                }.padding()
            }
        }
    }
}

struct EmergencyContactForm_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactForm(showingModal: .constant(false))
    }
}
