//
//  Brand.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//


class Brand {
    
    var id: String
    var name: String
    var logoImage : String
    var coverImage : String
    var description: String
    var type: Int
    var country : String
    var city : String
    var avgPrice : Int
    
    var product: [Product]
    
    
    init(Id: String, Name: String, Logo : String, Cover: String, Desc: String, Type: Int, Country: String, City: String, AvgPrice: Int, Products: [Product]) {
        self.id = Id
        self.name = Name
        self.logoImage = Logo
        self.coverImage = Cover
        self.description = Desc
        self.type = Type
        self.country = Country
        self.city = City
        self.avgPrice = AvgPrice
        self.product = Products
    }
}
