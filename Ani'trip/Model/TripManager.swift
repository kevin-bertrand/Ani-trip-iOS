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
    
    // MARK: Methods
    /// Getting trip list
    func getTripList() {
        // TODO: Perform API call
        tripList = [Trip(id: UUID(), startDate: .now-1233423, endDate: .now, missions: ["Covoit"], comment: "Test", totalDistance: 34.3, startingAddress: Address(roadName: "Fulgence Bienvenue", roadType: "Place", streetNumber: "7", zipCode: "77600", city: "Bussy-saint-Georges", country: "France"), endingAddress: Address(roadName: "Henri Magisson", roadType: "Avenue", streetNumber: "15", zipCode: "7124", city: "Crégy-lès-Meaux", country: "France"))]
        sendNotification(.successGettingTripList)
    }
    
    /// Adding a new trip
    func addNewTrip(_ trip: AddTrip) {
        // TODO: Perform API call
        sendNotification(.successAddingTrip)
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
