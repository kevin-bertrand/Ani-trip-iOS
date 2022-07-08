//
//  AddressToUpdateTileView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 08/07/2022.
//

import SwiftUI

struct AddressToUpdateTileView: View {
    @Binding var address: Address
    let tileTitle: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let tileTitle = tileTitle {
                Text(tileTitle)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            HStack {
                TextField("Number", text: $address.streetNumber)
                TextField("Type", text: $address.roadType)
            }
            TextField("Street name", text: $address.roadName)
            TextField("Complement", text: $address.complement)
            HStack {
                TextField("Zip code", text: $address.zipCode)
                    .frame(width: 75)
                TextField("City", text: $address.city)
            }
            TextField("Country", text: $address.country)
        }
    }
}

struct AddressToUpdateTileView_Previews: PreviewProvider {
    static var previews: some View {
        AddressToUpdateTileView(address: .constant(Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "")), tileTitle: "Address")
    }
}
