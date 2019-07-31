//
//  BrandCell.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 29/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class BrandCell: UITableViewCell {
    
    @IBOutlet weak var brandLogo: CustomImage!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var brandType: UILabel!
    
    @IBOutlet weak var brandCity: UILabel!
    
    @IBOutlet weak var priceRange: UILabel!
    
    @IBOutlet weak var viewBrand: CustomButton!
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var brand : Brand! {
        didSet {
            
            self.name.text = brand.name
            self.brandType.text = brand.type
            self.brandCity.text = brand.city
            self.priceRange.text = brand.avgPrice
            
        }
    }
    
}
