//
//  VCProfile.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCProfile: VCBase {
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var profileImage: CustomImage!
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    @IBAction func myBrands(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCMyBrands") as! VCMyBrands
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mySpaces(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCMySpaces") as! VCMySpaces
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
