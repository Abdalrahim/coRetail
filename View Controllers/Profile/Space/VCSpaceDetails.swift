//
//  VCSpaceDetails.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 05/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCSpaceDetails: VCBase {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var size: UITextField!
    
    @IBOutlet weak var sizeStepper: UIStepper!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var street: UITextField!
    
    @IBAction func stepSize(_ sender: Any) {
        let send = sender as! UIStepper
        self.size.text = "\(Int(send.value))"
        self.sizeNum = Int(send.value)
    }
    
    @IBAction func next(_ sender: Any) {
        self.detail = [
            "name" : self.name.text ?? "",
            "description" : self.desc.text ?? "",
            "street" : self.street.text ?? "",
            "city" : self.city.text ?? "",
            "country" : self.country.text ?? "",
            "size" : self.sizeNum
        ]
        
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSpaceImages") as! VCSpaceImages
        vc.spacedetail = self.spacedetail
        vc.spacedetail.merge(self.detail) { (_, new) in new }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var spacedetail : [String : Any] = [:]
    var detail : [String : Any] = [:]
    
    var sizeNum = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
