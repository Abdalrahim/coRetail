//
//  VCBrand.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 06/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCBrand: VCBase {
    
    var initBrand : Brand?
    
    @IBAction func toBrand(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var logo: CustomImage!
    
    @IBOutlet weak var brandName: UILabel!
    
    @IBOutlet weak var founded: UILabel!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func makeOffer(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSelectSpace") as! VCSelectSpace
        vc.initBrand = self.initBrand
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let brand = self.initBrand {
            
            let logoref = Storage.storage().reference(forURL: brand.logoImage)
            logoref.downloadURL { (url, error) in
                self.logo.sd_setImage(with: url, completed: nil)
            }
            
            let coverref = Storage.storage().reference(forURL: brand.coverImage)
            coverref.downloadURL { (url, error) in
                self.cover.sd_setImage(with: url, completed: nil)
            }
            
            self.brandName.text = brand.name
            
            self.desc.text = brand.description
            
            self.founded.text = "Founded \(brand.founded)"
        }
    }
    
    
}

extension VCBrand : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return initBrand?.product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        let product = self.initBrand!.product![indexPath.row]
        cell.product = product
        
        if let image = URL(string: product.images.first ?? "") {
            cell.productImage.sd_setImage(with: image, completed: nil)
        }
        
        return cell
    }
    
    
}

extension VCBrand : UICollectionViewDelegate {
    
}
