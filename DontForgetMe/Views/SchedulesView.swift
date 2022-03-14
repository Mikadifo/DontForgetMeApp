//
//  SchedulesView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

struct Schedule: Identifiable {
    var id = UUID()
    var name: String
    var days: [String]
    var time: String
    var emergencyContacts: [String]
}

class Schedules: ObservableObject {
    // TODO: Take from user form
    //TODO: take days array string and try to pass to edit form and see if updated
    @Published var list = [
        Schedule(name:"Daily Morning", days: ["Mo", "Tu", "Fr"], time: "06:19 am", emergencyContacts: ["example@gmail.com"]),
        Schedule(name:"Daily Evening", days: ["Fr"], time: "06:19 am", emergencyContacts: ["exp.exp@exp.exp", "fasf@fdfa.com"]),
        Schedule(name:"Daily Free", days: ["Fr", "Sa", "Su"], time: "06:19 am", emergencyContacts: []),
        Schedule(name:"Dates", days: ["Tu", "Th"], time: "06:19 am", emergencyContacts: []),
        Schedule(name:"Doctor Appointment", days: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], time: "06:19 am", emergencyContacts: ["person.mail.com", "prueba.dsaf@.com", "fdfa.test.f@cl.com"]),
    ]
}

struct SchedulesView: View {
    @State var showingAlert = false
    @State var showingModal = false
    @State var modalTitle = "New Thing"
    @StateObject var schedules = Schedules()
    
    var body: some View {
        List(schedules.list) { schedule in
            ScheduleRow(schedule: getScheduleById(id: schedule.id))
                .swipeActions(allowsFullSwipe: true) {
                    Button("Remove") {
                        print("DELETING")
                        showingAlert = true
                    }.tint(.red)
                    Button("Edit") {
                        print("UPDATING")
                        showingModal = true
                        modalTitle = "Update \(schedule.name)"
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
                title: Text("Deleting {schedule.name} ..."),
                message: Text("Are you sure tu delete this item ?"),
                primaryButton: .destructive(Text("Delete")) {
                    print("Deleted ITEM")
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("My Schedules")
        .sheet(isPresented: $showingModal) {
            ScheduleForm(showingModal: $showingModal)
        }
    }
    
    func getScheduleById(id: UUID) -> Binding<Schedule> {
        return $schedules.list.filter { schedule in
            schedule.id == id
        }[0]
    }
}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulesView()
    }
}
