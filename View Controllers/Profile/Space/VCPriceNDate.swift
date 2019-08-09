//
//  VCPriceNDate.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 06/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase
import UIKit

class VCPriceNDate: VCBase {
    
    @IBOutlet weak var PricePerDay: UITextField!
    
    @IBOutlet weak var PricePerWeek: UITextField!
    
    @IBOutlet weak var PricePerMonth: UITextField!
    
    @IBOutlet weak var startingDate: UITextField!
    
    @IBOutlet weak var endingDate: UITextField!
    
    @IBAction func createSpace(_ sender: Any) {
        
        
        if let id = UserDefaults.standard.string(forKey: "uid") {
            var ref: DocumentReference? = nil
            Tools.showHUD(viewController: self)
            let pricePDay = Double(Int(self.PricePerDay.text ?? "0") ?? 0)
            let pricePWeek = Double(Int(self.PricePerWeek.text ?? "0") ?? 0)
            let pricePMonth = Double(Int(self.PricePerMonth.text ?? "0") ?? 0)
            
            self.spacedetail["pricePerDay"] = pricePDay
            self.spacedetail["pricePerWeek"] = pricePWeek
            self.spacedetail["pricePerMonth"] = pricePMonth
            self.spacedetail["ownerId"] = id
            
            ref = db.collection("spaces").addDocument(data: self.spacedetail) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    guard let spaceId = ref?.documentID else {return}
                    let brandref = self.db.collection("spaces").document("\(spaceId)")
                    let userRef = self.db.collection("users").document("\(id)")
                    
                    
                    
                    
                    self.startUploading(spaceId: spaceId) {
                        brandref.updateData([
                            "images": self.imagesName,
                            "spaceId": spaceId
                        ]) { err in
                            if let err = err {
                                print("Error updating info: \(err)")
                            } else {
                                self.performSegue(withIdentifier: "backToSpaces", sender: nil)
                            }
                        }
                    }
                    
                    userRef.setData([
                        "spaces": [brandref]
                    ], merge : true) { err in
                        if let err = err {
                            print("Error updating brands: \(err)")
                        } else {
                            print("Brands successfully updated")
                        }
                    }
                    
                }
            }
        }
        
    }
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var startDate :Timestamp?
    var endDate :Timestamp?
    
    var spacedetail : [String : Any] = [:]
    var images : [UIImage] = []
    var imagesName : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imgs = self.spacedetail["images"] as? [UIImage] {
            self.images = imgs
        }
        self.spacedetail["isAvailable"] = true
        self.spacedetail.removeValue(forKey: "images")
        
        self.createDate()
    }
    
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
    
    func startUploading(spaceId: String ,completion: @escaping FileCompletionBlock) {
        if images.count == 0 {
            completion()
            return;
        }
        
        block = completion
        uploadImage(forIndex: 0, spaceId : spaceId)
    }
    
    func uploadImage(forIndex index:Int, spaceId : String) {
        
        if index < images.count {
            /// Perform uploading
            let productImageSize = CGSize(width: 250, height: 250)
            
            let productRed = Storage.storage().reference().child("Space").child(spaceId).child("\(Tools.generateFileNameByDateAndTime()).jpeg")
            guard let data = images[index].sd_resizedImage(with: productImageSize, scaleMode: .aspectFill)?.jpegData(compressionQuality: 1.0) else {return}
            
            FirFile.shared.upload(data: data, atPath: productRed, block: { (url) in
                /// After successfully uploading call this method again by increment the **index = index + 1**
                print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
                self.imagesName.append(url ?? "")
                self.uploadImage(forIndex: index + 1, spaceId: spaceId)
            })
            return;
        }
        
        if block != nil {
            block!()
        }
    }
    
    func createDate() {
        
        datePicker1.datePickerMode = .date
        datePicker1.minimumDate = Date()
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = self.startDate?.dateValue() ?? Date()
        
        self.startingDate.inputView = datePicker1
        self.endingDate.inputView = datePicker2
        
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDate1))
        toolbar1.setItems([done], animated: true)
        startingDate.inputAccessoryView = toolbar1
        
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        let done2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDate2))
        toolbar2.setItems([done2], animated: true)
        endingDate.inputAccessoryView = toolbar2
    }
    
    @objc func doneDate1() {
        startingDate.text = Tools.getDate(format: "dd-MM-yyyy", date: datePicker1.date)
        self.startDate = Timestamp(date: datePicker1.date)
        datePicker2.minimumDate = self.startDate?.dateValue() ?? Date()
        self.endingDate.becomeFirstResponder()
    }
    
    @objc func doneDate2() {
        endingDate.text = Tools.getDate(format: "dd-MM-yyyy", date: datePicker2.date)
        self.endDate = Timestamp(date: datePicker2.date)
        self.view.endEditing(true)
    }
    
    
}
