//
//  LoadingVIew.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct LoadingVIew: View {
    let textToDisplay: String
    
    var body: some View {
        VStack {
            SpinnerView()
            Text(textToDisplay)
                .padding(50)
                .font(.title)
                .bold()
        }
    }
}

struct LoadingVIew_Previews: PreviewProvider {
    static var previews: some View {
        LoadingVIew(textToDisplay: "")
    }
}
