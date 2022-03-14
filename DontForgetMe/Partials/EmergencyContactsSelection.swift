//
//  EmergencyContactsSelection.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/10/22.
//

import SwiftUI

struct EmergencyContactsSelection: View { // TO MAKE IN NEW FEATURE
    @State var selectAll: Bool = false
    @State var showContactsList: Bool = false
    @Binding var selection: Set<String>
    @Binding var emergencyContacts: [String]
        
    var body: some View {
        NavigationView {
        VStack {
            Text("Emergency Contact/s")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing])
            HStack {
                Button {
                    selectAll = true
                    showContactsList = false
                } label: {
                    if selectAll {
                        Text("Select All \(Image(systemName: "checkmark"))").foregroundColor(.gray)
                    } else {
                        Text("Select All")
                    }
                }
                Spacer()
                Button {
                    showContactsList = true
                    selectAll = false
                } label: {
                    if showContactsList {
                        Text("Custom Selection").foregroundColor(.gray)
                    } else {
                        Text("Custom Selection")
                    }
                }
            }.padding()
            if showContactsList {
                List(emergencyContacts, id: \.self, selection: $selection) { contact in
                    Text(contact)
                }.toolbar { ToolbarItem(placement: .bottomBar){EditButton()}}
            }
            }
        }
        .frame(width: .infinity, height: 200)
    }
}

struct EmergencyContactsSelection_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactsSelection(
            selection: .constant(
                ["prueba@fdf.com", "fsdfa23fdf#fd.com"]
            ),
            emergencyContacts: .constant(
                ["prueba@fdf.com", "fsdfa23fdf#fd.com", "fodspu@fdfa.com", "fdsfas.fds@fdfaMIK.com"]
            )
        )
    }
}
