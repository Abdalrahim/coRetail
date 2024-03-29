//
//  VCMySpaces.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 30/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCMySpaces: VCBase {
    
    var spaces : [Space] = []
    
    @IBAction func backToSpaces(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var spacesTable: UITableView!
    
    @IBAction func newSpace(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSpaceType") as! VCSpaceType
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.hidesBottomBarWhenPushed = true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let brandsArr = querySnapshot?.data()?["spaces"] as? [DocumentReference] {
                    var spacesArr : [Space] = []
                    for brandRef in brandsArr {
                        brandRef.getDocument(completion: { (snapshot, error) in
                            if let err = error {
                                Logger.error(tag: "VCMyBrands: get brands", message: err.localizedDescription)
                            } else {
                                if let data = snapshot?.data() {
                                    let space = Space(doc: data)
                                    spacesArr.append(space)
                                    self.spaces = spacesArr
                                    self.spacesTable.reloadData()
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
    
}

extension VCMySpaces : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath) as! SpaceCell
        let space = self.spaces[indexPath.row]
        cell.space = space
        if let image = space.images.first {
            let storageRef = Storage.storage().reference(forURL: image)
            storageRef.downloadURL { (url, error) in
                cell.spaceImage.sd_setImage(with: url, placeholderImage: UIImage(named: "welcomeLogo"))
            }
        }
        return cell
    }
    
    
}

extension VCMySpaces : UITableViewDelegate {
    
}
