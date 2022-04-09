//
//  EmergencyContactsView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct EmergencyContactsView: View {
    @State var showingAlert = false
    @State var showingModal = false
    
    @StateObject var actionCallback = ContactsActions()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        var component: AnyView
        if authentication.user?.emergencyContacts == nil || authentication.user!.emergencyContacts.isEmpty {
            component = AnyView(Text("You don't have any contacts yet, press the + button to add one.").font(.largeTitle).padding())
        } else {
            component = AnyView(List(authentication.user!.emergencyContacts) { contact in
                Text(contact.nickname)
                    .swipeActions(allowsFullSwipe: true) {
                        Button("Remove") {
                            actionCallback.setAction(action: .removeContact)
                            actionCallback.contact = contact
                            showingAlert = true
                        }.tint(Color("Red"))
                        Button("Edit") {
                            actionCallback.setAction(action: .updateContact)
                            actionCallback.modalTitle = "Update \(contact.nickname)"
                            actionCallback.contact = contact
                            actionCallback.oldContact = contact
                            showingModal = true
                        }.tint(Color("Blue"))
                    }
            })
        }
        
        return component.overlay(
            HStack {
                Spacer()
                Button {
                    actionCallback.setAction(action: .newContact)
                    actionCallback.modalTitle = "New Contact"
                    actionCallback.contact = Contact(nickname: "", email: "")
                    actionCallback.oldContact = Contact(nickname: "", email: "")
                    showingModal = true
                } label: {
                    CircleButton(content: Text("\(Image(systemName: "plus"))"), color: Color("Orange"))
                        .frame(width: 80, height: 80)
                        .padding([.trailing], 25)
                        .padding([.bottom], 100)
                }
            }.offset(y: 300)
        )
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Deleting \(actionCallback.contact.nickname)"),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    actionCallback.callAction(authentication: authentication)
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("My Emergency Contacts")
        .sheet(isPresented: $showingModal) {
            EmergencyContactForm(showingModal: $showingModal, actionCallback: actionCallback)
        }
    }
}

struct EmergencyContactsView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = Authentication()
        auth.user = User(username: "Mikad", email: "mfdsa@fsdafa", phone: "749821798", password: "fdsafa", things: ["keys"], emergencyContacts: [Contact(id: "12313", nickname: "fdsfas", email: "fsdaf@familc.om")], schedules: [])
        return EmergencyContactsView().environmentObject(auth)
    }
}
