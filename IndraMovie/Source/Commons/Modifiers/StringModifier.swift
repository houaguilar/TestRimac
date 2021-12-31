//
//  StringModifier.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 30/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

extension String {
    var isValidUsername: Bool {
        let emailRegEx = "^[a-zA-Z\\_]{4,18}$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let emailRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
