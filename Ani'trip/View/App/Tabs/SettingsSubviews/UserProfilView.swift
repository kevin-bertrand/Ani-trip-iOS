//
//  UserProfilView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import CoreLocation
import MapKit
import SwiftUI

struct UserProfilView: View {
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var mapController: MapController
    
    var body: some View {
        VStack {
            if let user = userController.connectedUser {
                ProfilView(user: user)
            }
        }
        .toolbar {
            NavigationLink {
                UpdateUserProfilView()
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
    }
}

struct UserProfilView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilView()
            .environmentObject(UserController())
            .environmentObject(MapController())
    }
}
