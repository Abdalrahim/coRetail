//
//  VCBrandImages.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 31/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class VCBrandImages: VCBase {
    
    @IBOutlet weak var brandName: UILabel!
    
    @IBOutlet weak var founded: UILabel!
    
    @IBOutlet weak var coverImage: CustomImage!
    
    @IBOutlet weak var logoImage: CustomImage!
    
    @IBAction func setCover(_ sender: Any) {
        self.isCover = true
        takePhoto()
    }
    
    @IBAction func setLogo(_ sender: Any) {
        self.isCover = false
        takePhoto()
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backToBrands", sender: self)
    }
    
    
    @IBAction func createBrand(_ sender: Any) {
        
        if let id = UserDefaults.standard.string(forKey: "uid"),
            let brand = self.initBrand {
            Tools.showHUD(viewController: self)
            var ref: DocumentReference? = nil
            ref = db.collection("brands").addDocument(data: brand.docmnt) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    guard let brandId = ref?.documentID else {return}
                    let brandref = self.db.collection("brands").document("\(brandId)")
                    let userRef = self.db.collection("users").document("\(id)")
                    
                    let brandStorageRef = Storage.storage().reference().child("Brand").child(brandId)
                    let coverRef = brandStorageRef.child("cover.jpeg")
                    let logoRef = brandStorageRef.child("logo.jpeg")
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    let coverSize = CGSize(width: 375, height: 280)
                    let logoSize = CGSize(width: 130, height: 130)
                    if let cover =  self.coverImage.image?.sd_resizedImage(with: coverSize, scaleMode: .aspectFill)?.jpegData(compressionQuality: 1.0),
                        let logo = self.logoImage.image?.sd_resizedImage(with: logoSize, scaleMode: .aspectFill)?.jpegData(compressionQuality: 1.0) {
                        coverRef.putData(cover, metadata: metadata, completion: { (meta, error) in
                            if let err = error {
                                Logger.error(tag: "putData(cover", message: err.localizedDescription)
                            }
                        })
                        
                        logoRef.putData(logo, metadata: metadata, completion: { (meta, error) in
                            if let err = error {
                                Logger.error(tag: "putData(logo", message: err.localizedDescription)
                            }
                        })
                    }
                    
                    brandref.updateData([
                        "logoImage": "\(storage)\(logoRef.fullPath)",
                        "coverImage": "\(storage)\(coverRef.fullPath)",
                        "ownerId": id,
                        "brandId": brandId
                    ]) { err in
                        if let err = err {
                            print("Error updating info: \(err)")
                        } else {
                            print("Info successfully updated")
                        }
                    }
                    
                    userRef.updateData([
                        "brands": [brandref]
                    ]) { err in
                        if let err = err {
                            print("Error updating brands: \(err)")
                        } else {
                            print("Brands successfully updated")
                        }
                    }
                    
                    let vc = self.mainstoryboard.instantiateViewController(withIdentifier: "VCBrandProducts") as! VCBrandProducts
                    vc.initBrand = brand
                    vc.initBrand?.id = brandId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    let dispatchGroup = DispatchGroup()
    
    var isCover : Bool = true
    
    var initBrand : Brand?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.brandName.text = initBrand?.name
        guard let founded = initBrand?.founded else {
            return
        }
        self.founded.text = "\(founded)"
    }
    
}

extension VCBrandImages : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let action = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController , animated: true , completion: nil )}
            else {
                print ("not avalible")
            }
        }))
        
        action.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action:UIAlertAction)in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController , animated: true , completion: nil )
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(action , animated: true , completion: nil )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if isCover {
            self.coverImage.image = image
        } else {
            self.logoImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

