//
//  SpaceCell.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 27/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class SpaceCell: UITableViewCell {
    
    @IBOutlet weak var spaceImage: UIImageView!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var size: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    var space : Space! {
        didSet {
            
            self.size.text = "\(space.size) SqM"
            self.city.text = space.city
            self.price.text = "SR \(space.pricePerDay) per day"
            
        }
    }
    
}
