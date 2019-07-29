//
//  User.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 24/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//


class User {
    
    var name: String
    var phone: String
    var email: String
    var password: String?
    var isbrand : Bool
    
    init(Name: String, Phone : String, Email: String, Password: String, isBrand: Bool) {
        self.name = Name
        self.phone = Phone
        self.email = Email
        self.password = Password
        self.isbrand = isBrand
    }
}
