//
//  VCSpaceType.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 05/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCSpaceType: VCBase {
    
    var options : [[Int : Bool]] = [
        [
            0 : false,
            1 : false,
            2 : false,
            3 : false
        ],
        [
            0 : false,
            1 : false,
            2 : false,
            3 : false,
            4 : false,
            5 : false,
            6 : false,
            7 : false,
            8 : false,
            9 : false
        ]
    ]
    
    let optionTitles : [String] = [
        "Entire store",
        "Space in shared store",
        "kiosk",
        "Booth"
    ]
    
    let optionSubtitles : [String] = [
        "Invite brand to rent one of your listing spaces.",
        "Shelves, Rails, Tables, Windows in a shared store",
        "Empty spaces with high traffic you can build.",
        "Empty spaces are Available For limited time"
    ]
    
    @IBAction func next(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSpaceDetails") as! VCSpaceDetails
        vc.options = self.options
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension VCSpaceType : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "You want to rent.."
        } else {
            return "Suitable for which industries?"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! OptionCheck
        
        guard let option = self.options[indexPath.section][indexPath.row] else {
            return cell
        }
        
        if option {
            cell.checkBUtton.setImage(UIImage(named: "Check"), for: .normal)
        } else {
            cell.checkBUtton.setImage(UIImage(named: "Oval"), for: .normal)
        }
        
        if indexPath.section == 0 {
            cell.optionSubtitle.isHidden = false
            cell.optionTitle.text = self.optionTitles[indexPath.row]
            cell.optionSubtitle.text = self.optionSubtitles[indexPath.row]
            
        } else {
            cell.optionTitle.text = Tools.typeOfIndustry(type: indexPath.row)
            cell.optionSubtitle.isHidden = true
        }
        
        return cell
    }
    
}

extension VCSpaceType : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = self.options[indexPath.section][indexPath.row] else { return }
        if indexPath.section == 0 {
            for i in 0..<4 {
                self.options[0].updateValue(false, forKey: i)
            }
        }
        
        if option,
            indexPath.section != 0 {
            self.options[indexPath.section].updateValue(false, forKey: indexPath.row)
            
        } else {
            self.options[indexPath.section].updateValue(true, forKey: indexPath.row)
        }
        
        tableView.reloadData()
        
    }
}
