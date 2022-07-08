//
//  TripView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        List {
            ForEach(tripController.trips, id: \.id) { trip in
                NavigationLink {
                    DetailedTripView(trip: trip)
                } label: {
                    TripTileView(trip: trip)
                }
            }
        }
        .onAppear {
            if let connectedUser = userController.connectedUser {
                tripController.getTripList(for: connectedUser)
            }
        }
        .navigationTitle(Text("📍 Trips"))
        .searchable(text: $tripController.searchFilter)
        .toolbar(content: {
            NavigationLink {
                AddTripView()
            } label: {
                Image(systemName: "plus.circle")
            }
        })
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripView()
                .environmentObject(TripController())
                .environmentObject(UserController())
        }
    }
}
