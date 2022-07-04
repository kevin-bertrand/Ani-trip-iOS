//
//  LoginView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberEmail: Bool = false
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical)
            
            Spacer()
            
            TextFieldWithIcon(icon: "person.fill", placeholder: "Email", keyboardType: .emailAddress, text: $email)
            
            HStack {
                Spacer()
                Text("Save email")
                    .foregroundColor(Color.gray)
                Button {
                    rememberEmail.toggle()
                } label: {
                    if rememberEmail {
                        Image(systemName: "checkmark.square")
                    } else {
                        Image(systemName: "square")
                    }
                }
            }.padding(.bottom)
            
            TextFieldWithIcon(icon: "lock", placeholder: "Password", isSecure: true, text: $password)
            
            HStack {
                Spacer()
                Button {
                    // TODO: Show forget password sheet
                } label: {
                    Text("Forget password?")
                }
            }
            
            Spacer()
            
            ButtonWithIcon(action: {
                // TODO: Perform login
            }, title: "LOGIN")
            .padding(.vertical)
            
            HStack {
                Text("No account?")
                Button {
                    // TODO: Show new account page
                } label: {
                    Text("Ask one")
                }
            }.font(.callout)
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
