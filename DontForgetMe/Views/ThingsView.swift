//
//  ThingsView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct ThingsView: View {
    @State var showingAlert = false
    @State var showingModal = false
    @StateObject var actionCallback = Actions()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        var component: AnyView
        if authentication.user?.things == nil || authentication.user!.things.isEmpty {
            component = AnyView(Text("You don't have any things yet, press the + button to add one.").font(.largeTitle).padding())
        } else {
            component = AnyView(List(authentication.user?.things ?? [], id: \.self) { thing in
                Text(thing)
                    .swipeActions(allowsFullSwipe: true) {
                        Button("Remove") {
                            actionCallback.setAction(action: Action.deleteThing)
                            actionCallback.inputValue = thing
                            showingAlert = true
                        }.tint(Color("Red"))
                        Button("Edit") {
                            actionCallback.setAction(action: Action.updateThing)
                            actionCallback.modalTitle = "Update \(thing)"
                            actionCallback.lastValue = thing
                            actionCallback.inputValue = thing
                            showingModal = true
                        }.tint(Color("Blue"))
                    }
                })
        }
        
        return component.overlay(
            HStack {
                Spacer()
                Button {
                    actionCallback.setAction(action: Action.newThing)
                    actionCallback.modalTitle = "New Thing"
                    actionCallback.lastValue = ""
                    actionCallback.inputValue = ""
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
                title: Text("Deleting \(actionCallback.inputValue)"),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    actionCallback.callAction(authentication: authentication)
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("My Things")
        .sheet(isPresented: $showingModal) {
            SingleFieldModal(
                headline: "Enter the thing name below",
                placeholder: "Thing name (keys, phone, wallet, etc)",
                actionCallback: actionCallback,
                showingModal: $showingModal
            )
        }
    }
}

struct ThingsView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = Authentication()
        auth.user = User(username: "Mikad", email: "mfdsa@fsdafa", phone: "749821798", password: "fdsafa", things: ["keys"], emergencyContacts: [], schedules: [])
        
        return ThingsView().environmentObject(auth)
    }
}
