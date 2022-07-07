//
//  ProfilView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import MapKit
import SwiftUI

struct ProfilView: View {
    @EnvironmentObject var userController: UserController
    let user: User
    
    var body: some View {
        Form {
            if let user = user {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("\(user.firstname) \(user.lastname)")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                        }
                        
                        Spacer()
                    }
                }.listRowBackground(EmptyView())
                
                Section(header: Text("Address")) {
                    AddressTileView(region: $userController.userCoordinate, address: user.address, marker: userController.userPin)
                }
                
                Section(header: Text("Contact informations")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(user.email)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        Text(user.phoneNumber)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Missions")) {
                    Text(user.missions.joined(separator: ", "))
                }
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(user: User(id: UUID(), firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, address: Address(roadName: "", roadType: "", streetNumber: "", zipCode: "", city: "", country: ""), token: ""))
    }
}
