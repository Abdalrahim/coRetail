//
//  CustomImage.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 29/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

/// Designable class for image view
@IBDesignable class CustomImage : UIImageView {
    
    /// Custom the border width
    @IBInspectable var borderWidth : Int {
        set {
            self.layer.borderWidth = CGFloat(newValue)
        } get {
            return Int(self.layer.borderWidth)
        }
    }
    
    /// Custom the corner radius
    @IBInspectable var cornerRadius : Int {
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        } get {
            return Int(self.layer.cornerRadius)
        }
    }
    
    
    /// Custom the color of the border
    @IBInspectable var borderColor : UIColor = UIColor.white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
