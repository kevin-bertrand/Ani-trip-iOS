//
//  SettingsView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("User")
                }
                
                Section(header: Text("App settings")) {
                    Toggle(isOn: .constant(false)) {
                        Text("Set automatic theme")
                    }
                    
                    Toggle(isOn: .constant(false)) {
                        Text("Use dark mode")
                    }
                }
                
                Section {
                    Button {
                        userController.disconnect()
                    } label: {
                        Text("Disconnect")
                            .bold()
                            .foregroundColor(.red)
                    }

                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserController())
    }
}
