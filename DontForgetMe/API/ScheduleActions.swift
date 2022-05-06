//
//  ScheduleActions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/15/22.
//

import Foundation
import UserNotifications

public let DATE_FORMAT = "hh:mm a, d MMM y"

class ScheduleActions: ObservableObject {
    @Published var action: Action?
    @Published var modalTitle = ""
    @Published var errorMessage = ""
    @Published var schedule = Schedule(name: "", days: [], time: "", notifications: [])
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
                let oldNotifications = schedule.notifications
                schedule.notifications = ScheduleActions.setUpNotifications(schedule: schedule, scheduleTime: scheduleTime, authentication: authentication)
                newUser?.schedules.append(schedule)
                
                let actions = Actions()
                actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    ScheduleActions.removeScheduleNotifications(notificationIds: oldNotifications)
                    authentication.setUser(user: newUser!)
                    authentication.updateToast(showing: true, message: "\(schedule.name) created")
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
                        let oldNotifications = schedule.notifications
                        schedule.notifications = ScheduleActions.setUpNotifications(schedule: schedule, scheduleTime: scheduleTime, authentication: authentication)
                        newUser?.schedules[valueIndex] = schedule
                        
                        let actions = Actions()
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            ScheduleActions.removeScheduleNotifications(notificationIds: oldNotifications)
                            authentication.setUser(user: newUser!)
                            authentication.updateToast(showing: true, message: "\(schedule.name) updated")
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
                        actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                        errorMessage = actions.errorMessage
                        if errorMessage.isEmpty {
                            ScheduleActions.removeScheduleNotifications(notificationIds: schedule.notifications)
                            authentication.setUser(user: newUser!)
                            authentication.updateToast(showing: true, message: "\(schedule.name) deleted")
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
            authentication.updateToast(showing: true, message: "Can't found option (\(String(describing: action)))")
        }
    }
    
    static func setUpNotifications(schedule: Schedule, scheduleTime: Date, authentication: Authentication, notificationIdArray: [String] = []) -> [String] {
        let intDays = DaysSelector.getWeekDaysAsIntArray(weekDays: schedule.days)
        let formatter = DateFormatter()
        var notificationIds: [String] = []
        
        formatter.dateFormat = "k:mm"
        let stringTime = formatter.string(from: scheduleTime).split(separator: ":")

        intDays.enumerated().forEach { sequence in
            let day = sequence.element
            let index = sequence.offset
            var dateComponents = DateComponents()
            dateComponents.hour = Int(stringTime[0]) ?? 0
            dateComponents.minute = Int(stringTime[1]) ?? 0
            dateComponents.weekday = day
            var notificationUUID = UUID().uuidString
            if !notificationIdArray.isEmpty {
                notificationUUID = notificationIdArray[index]
            }
            let notificationId = setNotification(schedule: schedule, dateComponents: dateComponents, authentication: authentication, notificationId: notificationUUID)
            notificationIds.append(notificationId)
        }
        
        return notificationIds
    }
    
    static func setNotification(schedule: Schedule, dateComponents: DateComponents, authentication: Authentication, notificationId: String) -> String {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't Forget Me! (\(schedule.name))"
        content.body = "CHECK YOUR: \(authentication.user!.things.joined(separator: ", "))"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.defaultCritical
        content.categoryIdentifier = "ACTIONS"
        
        let forgot = UNNotificationAction(identifier: "FORGOT", title: "Notify Contacts", options: .destructive)
        let haveAll = UNNotificationAction(identifier: "HAVE_ALL", title: "I have all", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [haveAll, forgot], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        center.add(request)
        
        return notificationId
    }
    
    static func removeScheduleNotifications(notificationIds: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: notificationIds)
        center.removePendingNotificationRequests(withIdentifiers: notificationIds)
    }

}
