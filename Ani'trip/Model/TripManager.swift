//
//  TripManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import Foundation

final class TripManager {
    // MARK: Public
    // MARK: Properties
    var trips: [Trip] { tripList.sorted {$0.startDate > $1.startDate}}
    var numberOfTripThisWeek: Int = 0
    var distanceThisWeek: Double = 0.0
    var threeLatestTrips: [Trip] = []
    
    // MARK: Methods
    /// Getting trip list
    func getTripList() {
        // TODO: Perform API call
        sendNotification(.successGettingTripList)
    }
    
    /// Adding a new trip
    func addNewTrip(_ trip: AddTrip) {
        // TODO: Perform API call
        sendNotification(.successAddingTrip)
    }
    
    /// Downloading home informations
    func downloadHomeInformations() {
        // TODO: Perform API call
        sendNotification(.successDownloadedHomeInformations)
    }
    
    // MARK: Private
    // MARK: Properties
    private var tripList: [Trip] = []
    
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
}
