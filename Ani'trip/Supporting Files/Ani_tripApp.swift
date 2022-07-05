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
    
    var body: some Scene {
        WindowGroup {
            if userController.isLoggedIn {
                AppView()
                    .environmentObject(userController)
            } else {
                LoginView()
                    .environmentObject(userController)
            }
        }
    }
}
