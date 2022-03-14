//
//  CircleButton.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct CircleButton: View {
    var content: Text
    
    var body: some View {
        content
            .bold()
            .font(.title3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(
                Circle().foregroundColor(.gray)
            )
    }
}


struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(content: Text("MY TEST \(Image(systemName: "plus"))"))
    }
}
