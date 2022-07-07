//
//  User.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

struct ConnectedUser: Codable {
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let gender: String
    let position: String
    let missions: [String]
    let token: String
}

struct User: Codable {
    let id: UUID
    var firstname: String
    var lastname: String
    let email: String
    var phoneNumber: String
    var gender: Gender
    var position: Position
    var missions: [String]
    var isActive: Bool
    var address: Address
    var token: String
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
//    var address: Address
    var password: String
    var passwordVerification: String
}

struct UserToConnect {
    var email: String
    var password: String
}

enum Gender: String, Codable {
    case man = "man"
    case woman = "woman"
    case notDeterminded = "not_determined"
}

enum Position: String, Codable, CaseIterable {
    case admin = "admin"
    case user = "user"
    
    var name: String { rawValue }
}
