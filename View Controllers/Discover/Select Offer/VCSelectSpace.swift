//
//  VCSelectSpace.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 08/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCSelectSpace: VCBase {
    
    var spaces : [Space] = []
    
    var initBrand : Brand?
    
    @IBOutlet weak var spaceTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let brandsArr = querySnapshot?.data()?["spaces"] as? [DocumentReference] {
                    var spaceArr : [Space] = []
                    
                    for brandRef in brandsArr {
                        brandRef.getDocument(completion: { (snapshot, error) in
                            if let err = error {
                                Logger.error(tag: "VCMyBrands: get brands", message: err.localizedDescription)
                            } else {
                                if let data = snapshot?.data() {
                                    let space = Space(doc: data)
                                    
                                    spaceArr.append(space)
                                    self.spaces = spaceArr
                                    self.spaceTable.reloadData()
                                }
                            }
                        })
                    }
                } else {
                    print("no spaces")
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
}

extension VCSelectSpace : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! OptionCheck
        let space = self.spaces[indexPath.row]
        
        cell.checkBUtton.isHidden = true
        cell.optionSubtitle.isHidden = true
        cell.optionTitle.text = space.name
        
        return cell
    }
    
    
}

extension VCSelectSpace : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let space = self.spaces[indexPath.row]
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSelectDate") as! VCSelectDate
        vc.initSpace = space
        vc.initBrand = initBrand
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
