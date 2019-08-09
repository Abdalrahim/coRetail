//
//  TextMessage.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 07/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase

class TextMessage {
    
    var text : String
    var time : Timestamp
    var senderId : String
    
    init(doc: [String : Any]) {
        self.text = doc["text"] as! String
        self.time = doc["time"] as! Timestamp
        self.senderId = doc["senderId"] as! String
    }
}
