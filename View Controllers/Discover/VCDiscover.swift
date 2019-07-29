//
//  VCDiscover.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 15/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCDiscover: VCBase {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if UserDefaults.standard.value(forKey: "uid") == nil {
                let vc = self.registrationBord.instantiateViewController(withIdentifier: "RegistrationNC") as! RegistrationNC
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
//    var angle : CGFloat = 0
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.welcomeTxt.text = ""
//        self.angle = angle + 20
//        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
//            self.welcomeTxt.transform = CGAffineTransform(rotationAngle: self.angle)
//            self.welcomeTxt.text = self.list[.random(in: 0..<self.list.count)]
//        }
//        animator.startAnimation()
//    }
    
    
}

extension VCDiscover : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath) as! SpaceCell
        cell.spaceImage.image = UIImage(named: "place\(indexPath.row + 1)")
        
        return cell
    }
    
    
}

extension VCDiscover : UITableViewDelegate {
    
}
