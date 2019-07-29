//
//  Space.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Foundation

class Space {
    
    var id : String
    var name : String
    var price : Double
    var images : [String]
    var description : String
    var location : String
    var country : String
    var city : String
    var street : String
    var aminities : [Int]
    var type : Int
    var suitable : [Int]
    var size : Double
    var availabilityS : Date
    var availabilityE : Date
    
    init(Id: String, Name : String, Price : Double, Images: [String], Desc: String, Location: String, Country: String, City: String, Street : String, Amin : [Int], Type : Int, Suit: [Int], Size: Double, AvailS: Date, AvailE : Date) {
        self.id = Id
        self.name = Name
        self.price = Price
        self.images = Images
        self.description = Desc
        self.location = Desc
        self.country = Country
        self.city = City
        self.street = Street
        self.aminities = Amin
        self.type = Type
        self.suitable = Suit
        self.size = Size
        self.availabilityS = AvailS
        self.availabilityE = AvailE
    }
    
}
