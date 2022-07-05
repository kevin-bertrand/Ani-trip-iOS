//
//  UserManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

final class UserManager {
    // MARK: Public
    // MARK: Properties
    
    // MARK: Methods
    /// Perform the login of the user
    func login(user: UserToConnect) {
        // TODO: Process login
        sendNotification(.loginSuccess)
    }
    
    /// Perform the creation of the new account
    func createAccount(for user: UserToConnect) {
        // TODO: Process creation
        sendNotification(.successfullCreation)
    }
    
    /// Perform the asking of a new password
    func forgetPassword(for user: UserToConnect) {
        // TODO: Process api call
        sendNotification(.successRequestForNewPassword)
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
}
