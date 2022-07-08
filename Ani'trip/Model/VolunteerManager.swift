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
        networkManager.request(urlParams: ["user"], method: .get, authorization: nil, body: nil) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 200:
                    self.sendNotification(.successGettingVolunteerList)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
            }
        }
    }
    
    
    // MARK: Private
    // MARK: Properties
    private let networkManager = NetworkManager()
    private var volunteersList: [User] = []
    
    // MARK: Methods
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
    
    /// Configure and send error notification
    private func sendErrorNotification(with error: String, for notification: Notification.AniTrip) {
        sendNotification(notification)
    }
}
