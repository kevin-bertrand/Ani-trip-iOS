//
//  Address.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

struct Address: Codable {
    let roadName: String
    let roadType: String
    let streetNumber: String
    let complement: String?
    let zipCode: String
    let city: String
    let country: String
}
