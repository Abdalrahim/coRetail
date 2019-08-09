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
    
    var storeType : Int = 0
    
    var industry : [Int] = []
    
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
        vc.spacedetail["suitable"] = self.industry
        vc.spacedetail["type"] = self.storeType
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
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == self.storeType {
                cell.checkBUtton.setImage(UIImage(named: "Check"), for: .normal)
            } else {
                cell.checkBUtton.setImage(UIImage(named: "Oval"), for: .normal)
            }
            
            cell.optionSubtitle.isHidden = false
            cell.optionTitle.text = self.optionTitles[indexPath.row]
            cell.optionSubtitle.text = self.optionSubtitles[indexPath.row]
            
        } else {
            
            if industry.contains(indexPath.row) {
                cell.checkBUtton.setImage(UIImage(named: "Check"), for: .normal)
            } else {
                cell.checkBUtton.setImage(UIImage(named: "Oval"), for: .normal)
            }
            
            cell.optionTitle.text = Tools.typeOfIndustry(type: indexPath.row)
            cell.optionSubtitle.isHidden = true
        }
        
        return cell
    }
    
}

extension VCSpaceType : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.storeType = indexPath.row
        } else {
            if industry.contains(indexPath.row) {
                for i in self.industry.enumerated() {
                    if i.element == indexPath.row {
                        self.industry.remove(at: i.offset)
                    }
                }
            } else {
                self.industry.append(indexPath.row)
            }
        }
        
        tableView.reloadData()
        
    }
}
