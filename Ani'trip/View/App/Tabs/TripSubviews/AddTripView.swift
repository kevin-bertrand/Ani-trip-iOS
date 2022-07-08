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
                VStack(alignment: .leading) {
                    Text("Starting address")
                        .font(.callout)
                        .foregroundColor(.gray)
                    HStack {
                        TextField("Number", text: $tripController.newTrip.startingAddress.streetNumber)
                        TextField("Type", text: $tripController.newTrip.startingAddress.roadType)
                    }
                    TextField("Street name", text: $tripController.newTrip.startingAddress.roadName)
                    TextField("Complement", text: $tripController.newTrip.startingAddress.complement)
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
                        TextField("Number", text: $tripController.newTrip.endingAddress.streetNumber)
                        TextField("Type", text: $tripController.newTrip.endingAddress.roadType)
                    }
                    TextField("Street name", text: $tripController.newTrip.endingAddress.roadName)
                    TextField("Complement", text: $tripController.newTrip.endingAddress.complement)
                    HStack {
                        TextField("Zip code", text: $tripController.newTrip.endingAddress.zipCode)
                            .frame(width: 75)
                        TextField("City", text: $tripController.newTrip.endingAddress.city)
                    }
                    TextField("Country", text: $tripController.newTrip.endingAddress.country)
                }
            }
            
            Section(header: Text("Trip information")) {
                DatePicker("Date", selection: $tripController.newTrip.date)
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
                HStack {
                    Text("Adding a mission")
                        .onTapGesture {
                            self.tripController.newTrip.missions.append("")
                            self.numberOfMissions.append(numberOfMissions.count)
                        }
                        .foregroundColor(.accentColor)
                        .bold()
                }
                List {
                    ForEach(numberOfMissions, id:\.self) { index in
                         TextField("Missions", text: Binding(
                           get: { return tripController.newTrip.missions[index] },
                           set: { (newValue) in return self.tripController.newTrip.missions[index] = newValue}
                         ))
                    }.onDelete { index in
                        self.tripController.newTrip.missions.remove(atOffsets: index)
                        self.numberOfMissions = self.numberOfMissions.dropLast(1)
                    }
                }
            }
            
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
