//
//  ProductCell.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 29/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: CustomImage!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var inventory: CustomLabelUI!
    
    var product : Product! {
        didSet {
            
            self.productName.text = product.name
            self.productPrice.text = "\(product.price.rounded()) SR"
            self.inventory.text = "\(product.inventory)"
        }
    }
}
