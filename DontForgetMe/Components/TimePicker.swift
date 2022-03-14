//
//  TimePicker.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct TimePicker: View {
    @Binding var time: Date
    
    var body: some View {
        DatePicker(
            selection: $time,
            displayedComponents: .hourAndMinute,
            label: {
                Text("Select time")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
        ).padding()
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(time: .constant(Date.now))
    }
}
