//
//  DBDelegate.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 29/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase

class DBDelegate: NSObject {
    
    var db : Firestore?
    
    override init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
}
