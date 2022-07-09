//
//  NewAccountView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct NewAccountView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical)

            Text("Enter your email and a password. Then click on the button bellow. When the account will be validaded by the administrator, you will receive an email.")
                .font(.callout)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Group {
                TextFieldWithIcon(icon: "person.fill", placeholder: "Email", keyboardType: .emailAddress, text: $userController.newUserEmailField)
                
                TextFieldWithIcon(icon: "lock", placeholder: "Password", isSecure: true, text: $userController.newUserPasswordField)
                
                TextFieldWithIcon(icon: "lock", placeholder: "Password verification", isSecure: true, text: $userController.newUserPasswordVerificationField)
                
                Text(userController.userErrorMessage)
                    .bold()
                    .foregroundColor(.red)
            }.padding()

            Spacer()
            
            ButtonWithIcon(action: {
                userController.createNewAccount()
            }, title: "Ask new account", icon: nil)
        }.padding()
            .alert(isPresented: $userController.showNewAccountAlert) {
                Alert(title: Text("Success"), message: Text(Notification.AniTrip.successfullCreation.notificationMessage), dismissButton: .default(Text("OK"), action: {
                    userController.finishUserCreation()
                }))
            }
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
            .environmentObject(UserController())
    }
}
