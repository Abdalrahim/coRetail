//
//  Message.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 07/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase

class Message {
    
    
    var brandId : String
    var spaceId : String
    
    var senderName : String
    var senderId : String
    var reqId : String
    
    var recieverName : String
    var recieverId : String
    
    var textMessages : [TextMessage]?
    
    var message : String
    
    var type: Int
    var status : Int
    
    var price : Double
    
    var messageDate : Timestamp
    var startDate : Timestamp?
    var endDate : Timestamp?
    
    let doc : [String : Any]
    
    init (doc : [String : Any]) {
        self.brandId = doc["brandId"] as! String
        self.spaceId = doc["spaceId"] as! String
        
        self.senderName = doc["senderName"] as! String
        self.senderId = doc["senderId"] as! String
        
        self.reqId = doc["reqId"] as! String
        
        self.recieverName = doc["recieverName"] as! String
        self.recieverId = doc["recieverId"] as! String
        
        self.message = doc["message"] as! String
        
        self.price = doc["price"] as! Double
        
        self.type = doc["type"] as! Int
        self.status = doc["status"] as! Int
        
        self.messageDate = doc["messageDate"] as! Timestamp
        
        self.startDate = doc["startDate"] as? Timestamp
        self.endDate = doc["endDate"] as? Timestamp
        
        self.doc = doc
    }
}
