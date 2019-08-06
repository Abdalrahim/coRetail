//
//  VCBrandDetails.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 31/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase
import UIKit

class VCBrandDetails: VCBase {
    
    @IBOutlet weak var avgIndicator: UILabel!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var industry: UITextField!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var founded: UITextField!
    
    @IBOutlet weak var avgPriceSlider: UISlider!
    
    
    @IBAction func next(_ sender: Any) {
        let brand = Brand(Id: "",
                          OwnerId: UserDefaults.standard.string(forKey: "uid")!,
                          Name: self.name.text ?? "",
                          Logo: "", Cover: "",
                          Desc: self.desc.text,
                          Type: self.type,
                          Country: self.country.text ?? "",
                          City: self.city.text ?? "",
                          AvgPrice: Int(self.avgPriceSlider.value),
                          Founded : self.foundedYear)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCBrandImages") as! VCBrandImages
        vc.initBrand = brand
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func avgPriceSlider(_ sender: Any) {
        self.avgIndicator.text = "\(Tools.avPrice(val: Int(self.avgPriceSlider.value)))"
    }
    
    
    let years : [Int] = Array(1800..<2019)
    
    let industryTypes : [Int] = Array(0..<9)
    let datePicker = UIPickerView()
    let industryPicker = UIPickerView()
    
    var type = 0
    var foundedYear = 2019
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.dataSource = self
        self.datePicker.delegate = self
        self.founded.inputView = self.datePicker
        
        self.industryPicker.dataSource = self
        self.industryPicker.delegate = self
        self.industry.inputView = self.industryPicker
    }
    
}

extension VCBrandDetails : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.industryPicker {
            return industryTypes.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.industryPicker {
            let industryTypes = Tools.typeOfIndustry(type: self.industryTypes[row]) 
            return industryTypes
        } else {
            let year = self.years[row]
            return "\(year)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.industryPicker {
            let industry = self.industryTypes[row]
            let industryTypes = Tools.typeOfIndustry(type: industry)
            self.type = industry
            self.industry.text = industryTypes
        } else {
            let year = self.years[row]
            self.foundedYear = year
            self.founded.text = "\(year)"
        }
    }
    
}

extension VCBrandDetails: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
