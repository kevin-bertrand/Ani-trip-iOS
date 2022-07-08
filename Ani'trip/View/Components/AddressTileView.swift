//
//  AddressTileView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import MapKit
import SwiftUI

struct AddressTileView: View {
    @Binding var region: MKCoordinateRegion
    let address: Address
    let marker: [Places]
    
    var body: some View {
        HStack {
            Map(coordinateRegion: $region, interactionModes: .zoom, annotationItems: marker) { location in
                MapMarker(coordinate: location.location, tint: .accentColor)
            }.frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text("\(address.streetNumber), \(address.roadType) \(address.roadName)")
                if let complement = address.complement {
                    Text(complement)
                }
                Text("\(address.zipCode), \(address.city)")
                Text("\(address.country)")
            }
            .bold()
        }
    }
}

struct AddressTileView_Previews: PreviewProvider {
    static var previews: some View {
        AddressTileView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20, longitude: 20), latitudinalMeters: 20, longitudinalMeters: 20)), address: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""), marker: [])
    }
}
