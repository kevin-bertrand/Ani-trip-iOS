//
//  VolunteersView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import SwiftUI

struct VolunteersView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        List {
            ForEach(userController.volunteersList, id: \.id) { volunteer in
                NavigationLink {
                    ProfilView(user: volunteer)
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("\(volunteer.firstname) \(volunteer.lastname)")
                                .bold()
                                .font(.title2)
                            Text(volunteer.missions.joined(separator: ", "))
                            if let address = volunteer.address {
                                Text("📍 \(address.city)")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            userController.getVolunteerList()
        }
        .searchable(text: $userController.searchFilter)
        .navigationTitle(Text("👥 Volunteers"))
    }
}

struct VolunteersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VolunteersView()
                .environmentObject(UserController())
        }
    }
}
