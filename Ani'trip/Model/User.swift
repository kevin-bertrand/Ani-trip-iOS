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

struct UpdateUser: Codable {
    let id: UUID
    var firstname: String
    var lastname: String
    var email: String
    var phoneNumber: String
    var gender: Gender
    var position: Position
    var missions: [String]
    var isActive: Bool
    var address: Address
    var password: String
    var passwordVerification: String
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

enum Position: String, Codable, CaseIterable {
    case admin = "Administrator"
    case user = "User"
    
    var name: String { rawValue }
}
