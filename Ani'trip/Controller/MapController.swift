//
//  MapController.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import CoreLocation
import Foundation

final class MapController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    
    // MARK: Methods
    func getAddressFromString(_ address: Address, completionHandler: @escaping ((CLLocationCoordinate2D?)->Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address.streetNumber), \(address.roadType) \(address.roadName) \(address.zipCode), \(address.city) \(address.country)") { placemarks, error in
            let placemark = placemarks?.first
            if let lat = placemark?.location?.coordinate.latitude, let lon = placemark?.location?.coordinate.longitude {
                completionHandler(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    
}
