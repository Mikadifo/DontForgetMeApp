//
//  FillButton.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct FillButton: View {
    var text: String
    var icon: Image
    var color: Color
    var maxWidth: Bool
    var content: Text
    var disabled: Bool
    
    init(text: String, iconName: String = "", color: Color, maxWidth: Bool = false, trailingIcon: Bool = false, disabled: Bool = false) {
        self.text = text
        self.color = color
        self.maxWidth = maxWidth
        self.disabled = disabled
        icon = Image(systemName: iconName)
        
        if iconName.isEmpty {
            content = Text(text)
        } else if text.isEmpty {
            content = Text("\(icon)")
        } else if trailingIcon {
            content = Text("\(text) \(icon)")
        } else {
            content = Text("\(icon) \(text)")
        }
    }
    
    var body: some View {
        
        content
            .fontWeight(.semibold)
            .frame(maxWidth: maxWidth ? .infinity : .none)
            .padding()
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(40)
            .opacity(disabled ? 0.6 : 1)
    }
}

struct FillButton_Previews: PreviewProvider {
    static var previews: some View {
        FillButton(text: "Login", color: .blue, trailingIcon: true, disabled: true)
    }
}
