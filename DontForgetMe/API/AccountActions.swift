//
//  AccountActions.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/18/22.
//

import Foundation
import UserNotifications

class AccountActions: ObservableObject {
    static var updatedUser: User = emptyUser()
    
    @Published var action: Action?
    @Published var errorMessage = ""
    @Published var user: User = emptyUser()
    @Published var currentPassword = ""
    @Published var newPassword = ""
    
    func setAction(action: Action) {
        self.action = action
        AccountActions.updatedUser = emptyUser()
    }
    
    func callAction(authentication: Authentication) {
        switch action {
        case .updateAccount:
            let actions = Actions()
            errorMessage = ""
            if user.username != authentication.user?.username
                || user.email != authentication.user?.email
                || user.phone != authentication.user?.phone {
                let updatedUsername = user.username != authentication.user?.username ? user.username : ""
                let updatedEmail = user.email != authentication.user?.email ? user.email : ""
                let updatedPhone = user.phone != authentication.user?.phone ? user.phone : ""
                UserService().userByPersonalInfo(email: updatedEmail, username: updatedUsername, phone: updatedPhone, token: authentication.userToken) { [self] (response) in
                    if (response.statusOk! || response.user != nil) {
                        errorMessage = "User already exists with this information"
                        return
                    } else {
                        errorMessage = ""
                    }
                    actions.updateUser(userEmail: authentication.user!.email, newUser: user, token: authentication.userToken)
                    errorMessage = actions.errorMessage
                    if errorMessage.isEmpty {
                        authentication.setUser(user: user)
                        UserDefaults.standard.set(user.email, forKey: "userEmail")
                        AccountActions.updatedUser = user
                        authentication.updateToast(showing: true, message: "Account updated")
                    }
                }
            } else {
                actions.updateUser(userEmail: authentication.user!.email, newUser: user, token: authentication.userToken)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    authentication.setUser(user: user)
                    UserDefaults.standard.set(user.email, forKey: "userEmail")
                    AccountActions.updatedUser = user
                }
            }
            break
        case .updatePassword:
            if authentication.user!.password == currentPassword {
                if authentication.user!.password == newPassword {
                    errorMessage = "New Password can not be the same as old"
                    break
                }
                var newUser = authentication.user
                if newUser != nil {
                    errorMessage = ""
                    newUser?.password = newPassword
                    let actions = Actions()
                    actions.updateUser(userEmail: authentication.user!.email, newUser: newUser!, token: authentication.userToken)
                    errorMessage = actions.errorMessage
                    if errorMessage.isEmpty {
                        authentication.setUser(user: newUser!)
                        AccountActions.updatedUser = newUser!
                        authentication.updateToast(showing: true, message: "Password updated")
                    }
                } else {
                    errorMessage = "Error updating password"
                }
            } else {
                errorMessage = "Current Password is incorrect"
            }
            break
        case .deleteAccount:
            if authentication.user != nil {
                errorMessage = ""
                let actions = Actions()
                actions.deleteUser(userEmail: authentication.user!.email, token: authentication.userToken)
                errorMessage = actions.errorMessage
                if errorMessage.isEmpty {
                    authentication.user?.schedules.forEach { schedule in
                        ScheduleActions.removeScheduleNotifications(notificationIds: schedule.notifications)
                    }
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    authentication.setUser(user: emptyUser())
                    authentication.updateValidation(success: false)
                    UserDefaults.standard.set("", forKey: "userEmail")
                    UserDefaults.standard.set("", forKey: "userToken")
                }
            } else {
                errorMessage = "Error deleting password"
            }
            break
        default:
            authentication.updateToast(showing: true, message: "Can't found option (\(String(describing: action)))")
        }
    }
}
