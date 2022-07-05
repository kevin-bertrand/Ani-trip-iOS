//
//  AppView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("My trips")
                .tabItem {
                    Label("My trips", systemImage: "map.fill")
                }
            
            Text("Volunteers")
                .tabItem {
                    Label("Volunteers", systemImage: "person.3.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
