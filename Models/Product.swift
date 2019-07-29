//
//  Product.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Foundation

class Product {
    
    var name : String
    var price : Double
    var images : [String]
    var description : String
    var inventory : Int
    
    init(Name : String, Price : Double, Images: [String], Desc: String, Inv: Int ) {
        self.name = Name
        self.price = Price
        self.images = Images
        self.description = Desc
        self.inventory = Inv
    }
    
}
