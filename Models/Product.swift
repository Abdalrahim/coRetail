//
//  Product.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Foundation

class Product {
    
    var id : String
    var name : String
    var price : Double
    var images : [String]
    var description : String
    var inventory : Int
    
    var docmnt : [String : Any]
    
    init(Id : String, Name : String, Price : Double, Images: [String], Desc: String, Inv: Int ) {
        self.id = Id
        self.name = Name
        self.price = Price
        self.images = Images
        self.description = Desc
        self.inventory = Inv
        
        self.docmnt = [
            "id" : Id,
            "name" : Name,
            "description" : Desc,
            "price" : Price,
            "images" : Images,
            "inventory": Inv
        ]
    }
    
    init(doc : [String : Any]) {
        
        self.id = doc["id"] as! String
        self.name = doc["name"] as! String
        self.description = doc["description"] as! String
        self.price = doc["price"] as! Double
        self.images = doc["images"] as! [String]
        self.inventory = doc["inventory"] as! Int
        
        self.docmnt = doc
    }
    
}
