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
    
    @IBAction func newBrand(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCBrandDetails") as! VCBrandDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToBrands(segue:UIStoryboardSegue) { }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let brandsArr = querySnapshot?.data()?["brands"] as? [DocumentReference] {
                    for brandRef in brandsArr {
                        brandRef.getDocument(completion: { (snapshot, error) in
                            if let err = error {
                                Logger.error(tag: "VCMyBrands: get brands", message: err.localizedDescription)
                            } else {
                                if let data = snapshot?.data() {
                                    let brand = Brand(doc: data)
                                    
                                    if let productsArr = snapshot?.data()?["products"] as? [[String : Any]] {
                                        var prdctArr : [Product] = []
                                        for product in productsArr {
                                            let prdct = Product(doc: product)
                                            prdctArr.append(prdct)
                                        }
                                        brand.product = prdctArr
                                    } else {
                                        print("no products in brand")
                                    }
                                    self.brands.append(brand)
                                }
                            }
                            self.brandTable.reloadData()
                        })
                    }
                } else {
                    print("no brands")
                }
            }
        })
    }
    
    @objc func openBrand(sender: UIButton) {
        let brand = self.brands[sender.tag]
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCBrandProducts") as! VCBrandProducts
        vc.initBrand = brand
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCMyBrands : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brand", for: indexPath) as! BrandCell
        let brand = self.brands[indexPath.row]
        cell.brand = brand
        
        let storageRef = Storage.storage().reference(forURL: brand.logoImage)
        storageRef.downloadURL { (url, error) in
            cell.brandLogo.sd_setImage(with: url, placeholderImage: UIImage(named: "welcomeLogo"))
        }
        
        cell.productCollection.tag = indexPath.row
        cell.productCollection.delegate = self
        cell.productCollection.dataSource = self
        
        cell.viewBrand.tag = indexPath.row
        cell.viewBrand.removeTarget(nil, action: nil, for: .allEvents)
        cell.viewBrand.addTarget(self, action: #selector(self.openBrand(sender:)), for: .touchUpInside)
        return cell
    }
    
}

extension VCMyBrands : UITableViewDelegate {
    
}

extension VCMyBrands : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.brands[collectionView.tag].product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        let product = self.brands[collectionView.tag].product![indexPath.row]
        cell.product = product
        
        if let image = URL(string: product.images.first ?? "") {
            cell.productImage.sd_setImage(with: image, completed: nil)
        }
        
        return cell
    }
    
    
}

extension VCMyBrands : UICollectionViewDelegate {
    
}

extension VCMyBrands : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width/2 - 5, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
