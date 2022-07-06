//
//  VolunteerManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import Foundation

final class VolunteerManager {
    // MARK: Public
    // MARK: Properties
    var volunteers: [User] { volunteersList.sorted {$0.firstname.lowercased() < $1.firstname.lowercased()} }
    
    // MARK: Methods
    /// Getting the list of all volunteers
    func getVolunteerList() {
        // TODO: Perform API call
        sendNotification(.successGettingVolunteerList)
    }
    
    
    // MARK: Private
    // MARK: Properties
    private var volunteersList: [User] = []
    
    // MARK: Methods
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
}
