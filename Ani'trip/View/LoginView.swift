//
//  LoginView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userController: UserController

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical)

            Spacer()
            
            TextFieldWithIcon(icon: "person.fill", placeholder: "Email", keyboardType: .emailAddress, text: $userController.loginEmail)
            
            HStack {
                Spacer()
                Text("Save email")
                    .foregroundColor(Color.gray)
                Button {
                    userController.rememberEmail.toggle()
                } label: {
                    if userController.rememberEmail {
                        Image(systemName: "checkmark.square")
                    } else {
                        Image(systemName: "square")
                    }
                }
            }.padding(.bottom)
            
            TextFieldWithIcon(icon: "lock", placeholder: "Password", isSecure: true, text: $userController.loginPassword)
            
            HStack {
                Spacer()
                Button {
                    userController.showForgetPasswordView = true
                } label: {
                    Text("Forget password?")
                }
            }.padding(.bottom)
            
            Text(userController.errorMessage)
                .bold()
                .foregroundColor(.red)
            
            Spacer()
            
            ButtonWithIcon(action: {
                userController.login()
            }, title: "LOGIN")
            .padding(.vertical)
            
            HStack {
                Text("No account?")
                Button {
                    userController.showNewAccountView = true
                } label: {
                    Text("Ask one")
                }
            }.font(.callout)
        }.padding()
            .sheet(isPresented: $userController.showNewAccountView) {
                NewAccountView()
            }
            .sheet(isPresented: $userController.showForgetPasswordView) {
                ForgetPasswordView()
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserController())
    }
}
