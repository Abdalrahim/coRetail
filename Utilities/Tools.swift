
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
    
    static func typeOfIndustry(type: Int ) -> String {
        enum typeInt: Int {
            case retail = 0
            case cars = 1
            case nonProfit = 2
            case health = 3
            case beauty = 4
            case media = 5
            case jewels = 6
            case art = 7
            case tech = 8
            case furniture = 9
            
        }
        
        switch typeInt(rawValue: type)! {
            
        case .retail:
            return "Retail & Fashion"
        case .cars:
            return "Cars & Automotive"
        case .nonProfit:
            return "Non-Profit"
        case .health:
            return "Health & Fitness"
        case .beauty:
            return "Beauty And Cosmetics"
        case .media:
            return "Media & Entertainment"
        case .jewels:
            return "Accessories & Jewels"
        case .art:
            return "Art & Exhibition"
        case .tech:
            return "Technology"
        case.furniture:
            return "Furniture & interior"
            
        }
    }
    
    
    static func avPrice(val : Int) -> String {
        switch val {
        case 0:
            return "$"
        case 1:
            return "$$"
        case 2:
            return "$$$"
        case 3:
            return "$$$$"
        default:
            return "$"
        }
    }
    
    static func generateFileNameByDateAndTime() -> String {
        let formater  = DateFormatter()
        let numberFormater = NumberFormatter()
        numberFormater.locale = .init(identifier: "En")
        formater.dateFormat = "ddMMyyyyhhmmss"
        if let final = numberFormater.number(from: "\(formater.string(from: Date()))"){
            return "\(final)_\(UUID().uuidString)"
        }
        return UUID().uuidString
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
