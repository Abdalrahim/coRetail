//
//  VCSelectBrand.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 07/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCSelectBrand: VCBase {
    
    var brands : [Brand] = []
    
    var initSpace : Space?
    
    @IBOutlet weak var brandTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let brandsArr = querySnapshot?.data()?["brands"] as? [DocumentReference] {
                    var brandArr : [Brand] = []
                    
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
                                    brandArr.append(brand)
                                    self.brands = brandArr
                                    self.brandTable.reloadData()
                                }
                            }
                        })
                    }
                } else {
                    print("no brands")
                }
            }
        })
        
    }
    
    
}

extension VCSelectBrand : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! OptionCheck
        let brand = self.brands[indexPath.row]
        
        cell.checkBUtton.isHidden = true
        cell.optionSubtitle.text = "(\(brand.product?.count ?? 0) Products)"
        cell.optionTitle.text = brand.name
        
        return cell
    }
    
    
}

extension VCSelectBrand : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brand = self.brands[indexPath.row]
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSelectDate") as! VCSelectDate
        vc.initSpace = self.initSpace
        vc.initBrand = brand
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
