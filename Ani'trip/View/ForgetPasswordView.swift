//
//  ForgetPasswordView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct ForgetPasswordView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical)
            
            Spacer()
            
            TextFieldWithIcon(icon: "person.fill", placeholder: "Email", keyboardType: .emailAddress, text: $userController.forgetPasswordEmail)
            Text(userController.errorMessage)
                .bold()
                .foregroundColor(.red)
            Text("Enter your email and click on the button bellow. An email with a link to create a new password will be send.")
                .font(.callout)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            ButtonWithIcon(action: {
                userController.forgetPassword()
            }, title: "Send new password")
        }.padding()
            .alert(isPresented: $userController.showForgetPasswordAlert) {
                Alert(title: Text("Success"), message: Text(Notification.AniTrip.successRequestForNewPassword.notificationMessage), dismissButton: .default(Text("OK"), action: {
                    userController.finishForgetPasswordRequest()
                }))
            }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
            .environmentObject(UserController())
    }
}
