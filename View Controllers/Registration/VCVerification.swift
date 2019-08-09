//
//  VCVerification.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 24/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCVerification: VCBase {
    
    var user: User?
    
    //let db = Firestore.firestore()
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var tfVerification: UITextField!
    
    @IBAction func resend(_ sender: Any) {
        if let phone = self.user?.phone {
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    Logger.error(tag: "PhoneAuthProvider", message: error.localizedDescription)
                    return
                } else {
                    guard let verId = verificationID else { return }
                    weak var weakself = self
                    weakself?.present(Tools.alertWithOk(message: "An SMS with a 6-digit confirmation code has been resent to \(phone)"), animated: true, completion: nil)
                    UserDefaults.standard.set(verId, forKey: "authVerificationID")
                }
            }
        }
        
    }
    
    let verificationID : String = {
        return UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
    }()
    
    @IBAction func verify(_ sender: Any) {
        createUser()
    }
    
    func createUser() {
        
        if let verification = self.tfVerification.text?.trimmingCharacters(in: .whitespaces),
            let user = self.user,
            let pass = self.user?.password {
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verification)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error1) in
                if let err = error1 {
                    Logger.error(tag: "signInAndRetrieveData", message: err.localizedDescription)
                    self.present(Tools.alertWithOk(message: err.localizedDescription), animated: true, completion: nil)
                } else {
                    guard let fbUser = authResult?.user else { return }
                    
                    fbUser.updateEmail(to: user.email, completion: { (error2) in
                        if let eror = error2 {
                            Logger.error(tag: "updateEmail", message: eror.localizedDescription)
                            self.present(Tools.alertWithOk(message: eror.localizedDescription), animated: true, completion: nil)
                        } else {
                             Logger.normal(tag: "updateEmail", message: "")
                        }
                    })
                    
                    fbUser.updatePassword(to: pass, completion: { (error3) in
                        if let eror = error3 {
                            Logger.error(tag: "updatePassword", message: eror.localizedDescription)
                            self.present(Tools.alertWithOk(message: eror.localizedDescription), animated: true, completion: nil)
                        } else {
                             Logger.normal(tag: "updatePassword", message: "")
                        }
                    })
                    
                    Logger.normal(tag: "New User", message: fbUser)
                    
                    UserDefaults.standard.set(fbUser.uid, forKey: "uid")
                    UserDefaults.standard.set(user.isbrand, forKey: "isBrand")
                    UserDefaults.standard.set(user.email, forKey: "email")
                    UserDefaults.standard.set(user.phone, forKey: "phone")
                    UserDefaults.standard.set(user.name, forKey: "name")
                    
                    Logger.normal(tag: "signInAndRetrieveData", message: fbUser)
                    
                    self.db.collection("users").document(fbUser.uid).updateData([
                        "id": fbUser.uid,
                        "name": user.name,
                        "email": user.email,
                        "phone": user.phone,
                        "isBrand": user.isbrand
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let phone = user?.phone {
            self.headerText.text = "An SMS with a 6-digit confirmation code has been sent to \(phone)"
        }
        
    }
    
}
