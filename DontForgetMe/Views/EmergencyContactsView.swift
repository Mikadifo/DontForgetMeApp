//
//  EmergencyContactsView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct EmergencyContact: Identifiable {
    var id = UUID()
    var name: String
    var email: String
}

private let arrayS = [ // TODO: Take from user form
    EmergencyContact(name:"Phone", email: "liliaheredia@gmail.com"),
    EmergencyContact(name:"Josh", email: "lilifhegedia@gmail.com"),
    EmergencyContact(name:"Jose", email: "liliahredia@gmail.com"),
    EmergencyContact(name:"Luis", email: "iiliahredia@gmail.com"),
    EmergencyContact(name:"Delia", email: "liliaeredia@gmail.com"),
    EmergencyContact(name:"Hijo", email: "tiliahedia@gmail.com"),
]

struct EmergencyContactsView: View {
    @State var showingAlert = false
    @State var showingModal = false
    @State var modalTitle = "New Emergency Contact"
    
    var body: some View {
        List(arrayS) { contact in
            HStack {
                Text(contact.name)
                Spacer()
                Image(systemName: "pencil")
            }
                .swipeActions(allowsFullSwipe: true) {
                    Button("Remove") {
                        print("DELETING")
                        showingAlert = true
                    }.tint(.red)
                    Button("Edit") {
                        print("UPDATING")
                        showingModal = true
                        modalTitle = "Update \(contact.name)"
                    }.tint(.blue)
                }
        }
        .overlay(
            HStack {
                Spacer()
                Button {
                    showingModal = true
                } label: {
                    CircleButton(content: Text("\(Image(systemName: "plus"))"))
                        .frame(width: 80, height: 80)
                        .padding([.trailing], 25)
                        .padding([.bottom], 100)
                }
            }.offset(y: 300)
        )
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Deleting {contact.name} ..."),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    print("Deleted ITEM")
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("My Emergency Contacts")
        .sheet(isPresented: $showingModal) {
            EmergencyContactForm(showingModal: $showingModal)
        }
    }
}

struct EmergencyContactsView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactsView()
    }
}
