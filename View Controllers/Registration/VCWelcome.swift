//
//  VCWelcome.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCWelcome: VCBase {
    
    let singUp = ["Sign up now.. or later?", "Sign up now!","> Sign up here <", "Join us 😎"]
    
    
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBAction func signUpNow(_ sender: Any) {
        let vc = registrationBord.instantiateViewController(withIdentifier: "VCSignUP") as! VCSignUP
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        let vc = registrationBord.instantiateViewController(withIdentifier: "VCSignIn") as! VCSignIn
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.setTitle(self.singUp[Int.random(in: 0..<singUp.count)], for: .normal)
        
    }
}
