//
//  ModalView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct SingleFieldModal: View {
    var headline: String
    var placeholder: String
    @ObservedObject var actionCallback: Actions
    @Binding var showingModal: Bool
    @EnvironmentObject var authentication: Authentication
    
    private var disabledButton: Bool {
        return actionCallback.inputValue == actionCallback.lastValue || actionCallback.inputValue.isEmpty
    }
    
    var body: some View {
        VStack {
            Text(actionCallback.modalTitle).font(.largeTitle)
            RoundedField(inputValue: $actionCallback.inputValue, fieldLabel: headline, placeholder: placeholder).padding()
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
                    FillButton(text: "Save", iconName: "square.and.arrow.down", color: .blue, disabled: disabledButton)
                }.disabled(disabledButton)
            }
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        SingleFieldModal(
            headline: "Enter the new name",
            placeholder: "Thing name (...)",
            actionCallback: Actions(),
            showingModal: .constant(false)
        )
    }
}
