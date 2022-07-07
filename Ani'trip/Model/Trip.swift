//
//  Trip.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

struct Trip: Codable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let missions: [String]
    let comment: String?
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
}

struct AddTrip {
    var startDate: Date
    var endDate: Date
    var missions: [String]
    var comment: String
    var totalDistance: String
    var startingAddress: Address
    var endingAddress: Address
}

struct TripChartPoint: Identifiable {
    let id = UUID()
    let date: String
    let value: Double
}
