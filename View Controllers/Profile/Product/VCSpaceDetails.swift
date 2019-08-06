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
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSpaceImages") as! VCSpaceImages
        vc.options = self.options
        vc.detail = self.detail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var options : [[Int : Bool]] = [[:]]
    var detail : [String : Any] = [:]
    
    var sizeNum = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
