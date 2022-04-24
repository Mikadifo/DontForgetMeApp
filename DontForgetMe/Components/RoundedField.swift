//
//  RoundedField.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/8/22.
//

import SwiftUI

struct RoundedField: View {
    @Binding var inputValue: String
    var invalid: Bool
    var fieldLabel: String
    var placeholder: String
    var field: AnyView
    
    init(inputValue: Binding<String>, fieldLabel: String, placeholder: String, isPassword: Bool = false, invalid: Bool = false) {
        self._inputValue = inputValue
        self.fieldLabel = fieldLabel
        self.placeholder = placeholder
        if isPassword {
            field = AnyView(SecureField(placeholder, text: inputValue))
        } else {
            field = AnyView(TextField(placeholder, text: inputValue))
        }
        self.invalid = invalid
    }
    
    var body: some View {
        VStack {
            Text(fieldLabel)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing])
            
            field
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(invalid ? .red : .black, style: StrokeStyle(lineWidth: 1.0)))
                .padding([.leading, .trailing])
        }
    }
}

struct RoundedField_Previews: PreviewProvider {
    static var previews: some View {
        RoundedField(
            inputValue: .constant(""),
            fieldLabel: "Enter your name",
            placeholder: "Prueba Placeholder",
            isPassword: false,
            invalid: true
        ).previewLayout(.fixed(width: 400, height: 120))
    }
}
