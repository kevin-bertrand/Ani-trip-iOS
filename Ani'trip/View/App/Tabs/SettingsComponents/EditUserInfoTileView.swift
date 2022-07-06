//
//  EditUserInfoTileView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 05/07/2022.
//

import SwiftUI

struct EditUserInfoTileView: View {
    @Binding var text: String
    let name: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            TextField(name, text: $text)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboardType)
        }
    }
}

struct EditUserInfoTileView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserInfoTileView(text: .constant("test"), name: "test")
    }
}
