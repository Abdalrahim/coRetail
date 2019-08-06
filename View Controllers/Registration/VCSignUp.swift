//
//  VCSignUp.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class VCSignUP: VCBase {
    
    @IBOutlet weak var landlordView: CustomView!
    
    @IBOutlet weak var brandView: CustomView!
    
    var isBrand = true
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func isLandlord(_ sender: Any) {
        self.isBrand = false
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.brandView.layer.borderWidth = 0
            self.landlordView.layer.borderWidth = 3
        }
        animator.startAnimation()
    }
    
    @IBAction func isBrand(_ sender: Any) {
        self.isBrand = true
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.brandView.layer.borderWidth = 3
            self.landlordView.layer.borderWidth = 0
        }
        animator.startAnimation()
    }
    
    @IBAction func continueSignUp(_ sender: Any) {
        self.createUser()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createUser() {
        if let name = self.name.text?.trimmingCharacters(in: .whitespaces),
            let phone = number.text?.trimmingCharacters(in: .whitespaces),
            let passTxt = password.text?.trimmingCharacters(in: .whitespaces),
            let emailTxt = self.email.text?.trimmingCharacters(in: .whitespaces) {
            let user = User.init(Name: name, Phone: phone, Email: emailTxt, Password: passTxt, isBrand: self.isBrand)
            Tools.showHUD(viewController: self)
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                Tools.dismissHUD(viewController: self)
                if let error = error {
                    Logger.error(tag: "verifyPhoneNumber", message: error.localizedDescription)
                    self.present(Tools.alertWithOk(message: error.localizedDescription), animated: true, completion: nil)
                    
                } else {
                    guard let verId = verificationID else { return }
                    UserDefaults.standard.set(verId, forKey: "authVerificationID")
                    
                    let vc = self.registrationBord.instantiateViewController(withIdentifier: "VCVerification") as! VCVerification
                    vc.user = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
