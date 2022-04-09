//
//  FormModalView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/8/22.
//

import SwiftUI

struct ScheduleForm: View {
    @Binding var showingModal: Bool
    @ObservedObject var actionCallback: ScheduleActions
    @EnvironmentObject var authentication: Authentication
    
    private var disabledSave: Bool {
        return actionCallback.schedule.name.isEmpty
        || actionCallback.schedule.days.isEmpty
    }
    
    var body: some View {
        VStack {
            Text(actionCallback.modalTitle).font(.largeTitle)
            RoundedField(inputValue: $actionCallback.schedule.name, fieldLabel: "Name", placeholder: "Daily Morning").padding([.top])
            DaysSelector(daysArray: $actionCallback.schedule.days)
            TimePicker(time: $actionCallback.scheduleTime)
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

struct FormModalView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleForm(showingModal: .constant(false), actionCallback: ScheduleActions()).environmentObject(Authentication())
    }
}
