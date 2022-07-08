//
//  Trip.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

struct Trip: Codable {
    let id: UUID
    let date: Date
    let missions: [String]
    let comment: String?
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
}

struct TripInformation: Codable {
    let id: UUID
    let date: String
    let missions: [String]
    let comment: String?
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
}

struct AddTrip: Codable {
    var date: Date
    var missions: [String]
    var comment: String
    var totalDistance: String
    var startingAddress: Address
    var endingAddress: Address
}

struct NewTrip: Codable {
    var date: String
    var missions: [String]
    var comment: String
    var totalDistance: Double
    var startingAddress: Address
    var endingAddress: Address
}

struct DownloadedTripChatPoint: Codable {
    let date: String
    let distance: Double
}

struct TripChartPoint: Identifiable {
    let id = UUID()
    let date: String
    let distance: Double
}

struct ThisWeekInformations: Codable {
    let distance: Double
    let numberOfTrip: Int
}
