//
//  Places.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import CoreLocation
import Foundation

struct Places: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), lat: Double, lon: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
