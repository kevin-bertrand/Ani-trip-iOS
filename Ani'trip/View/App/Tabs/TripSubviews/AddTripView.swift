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
    @EnvironmentObject var userController: UserController
    @State private var numberOfMissions: [Int] = []
    
    var body: some View {
        Form {
            Section {
                AddressToUpdateTileView(address: $tripController.newTrip.startingAddress, tileTitle: "Starting address")
            }
            
            Section {
                AddressToUpdateTileView(address: $tripController.newTrip.endingAddress, tileTitle: "Ending address")
            }
            
            Section(header: Text("Trip information")) {
                DatePicker("Date", selection: $tripController.newTrip.date, displayedComponents: .date)
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
            
            MissionsUpdateTileView(missions: $tripController.newTrip.missions)
            
            Section(header: Text("Comments")) {
                TextEditor(text: $tripController.newTrip.comment)
            }
        }
        .toolbar {
            if let connectedUser = userController.connectedUser {
                Button {
                    tripController.addNewTrip(for: connectedUser)
                } label: {
                    Image(systemName: "v.circle")
                }
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
            .environmentObject(UserController())
    }
}
