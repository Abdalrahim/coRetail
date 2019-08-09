//
//  VCSpace.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 06/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class VCSpace: VCBase {
    
    var initSpace : Space?
    
    @IBAction func toSpace(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var size: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var aminitiesStack: UIStackView!
    
    @IBOutlet weak var aminitySample: UILabel!
    
    @IBOutlet weak var spaceImage: UIImageView!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var offerButton: UIView!
    
    @IBAction func makeOffer(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCSelectBrand") as! VCSelectBrand
        vc.initSpace = self.initSpace
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let space = self.initSpace {
            self.size.text = "\(space.size) SqM"
            self.name.text = space.name
            self.type.text = Tools.typeOfIndustry(type: space.type)
            self.price.text = "SR \(space.pricePerDay)"
            self.desc.text = space.description
            for aminity in space.aminities {
                let aminityView = aminitySample
                aminityView?.text = Tools.aminities(type: aminity)
                aminityView?.isHidden = false
                self.aminitiesStack.addArrangedSubview(aminityView!)
            }
            
            if let id = UserDefaults.standard.string(forKey: "uid") {
                if id == space.ownerId || !space.isAvailable {
                    self.offerButton.isHidden = true
                }
            } else {
                self.offerButton.isHidden = true
            }
            
            if let image = space.images.first {
                self.spaceImage.sd_setImage(with: URL(string: image), completed: nil)
            }
        }
    }
}
