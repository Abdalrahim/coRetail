//
//  VCDiscover.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 15/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class VCDiscover: VCBase {
    
    @IBOutlet weak var discoverTable: UITableView!
    
    @IBOutlet weak var isBrandSwitch: UISwitch!
    
    @IBAction func switchView(_ sender: Any) {
        UserDefaults.standard.set(!isBrandUser(), forKey: "isBrand")
        self.getDiscover()
    }
    
    var brands : [Brand] = []
    var spaces : [Space] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if UserDefaults.standard.value(forKey: "uid") == nil {
                let vc = self.registrationBord.instantiateViewController(withIdentifier: "RegistrationNC") as! RegistrationNC
                self.present(vc, animated: true, completion: nil)
            }
        }
        self.isBrandSwitch.setOn(isBrandUser(), animated: true)
        
        getDiscover()
    }
    
    func getDiscover() {
        if isBrandUser() {
            self.db.collection("brands").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var brandArr : [Brand] = []
                    
                    for document in querySnapshot!.documents {
                        let brand = Brand(doc: document.data())
                        if let productsArr = document.data()["products"] as? [[String : Any]] {
                            var prdctArr : [Product] = []
                            for product in productsArr {
                                let prdct = Product(doc: product)
                                prdctArr.append(prdct)
                            }
                            brand.product = prdctArr
                        } else {
                            print("no products in brand")
                        }
                        brandArr.append(brand)
                    }
                    
                    self.brands = brandArr
                    self.discoverTable.reloadData()
                }
            }
        } else {
            self.db.collection("spaces").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                } else {
                    var spaceArr : [Space] = []
                    for document in querySnapshot!.documents {
                        spaceArr.append(Space(doc: document.data()))
                    }
                    self.spaces = spaceArr
                    self.discoverTable.reloadData()
                }
            }
        }
        
    }
    
    @objc func openBrand(sender: UIButton) {
        let brand = self.brands[sender.tag]
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCBrand") as! VCBrand
        vc.initBrand = brand
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCDiscover : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isBrandUser() {
            return self.brands.count
        } else {
            return self.spaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isBrandUser() {
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
            cell.viewBrand .addTarget(self, action: #selector(self.openBrand(sender:)), for: .touchUpInside)
            
            return cell
        } else {
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
    
}


extension VCDiscover : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isBrandUser() {
            let space = self.spaces[indexPath.row]
            let vc = self.mainstoryboard.instantiateViewController(withIdentifier: "VCSpace") as! VCSpace
            vc.initSpace = space
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isBrandUser() {
            return 388
        } else {
            return 304
        }
    }
}

extension VCDiscover : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands[collectionView.tag].product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        let product = brands[collectionView.tag].product![indexPath.row]
        cell.product = product
        if let image = URL(string: product.images.first ?? "") {
            cell.productImage.sd_setImage(with: image, completed: nil)
        }
        return cell
    }
    
    
}

extension VCDiscover : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension VCDiscover : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width/2 - 5, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
