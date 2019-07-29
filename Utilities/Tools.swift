
//
//  Tools.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 24/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import MBProgressHUD

class Tools {
    
    static func alertWithOk(message: String) -> UIAlertController{
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .default)
        
        alert.view.tintColor = #colorLiteral(red: 0.4313279986, green: 0.3399124146, blue: 0.7549108863, alpha: 1)
        alert.addAction(cancelAction)
        return alert
    }
    
    class func showHUD(viewController: UIViewController) {
        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
        hud.contentColor = #colorLiteral(red: 0.4313279986, green: 0.3399124146, blue: 0.7549108863, alpha: 1)
        hud.animationType = .zoomIn
    }
    
    class func dismissHUD(viewController: UIViewController) {
        MBProgressHUD.hide(for: viewController.view, animated: true)
    }
    
}
