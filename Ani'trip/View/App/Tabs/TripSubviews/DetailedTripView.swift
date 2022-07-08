//
//  DetailedTripView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import MapKit
import SwiftUI

struct DetailedTripView: View {
    @EnvironmentObject var tripController: TripController
    
    let trip: Trip
    
    var body: some View {
        Form {
            Section(header: Text("Addresses")) {
                VStack(alignment: .leading) {
                    Text("Starting address")
                        .font(.callout)
                        .foregroundColor(.gray)
                    AddressTileView(region: $tripController.startAddress, address: trip.startingAddress, marker: tripController.startPin)
                }
                VStack(alignment: .leading) {
                    Text("Ending address")
                        .font(.callout)
                        .foregroundColor(.gray)
                    AddressTileView(region: $tripController.endAddress, address: trip.endingAddress, marker: tripController.endPin)
                }
            }
            
            Section(header: Text("Trip information")) {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(trip.date.formatted(date: .numeric, time: .omitted))
                }
                HStack {
                    Text("Total distance")
                    Spacer()
                    Text("\(trip.totalDistance.twoDigitPrecision) km")
                }
            }
            
            Section(header: Text("Missions")) {
                Text(trip.missions.joined(separator: ", "))
            }
            
            if let comment = trip.comment {
                Section(header: Text("Comments")) {
                    Text(comment)
                }
            }
        }
        .onAppear {
            tripController.showDetailledTrip(trip: trip)
        }
        .navigationTitle(Text("\(trip.startingAddress.city) → \(trip.endingAddress.city)"))
        
    }
}

struct DetailedTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTripView(trip: Trip(id: UUID(), date: .now, missions: [], comment: nil, totalDistance: 0.0, startingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""), endingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "")))
            .environmentObject(TripController())
    }
}
