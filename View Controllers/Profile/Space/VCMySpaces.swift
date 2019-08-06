//
//  VCMySpaces.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 30/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCMySpaces: VCBase {
    
    var spaces : [Space] = []
    
    @IBAction func newSpace(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSpaceType") as! VCSpaceType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
