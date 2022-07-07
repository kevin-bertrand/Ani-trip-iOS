//
//  TextFieldWithIcon.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct TextFieldWithIcon: View {
    let icon: String?
    let placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String
    @State private var showPassword = false
    
    
    var body: some View {
        HStack(spacing: 0) {
            if let icon = icon,
               let image = Image(systemName: icon) {
                image
                    .padding()
                    .foregroundColor(.accentColor)
            }
            
            Group {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .autocorrectionDisabled(keyboardType == .default ? false : true)
                            .autocapitalization(keyboardType == .default ? .sentences : .none)
                    }
                }.padding()
                    .keyboardType(keyboardType)

                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        if showPassword {
                            Image(systemName: "eye.slash")
                        } else {
                            Image(systemName: "eye")
                        }
                    }.padding()
                }
            }.background(.white)
        }
        .background(Color("ButtonIconBackground"))
        .cornerRadius(25)
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(style: .init(lineWidth: 1))
        }
    }
}

struct TextFieldWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithIcon(icon: "gear", placeholder: "Login", isSecure: true, keyboardType: .default, text: .constant(""))
    }
}
