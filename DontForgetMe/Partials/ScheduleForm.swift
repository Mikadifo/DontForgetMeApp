//
//  FormModalView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/8/22.
//

import SwiftUI

struct ScheduleForm: View {
    @Binding var showingModal: Bool
    @State var daysArray: [String] = [] //TODO: Change to user data
    @State var fieldInput = "" //TODO: Change to user data
    @State var scheduleTime = Date.now //TODO: Change to user data
    
    var body: some View {
        VStack {
            Text("Schedule").font(.largeTitle)
            RoundedField(inputValue: $fieldInput, fieldLabel: "Name", placeholder: "Daily Morning").padding([.top])
            DaysSelector(daysArray: $daysArray)
            TimePicker(time: $scheduleTime)
            //TEST
            Button {
                showingModal = false
                fieldInput = ""
                print(daysArray)
            } label: {
                HStack {
                    FillButton(text: "Cancel", iconName: "xmark", color: .red)
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue)
                }.padding()
            }
        }
    }
}

struct FormModalView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleForm(showingModal: .constant(false))
    }
}
