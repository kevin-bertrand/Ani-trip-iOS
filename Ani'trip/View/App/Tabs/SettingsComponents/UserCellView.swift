//
//  UserCellView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct UserCellView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        HStack(alignment: .center) {
           Image(systemName: "person.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(5)
            if let user = userController.connectedUser {
                Text("\(user.firstname) \(user.lastname)")
                    .font(.title)
                    .padding()
                    .bold()
            }
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView()
            .environmentObject(UserController())
    }
}
