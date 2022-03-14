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
        List(authentication.user?.things ?? [], id: \.self) { thing in
            Text(thing)
                .swipeActions(allowsFullSwipe: true) {
                    Button("Remove") {
                        print("DELETING")
                        showingAlert = true
                    }.tint(.red)
                    Button("Edit") {
                        print("EIDT")
                        actionCallback.setAction(action: Action.updateThing)
                        actionCallback.modalTitle = "Update \(thing)"
                        actionCallback.lastValue = thing
                        actionCallback.inputValue = thing
                        showingModal = true
                    }.tint(.blue)
                }
        }
        .overlay(
            HStack {
                Spacer()
                Button {
                    print("NEW")
                    actionCallback.setAction(action: Action.newThing)
                    actionCallback.modalTitle = "New Thing"
                    actionCallback.lastValue = ""
                    actionCallback.inputValue = ""
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
                title: Text("Deleting {thing.name} ..."),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    print("Deleted ITEM")
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
        ThingsView().environmentObject(Authentication())
    }
}
