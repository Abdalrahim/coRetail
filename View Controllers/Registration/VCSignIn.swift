//
//  VCSignIn.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase
import UIKit

class VCSignIn: VCBase {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        self.sign()
    }
    
    @IBAction func signUp(_ sender: Any) {
        let vc = registrationBord.instantiateViewController(withIdentifier: "VCSignUP") as! VCSignUP
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sign() {
        if let email = self.tfEmail.text?.trimmingCharacters(in: .whitespaces),
            let pass = self.tfPassword.text?.trimmingCharacters(in: .whitespaces) {
            Tools.showHUD(viewController: self)
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (result, errr) in
                Tools.dismissHUD(viewController: self)
                if let eror = errr {
                    Logger.error(tag: "signIn", message: eror.localizedDescription)
                    self.present(Tools.alertWithOk(message: eror.localizedDescription), animated: true, completion: nil)
                } else if let fbUser = result?.user {
                    Logger.normal(tag: "signIn", message: fbUser.email ?? "no email??")
                    UserDefaults.standard.set(fbUser.uid, forKey: "uid")
                    UserDefaults.standard.set(fbUser.email, forKey: "email")
                    UserDefaults.standard.set(fbUser.phoneNumber, forKey: "phone")
                    UserDefaults.standard.set(fbUser.displayName, forKey: "name")
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
