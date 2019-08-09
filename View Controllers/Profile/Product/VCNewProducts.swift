//
//  VCNewProduct.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 03/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class VCNewProduct: VCBase {
    
    @IBOutlet weak var imagesStack: UIStackView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var qauntity: UITextField!
    
    @IBOutlet weak var quantityStepper: UIStepper!
    
    @IBOutlet weak var price: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createProduct(_ sender: Any) {
        
        if let brand = self.initBrand {
            let price = Double(Int(self.price.text ?? "0") ?? 0)
            Tools.showHUD(viewController: self)
            
            let productId = Tools.randomString(length: 10)
            self.startUploading(productId: productId) {
                let product = Product(Id: "prdct-" + productId, Name: self.name.text ?? "", Price: price, Images: self.imagesName, Desc: self.desc.text, Inv: self.quantityNum)
                self.db.collection("brands").document(brand.id).updateData([
                    "products": FieldValue.arrayUnion([product.docmnt])
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        let send = sender as! UIStepper
        self.qauntity.text = "\(Int(send.value))"
        self.quantityNum = Int(send.value)
    }
    
    @IBAction func addImage(_ sender: Any) {
        self.takePhoto()
    }
    
    var initBrand : Brand?
    
    var quantityNum = 1
    
    var images : [UIImage] = []
    
    var imagesName : [String] = []
    
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startUploading(productId: String ,completion: @escaping FileCompletionBlock) {
        if images.count == 0 {
            completion()
            return;
        }
        
        block = completion
        uploadImage(forIndex: 0, productId : productId)
    }
    
    func uploadImage(forIndex index:Int, productId : String) {
        
        if index < images.count {
            /// Perform uploading
            let productImageSize = CGSize(width: 250, height: 250)
            
            guard let brand = self.initBrand else { return }
            let productRed = Storage.storage().reference().child("Brand")
                .child(brand.id).child(productId).child("\(Tools.generateFileNameByDateAndTime()).jpeg")
            guard let data = images[index].sd_resizedImage(with: productImageSize, scaleMode: .aspectFill)?.jpegData(compressionQuality: 0.8) else {return}
            
            FirFile.shared.upload(data: data, atPath: productRed, block: { (url) in
                /// After successfully uploading call this method again by increment the **index = index + 1**
                print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
                self.imagesName.append(url ?? "")
                self.uploadImage(forIndex: index + 1, productId: productId)
            })
            return;
        }
        
        if block != nil {
            block!()
        }
    }
    
}

extension VCNewProduct : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        action.view.tintColor = #colorLiteral(red: 0.122172378, green: 0.01825772598, blue: 0.3603883386, alpha: 1)
        self.present(action , animated: true , completion: nil )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        self.imagesStack.insertArrangedSubview(imageView, at: 1)
        
        self.images.append(image)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

