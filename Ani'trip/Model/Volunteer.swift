//
//  Volunteer.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import Foundation

struct Volunteer: Codable, Identifiable{
    let id: UUID
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let missions: [String]
    let address: Address
}
