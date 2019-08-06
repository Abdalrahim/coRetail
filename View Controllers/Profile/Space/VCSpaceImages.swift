//
//  VCSpaceImages.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 05/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class VCSpaceImages: VCBase {
    
    @IBOutlet weak var imagesStack: UIStackView!
    
    @IBAction func addImages(_ sender: Any) {
        takePhoto()
    }
    
    var spaceImages : [UIImage] = []
    var options : [[Int : Bool]] = [[:]]
    var detail : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func next(_ sender: Any) {
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCAminities") as! VCAminities
        vc.spacedetail = detail
        vc.spacedetail["images"] = self.spaceImages
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension VCSpaceImages : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        self.spaceImages.append(image)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
