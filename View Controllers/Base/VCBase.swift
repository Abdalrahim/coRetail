//
//  VCBase.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCBase: UIViewController {
    
    let list = ["Welcome 😉","Howdy partner 🤠","Hello there 👋","Hiiii 🙋‍♂️","Well, hello there 😏","Greetings","Sup!😒","Oi Mate 😵", "Hey there?!?!?!", "Have we met before? 🥺", "You know what time it is 🤠🔫"]
    
    let registrationBord : UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    let mainstoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let db = AppDelegate.dbDelegate.db!
    
    func isBrandUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "isBrand")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
            }
        }
    }
}

//MARK:- View delegate
extension VCBase : UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = navigationController else { return false }
        if (navigationController!.viewControllers.count > 1) {
            return true
        }
        return false
    }
}


