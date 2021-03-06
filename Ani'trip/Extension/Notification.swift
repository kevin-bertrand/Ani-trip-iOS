//
//  Notification.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

extension Notification {
    enum AniTrip: String {
        // User
        case loginSuccess = "You successfully loged in"
        case loginFailled = "An error occurs during the login"
        case successfullCreation = "Your account is created. An administrator must activate it!"
        case errorDuringCreation = "An error occurs during the creation of your profil. Please try later!"
        case successRequestForNewPassword = "An email was sent with the instruction to create a new password."
        case errorDuringRequestForNewPassword = "An error occurs during the process. Please try later!"
        case successUserUpdate = "The user update is a success!"
        case errorDuringUpdatingUser = "An error occrus during the process. Please try later!"
        
        // Volunteers
        case successGettingVolunteerList = "The list of volunteers is downloaded"
        case errorGettingVolunteerList = "An error occurs during the downloading of the ..."
        
        // Trips
        case successGettingTripList = "The trip list is downloaded"
        case errorGettingTripList = "An error occurs during the downloading of the trip list..."
        case successAddingTrip = "The new trip is added"
        case errorAddingTrip = "The new trip cannot be added!"
        case successDownloadedHomeInformations = "Home informations successfully downloaded!"
        case errorDownloadedHomeInformations = "Error during downloaded home informations!"
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        var notificationMessage: String {
            return self.rawValue
        }
    }
}
