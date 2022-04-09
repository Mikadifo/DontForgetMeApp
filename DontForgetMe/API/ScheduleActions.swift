//
//  ScheduleActions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/15/22.
//

import Foundation

public let DATE_FORMAT = "hh:mm a, d MMM y"

class ScheduleActions: ObservableObject {
    @Published var action: Action?
    @Published var modalTitle = ""
    @Published var errorMessage = ""
    @Published var schedule = Schedule(name: "", days: [], time: "")
    @Published var scheduleTime: Date = Date.now
    
    func setAction(action: Action) {
        self.action = action
    }
    
    func callAction(authentication: Authentication) {
        switch action {
        case .newSchedule:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                schedule.id = UUID().uuidString
                let formatter = DateFormatter()
                formatter.dateFormat = DATE_FORMAT
                schedule.time = formatter.string(from: scheduleTime)
                newUser?.schedules.append(schedule)
                let actions = Actions()
                actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    authentication.setUser(user: newUser!)
                }
            } else {
                errorMessage = "Error adding schedule"
            }
            break
        case .updateSchedule:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                let formatter = DateFormatter()
                formatter.dateFormat = DATE_FORMAT
                schedule.time = formatter.string(from: scheduleTime)
                let newArray = newUser?.schedules.filter { schedule in
                    self.schedule.id == schedule.id
                }
                if !newArray!.isEmpty {
                    var valueIndex = -1
                    for (index, schedule) in newUser!.schedules.enumerated() {
                        if self.schedule.id == schedule.id {
                            valueIndex = index
                        }
                    }
                    if newUser != nil && valueIndex != -1 {
                        errorMessage = ""
                        newUser?.schedules[valueIndex] = schedule
                        let actions = Actions()
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            authentication.setUser(user: newUser!)
                        }
                    } else {
                        errorMessage = "Error updating \(schedule.name)"
                    }
                } else {
                    errorMessage = "Schedule not found"
                }
            } else {
                errorMessage = "Error adding schedule"
            }
            break
        case .removeSchedule:
            var newUser = authentication.user
            if newUser != nil {
                errorMessage = ""
                let newArray = newUser?.schedules.filter { schedule in
                    self.schedule.id == schedule.id
                }
                if !newArray!.isEmpty {
                    var valueIndex = -1
                    for (index, schedule) in newUser!.schedules.enumerated() {
                        if self.schedule.id == schedule.id {
                            valueIndex = index
                        }
                    }
                    if newUser != nil && valueIndex != -1 {
                        errorMessage = ""
                        newUser?.schedules.remove(at: valueIndex)
                        let actions = Actions()
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            authentication.setUser(user: newUser!)
                        }
                    } else {
                        errorMessage = "Error deleting \(schedule.name)"
                    }
                } else {
                    errorMessage = "Schedule not found"
                }
            } else {
                errorMessage = "Error deleting schedule"
            }
            break
        default:
            print("DEFAULT")
        }
    }
}
