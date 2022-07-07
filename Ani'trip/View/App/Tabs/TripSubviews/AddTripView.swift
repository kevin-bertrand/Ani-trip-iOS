//
//  AddTripView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tripController: TripController
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Starting address")
                        .font(.callout)
                        .foregroundColor(.gray)
                    HStack {
                        TextField("Type", text: $tripController.newTrip.startingAddress.roadType)
                            .frame(width: 75)
                        TextField("Street name", text: $tripController.newTrip.startingAddress.roadName)
                    }
                    HStack {
                        TextField("Zip code", text: $tripController.newTrip.startingAddress.zipCode)
                            .frame(width: 75)
                        TextField("City", text: $tripController.newTrip.startingAddress.city)
                    }
                    TextField("Country", text: $tripController.newTrip.startingAddress.country)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Ending address")
                        .font(.callout)
                        .foregroundColor(.gray)
                    HStack {
                        TextField("Type", text: $tripController.newTrip.endingAddress.roadType)
                            .frame(width: 75)
                        TextField("Street name", text: $tripController.newTrip.endingAddress.roadName)
                    }
                    HStack {
                        TextField("Zip code", text: $tripController.newTrip.endingAddress.zipCode)
                            .frame(width: 75)
                        TextField("City", text: $tripController.newTrip.endingAddress.city)
                    }
                    TextField("Country", text: $tripController.newTrip.endingAddress.country)
                }
            }
            
            Section(header: Text("Trip information")) {
                DatePicker("Start date", selection: $tripController.newTrip.startDate)
                DatePicker("End date", selection: $tripController.newTrip.endDate)
                Toggle("Auto distance calculation", isOn: .constant(false))
                    .disabled(true)
                HStack {
                    Text("Total distance")
                    Spacer()
                    TextField("0", text: $tripController.newTrip.totalDistance)
                        .multilineTextAlignment(.trailing)
                    Text("km")
                }
            }
            
            Section(header: Text("Missions")) {
                Text(tripController.newTrip.missions.joined(separator: ", "))
            }
            
            Section(header: Text("Header")) {
                TextEditor(text: $tripController.newTrip.comment)
            }
        }
        .toolbar {
            Button {
                tripController.addNewTrip()
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .alert(isPresented: $tripController.showSuccessAddingTripAlert) {
            Alert(title: Text("Success"), message: Text(Notification.AniTrip.successAddingTrip.notificationMessage), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .environmentObject(TripController())
    }
}
