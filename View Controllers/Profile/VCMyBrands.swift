//
//  VCMyBrands.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 30/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCMyBrands: VCBase {
    
    @IBOutlet weak var brandTable: UITableView!
    
    
    var brands : [Brand] = []
    var products : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Discovered")
                
                if let brands = querySnapshot?.data()?["brands"] as? DocumentReference {
                    brands.getDocument(completion: { (snapshot, error) in
                        if let err = error {
                            Logger.error(tag: "VCMyBrands: get brandes", message: err.localizedDescription)
                        } else {
                            
                        }
                    })
                }
//                let brand = Brand(doc: document.data())
//                self.brands.append(brand)
                self.brandTable.reloadData()
            }
        }
    }
}

extension VCMyBrands : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brand", for: indexPath) as! BrandCell
        cell.brand = self.brands[indexPath.row]
        cell.brandLogo.image = UIImage(named: "place\(indexPath.row + 1)")
        cell.productCollection.delegate = self
        cell.productCollection.dataSource = self
        return cell
    }
    
}

extension VCMyBrands : UITableViewDelegate {
    
}

extension VCMyBrands : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        cell.product = self.products[indexPath.row]
        return cell
    }
    
    
}

extension VCMyBrands : UICollectionViewDelegate {
    
}
