//
//  Ani_tripApp.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

@main
struct Ani_tripApp: App {
    @StateObject private var userController: UserController = UserController()
    @StateObject private var mapController: MapController = MapController()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userController.isLoggedIn {
                    AppView()
                        .environmentObject(mapController)
                } else {
                    LoginView()
                }
            }
            .environmentObject(userController)
            .fullScreenCover(isPresented: $userController.showLoadingInProgressView) {
                LoadingVIew(textToDisplay: "Loading in progres... Please wait!")
            }
            
        }
    }
}
