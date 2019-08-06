//
//  Brand.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//


class Brand {
    
    var id: String
    var ownerId: String
    var name: String
    var logoImage : String
    var coverImage : String
    var description: String
    
    
    var type : String
    
    var country : String
    var city : String
    
    var avgPrice : String
    var avgPriceInt : Int?
    
    var founded : Int
    
    var product: [Product]?
    var docmnt: [String : Any]
    
    init(Id: String, OwnerId : String, Name: String, Logo : String, Cover: String, Desc: String, Type: Int, Country: String, City: String, AvgPrice: Int, Founded : Int) {
        self.id = Id
        self.ownerId = OwnerId
        self.name = Name
        self.logoImage = Logo
        self.coverImage = Cover
        self.description = Desc
        
        
        self.type = Tools.typeOfIndustry(type: Type)
        
        self.country = Country
        self.city = City
        
        self.avgPrice = Tools.avPrice(val: AvgPrice)
        self.avgPriceInt = AvgPrice
        
        self.founded = Founded
        
        self.docmnt = [
            "brandId" : Id,
            "ownerId" : OwnerId,
            "name": Name,
            "avgPrice": AvgPrice,
            "logoImage": Logo,
            "coverImage": Cover,
            "description": Desc,
            "country": Country,
            "city": City,
            "type": Type,
            "founded" : Founded
        ]
    }
    
    init(doc : [String : Any]) {
        
        self.id = doc["brandId"] as! String
        self.ownerId = doc["ownerId"] as! String
        self.name = doc["name"] as! String
        
        self.avgPrice = Tools.avPrice(val: doc["avgPrice"] as! Int)
        
        self.logoImage = doc["logoImage"] as! String
        self.coverImage = doc["coverImage"] as! String
        self.description = doc["description"] as! String
        self.country = doc["country"] as! String
        self.city = doc["city"] as! String
        
        self.type = Tools.typeOfIndustry(type: doc["type"] as! Int)
        
        self.founded = doc["founded"] as! Int
        
        self.docmnt = doc
    }
    
}
