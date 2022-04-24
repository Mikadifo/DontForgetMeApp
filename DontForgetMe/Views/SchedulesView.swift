//
//  SchedulesView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct SchedulesView: View {
    @State var showingAlert = false
    @State var showingModal = false
    
    @StateObject var actionCallback = ScheduleActions()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        var component: AnyView
        if authentication.user?.schedules == nil || authentication.user!.schedules.isEmpty {
            component = AnyView(Text("You don't have any schedules yet, press the + button to add one.").font(.largeTitle).padding())
        } else {
            component = AnyView(List(authentication.user?.schedules ?? []) { schedule in
                ScheduleRow(schedule: getScheduleById(id: schedule.id!))
                    .swipeActions(allowsFullSwipe: true) {
                        Button("Remove") {
                            actionCallback.setAction(action: Action.removeSchedule)
                            actionCallback.schedule = schedule
                            showingAlert = true
                        }.tint(Color("Red"))
                        Button("Edit") {
                            actionCallback.setAction(action: Action.updateSchedule)
                            actionCallback.modalTitle = "Update \(schedule.name)"
                            actionCallback.scheduleTime = SchedulesView.getFormattedDate(time: schedule.time)
                            actionCallback.schedule = schedule
                            showingModal = true
                        }.tint(Color("Blue"))
                    }
            })
        }
        return component.overlay(
            HStack {
                Spacer()
                Button {
                    actionCallback.setAction(action: Action.newSchedule)
                    actionCallback.modalTitle = "New Schedule"
                    actionCallback.schedule = Schedule(name: "", days: [], time: "", notifications: [])
                    actionCallback.scheduleTime = Date.now
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
                title: Text("Deleting \(actionCallback.schedule.name)"),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    actionCallback.callAction(authentication: authentication)
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("My Schedules")
        .sheet(isPresented: $showingModal) {
            ScheduleForm(showingModal: $showingModal, actionCallback: actionCallback)
        }
    }
    
    func getScheduleById(id: String) -> Schedule {
        (authentication.user?.schedules.filter { schedule in
            schedule.id == id
        }[0])!
    }
    
    static func getFormattedDate(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMAT
        return formatter.date(from: time)!
    }
}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = Authentication()
        auth.user = User(username: "Mikad", email: "mfdsa@fsdafa", phone: "749821798", password: "fdsafa", things: ["keys"], emergencyContacts: [], schedules: [Schedule(id: "0D", name: "name", days: ["Mo", "Tu"], time: "13:00 AM, ...", notifications: [])])
        
        return SchedulesView().environmentObject(auth)
    }
}
