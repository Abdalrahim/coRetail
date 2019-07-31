//
//  VCDiscover.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 15/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
//import SDW

class VCDiscover: VCBase {
    
    @IBOutlet weak var discoverTable: UITableView!
    
    
    var brands : [Brand] = []
    var products : [Product] = []
    var spaces : [Space] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if UserDefaults.standard.value(forKey: "uid") == nil {
                let vc = self.registrationBord.instantiateViewController(withIdentifier: "RegistrationNC") as! RegistrationNC
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        db.collection("spaces").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Discovered")
                for document in querySnapshot!.documents {
                    let space = Space(doc: document.data())
                    self.spaces.append(space)
                }
                self.discoverTable.reloadData()
            }
        }
    }
    
}

extension VCDiscover : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isBrandUser {
            return self.spaces.count
        } else {
            return self.brands.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isBrandUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath) as! SpaceCell
            cell.space = self.spaces[indexPath.row]
            cell.spaceImage.image = UIImage(named: "place\(indexPath.row + 1)")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "brand", for: indexPath) as! BrandCell
            cell.brand = self.brands[indexPath.row]
            cell.brandLogo.image = UIImage(named: "place\(indexPath.row + 1)")
            cell.productCollection.delegate = self
            cell.productCollection.dataSource = self
            return cell
        }
    }
    
}

extension VCDiscover : UITableViewDelegate {
    
}

extension VCDiscover : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        cell.product = self.products[indexPath.row]
        return cell
    }
    
    
}

extension VCDiscover : UICollectionViewDelegate {
    
}
