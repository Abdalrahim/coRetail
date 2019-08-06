//
//  VCBrandProducts.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 01/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class VCBrandProducts: VCBase {
    
    var initBrand : Brand?
    var products : [Product] = []
    
    @IBOutlet weak var productsCollection: UICollectionView!
    
    @IBAction func newProduct(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCNewProduct") as! VCNewProduct
        vc.initBrand = self.initBrand
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backToBrands", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let brand = self.initBrand else {
            return
        }
        
        db.collection("brands").document(brand.id).addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let productsArr = querySnapshot?.data()?["products"] as? [[String : Any]] {
                    for product in productsArr {
                        let prdct = Product(doc: product)
                        self.products.append(prdct)
                    }
                    self.productsCollection.reloadData()
                    
                } else {
                    print("no products")
                }
            }
        })
    }
    
    
    
}

extension VCBrandProducts : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        let product = self.products[indexPath.row]
        cell.product = product
        
        if let image = URL(string: product.images.first ?? "") {
            cell.productImage.sd_setImage(with: image, completed: nil)
        }
        
        return cell
        
    }
    
    
}

extension VCBrandProducts : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension VCBrandProducts : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width/3, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
