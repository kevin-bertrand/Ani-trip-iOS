//
//  ButtonWithIcon.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct ButtonWithIcon: View {
    var action: () -> Void
    var title: String
    var icon: String?
    
    var body: some View {
        Button(action: action) {
            ZStack {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                if let icon = icon {
                    HStack {
                        Spacer()
                        Image(systemName: icon)
                            .padding(.horizontal)
                            .font(.title2)
                    }
                }
            }.padding()
        }.foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(25)
    }
}

struct ButtonWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithIcon(action: {}, title: "Test", icon: "chevron.right")
    }
}
