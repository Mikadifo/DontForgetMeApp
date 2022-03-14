//
//  SizedCircleButton.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/9/22.
//

import SwiftUI

struct SizedCircleButton: View {
    var content: String
    var width: CGFloat
    var height: CGFloat
    var color: Color
    
    var body: some View {
        Text(content)
            .bold()
            .font(.callout)
            .foregroundColor(.white)
            .background(
                Circle().foregroundColor(color)
                .frame(width: width, height: height)
            )
    }
}

struct SizedCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        SizedCircleButton(content: "M", width: 30, height: 30, color: .gray)
    }
}
