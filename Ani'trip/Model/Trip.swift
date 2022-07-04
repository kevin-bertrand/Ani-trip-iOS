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
