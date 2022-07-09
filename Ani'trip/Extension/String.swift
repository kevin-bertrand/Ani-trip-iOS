//
//  String.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 09/07/2022.
//

import Foundation

extension String {
    var toDate: Date? {
        ISO8601DateFormatter().date(from: self)
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
