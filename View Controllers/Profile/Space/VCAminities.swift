//
//  VCAminities.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 05/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCAminities: VCBase {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var aminities : [Int] = []
    
    var spacedetail : [String : Any] = [:]
    
    @IBAction func next(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCPriceNDate") as! VCPriceNDate
        vc.spacedetail = self.spacedetail
        vc.spacedetail["amenities"] = aminities
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VCAminities : UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "What amenities do you offer?"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! OptionCheck
        
        cell.optionTitle.text = Tools.aminities(type: indexPath.row)
        cell.optionSubtitle.isHidden = true
        
        if aminities.contains(indexPath.row) {
            cell.checkBUtton.setImage(UIImage(named: "Check"), for: .normal)
        } else {
            cell.checkBUtton.setImage(UIImage(named: "Oval"), for: .normal)
        }
        return cell
    }
    
    
}

extension VCAminities : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if aminities.contains(indexPath.row) {
            for i in self.aminities.enumerated() {
                if i.element == indexPath.row {
                    self.aminities.remove(at: i.offset)
                }
            }
        } else {
            self.aminities.append(indexPath.row)
        }
        tableView.reloadData()
    }
}
