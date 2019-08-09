//
//  MainTabBareController.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            //print(item)
            
        }
        
    }
    
}
