//
//  VCProfile.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCProfile: VCBase {
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var profileImage: CustomImage!
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            self.username.text = user.email
        }
    }
    
}

extension VCProfile : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = {
            if indexPath.row == 0 {
                return "My Brands"
            } else if indexPath.row == 1 {
                return "My Spaces"
            } else {
                cell.textLabel?.textColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
                return "Log out"
            }
        }()
        cell.textLabel?.textColor = #colorLiteral(red: 0.122172378, green: 0.01825772598, blue: 0.3603883386, alpha: 1)
        
        return cell
    }
    
    
}

extension VCProfile : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = UIViewController()
        
        switch indexPath.row {
        case 0:
            vc = mainstoryboard.instantiateViewController(withIdentifier: "VCMyBrands") as! VCMyBrands
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            vc = mainstoryboard.instantiateViewController(withIdentifier: "VCMySpaces") as! VCMySpaces
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            if UserDefaults.standard.value(forKey: "uid") != nil {
                do {
                    try Auth.auth().signOut()
                } catch let err {
                    print(err.localizedDescription)
                }
                UserDefaults.standard.removeObject(forKey: "uid")
                UserDefaults.standard.removeObject(forKey:"email")
                UserDefaults.standard.removeObject(forKey: "phone")
                UserDefaults.standard.removeObject(forKey: "name")
                
            }
            
        default:
            print(indexPath.row)
        }
        
        
        
    }
}
