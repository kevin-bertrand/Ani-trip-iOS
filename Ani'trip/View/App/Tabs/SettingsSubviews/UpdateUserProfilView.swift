//
//  UpdateUserProfilView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct UpdateUserProfilView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        Form {
            Section(header: Text("User informations")) {
                EditUserInfoTileView(text: $userController.userToUpdate.firstname, name: "Firstname")
                EditUserInfoTileView(text: $userController.userToUpdate.lastname, name: "Lastname")
            }
            
            Section(header: Text("Address")) {
                HStack {
                    TextField("Type", text: $userController.userToUpdate.address.roadType)
                        .frame(width: 75)
                    TextField("Street name", text: $userController.userToUpdate.address.roadName)
                }
                HStack {
                    TextField("Zip code", text: $userController.userToUpdate.address.zipCode)
                        .frame(width: 75)
                    TextField("City", text: $userController.userToUpdate.address.city)
                }
                TextField("Country", text: $userController.userToUpdate.address.country)
            }
            
            Section(header: Text("Contact")) {
                HStack {
                    Text("Email")
                    Spacer()
                    Text(userController.userToUpdate.email)
                        .foregroundColor(.gray)
                }
                EditUserInfoTileView(text: $userController.userToUpdate.phoneNumber, name: "Phone", keyboardType: .phonePad)
            }
            
            Section(header: Text("Association")) {
                if userController.connectedUser?.position == .admin {
                    Picker("Position", selection: $userController.userToUpdate.position) {
                        ForEach(Position.allCases, id: \.self) { value in
                            Text(value.name)
                                .tag(value)
                        }
                    }
                } else {
                    HStack {
                        Text("Position")
                        Spacer()
                        Text(userController.userToUpdate.position.name)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    Text("Missions")
                    Spacer()
                    Text("\(userController.userToUpdate.missions.joined(separator: ", "))")
                }
            }
            
            Section(header: Text("Security")) {
                EditUserInfoTileView(text: $userController.userToUpdate.password, name: "Password", keyboardType: .phonePad)
                EditUserInfoTileView(text: $userController.userToUpdate.passwordVerification, name: "Password Verification", keyboardType: .phonePad)
            }
        }
        .toolbar {
            Button {
                userController.update()
            } label: {
                Image(systemName: "v.circle")
            }
            
        }
        .alert(isPresented: $userController.showUpdateUserAlert) {
            Alert(title: Text("Success"), message: Text(Notification.AniTrip.successUserUpdate.notificationMessage), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        
    }
}

struct UpdateUserProfilView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserProfilView()
            .environmentObject(UserController())
    }
}
