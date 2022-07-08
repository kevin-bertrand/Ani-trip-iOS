//
//  Double.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 08/07/2022.
//

import Foundation

extension Double {
    var twoDigitPrecision: String {
        return String(format: "%.2f", self)
    }
}
