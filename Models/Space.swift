//
//  Space.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Foundation
import Firebase

class Space {
    
    var id : String
    var ownerId: String
    var name : String
    var pricePerDay : Double
    var isAvailable : Bool
    var images : [String]
    var description : String
    var location : GeoPoint?
    var country : String
    var city : String
    var street : String
    var aminities : [Int]
    var type : Int
    var suitable : [Int]
    var size : Int
    var availabilityS : Timestamp?
    var availabilityE : Timestamp?
    
    let dcmnt : [String : Any]
    
    init(doc : [String : Any]) {
        self.id = doc["spaceId"] as! String
        self.ownerId = doc["ownerId"] as! String
        self.name = doc["name"] as! String
        self.pricePerDay = doc["pricePerDay"] as! Double
        self.images = doc["images"] as! [String]
        self.description = doc["description"] as! String
        self.location = doc["location"] as? GeoPoint
        self.country = doc["country"] as! String
        self.city = doc["city"] as! String
        self.street = doc["street"] as! String
        self.aminities = doc["amenities"] as! [Int]
        self.type = doc["type"] as! Int
        self.suitable = doc["suitable"] as! [Int]
        self.size = doc["size"] as! Int
        self.isAvailable = doc["isAvailable"] as! Bool
        self.availabilityS = doc["availabilityS"] as? Timestamp
        self.availabilityE = doc["availabilityE"] as? Timestamp
        self.dcmnt = doc
    }
    
}
