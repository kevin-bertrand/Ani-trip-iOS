//
//  HomeView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 07/07/2022.
//

import Charts
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
        
    var body: some View {
        List {
            Section {
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        NewsTileView(title: "This week:", icon: Image(systemName: "car"), information: "\(tripController.numberOfTripThisWeek) trips")
                        NewsTileView(title: "This week:", icon: Image("TripIcon"), information: "\(tripController.distanceThisWeek.twoDigitPrecision) km")
                    }.padding()
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Total distance")
                        Spacer()
                    }
                    Chart(tripController.chartPoints) {
                        LineMark(x: .value("Date", $0.date), y: .value("Distance", $0.distance))
                        PointMark(x: .value("Date", $0.date), y: .value("Distance", $0.distance))
                    }
                    .frame(height: 300)
                    .padding(.vertical)
                }
            }
            
            Section {
                HStack {
                    Text("Three latest trips")
                    Spacer()
                }
                
                ForEach(tripController.threeLatestTrips, id: \.id) { trip in
                    NavigationLink {
                        DetailedTripView(trip: trip)
                    } label: {
                        TripTileView(trip: trip)
                    }
                }
            }
        }
        .navigationTitle("🏠 Home")
        .onAppear {
            if let user = userController.connectedUser {
                tripController.homeAppears(for: user)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(TripController())
                .environmentObject(UserController())
        }
    }
}
