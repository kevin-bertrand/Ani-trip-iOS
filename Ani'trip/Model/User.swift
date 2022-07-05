//
//  User.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

struct User: Codable {
    let id: UUID
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let gender: Gender
    let position: Position
    let missions: [String]
    let isActive: Bool
    let address: Address
}

struct UserToConnect {
    var email: String
    var password: String
}

enum Gender: Codable {
    case man
    case woman
    case notDeterminded
}

enum Position: Codable {
    case admin
    case user
}
