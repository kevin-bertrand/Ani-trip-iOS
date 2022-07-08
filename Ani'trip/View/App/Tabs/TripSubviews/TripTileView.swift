//
//  TripTileView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 07/07/2022.
//

import SwiftUI

struct TripTileView: View {
    let trip: Trip
    
    var body: some View {
        HStack {
            Image("TripIcon")
                .resizable()
                .frame(width: 50, height: 80)
            VStack(alignment: .leading) {
                Text("\(trip.startingAddress.city) → \(trip.endingAddress.city)")
                    .bold()
                    .font(.title2)
                Text(trip.startDate.formatted(date: .numeric, time: .shortened))
                Text("\(trip.totalDistance) km")
            }
        }
    }
}

struct TripTileView_Previews: PreviewProvider {
    static var previews: some View {
        TripTileView(trip: Trip(id: UUID(), startDate: .now, endDate: .now, missions: [], comment: "", totalDistance: 0.0, startingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""), endingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "")))
    }
}
