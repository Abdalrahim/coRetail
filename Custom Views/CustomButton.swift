//
//  CustomButton.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

/// Designable class for Button
@IBDesignable class CustomButton : UIButton {
    
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
    
    /// Custom the color of the border
    @IBInspectable var numberOfLines : Int {
        set {
            self.titleLabel!.numberOfLines = newValue
        } get {
            return Int(self.titleLabel!.numberOfLines)
        }
    }
    
    @IBInspectable var adjustsFontToFit : Bool {
        set {
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } get {
            return (self.titleLabel?.adjustsFontSizeToFitWidth)!
        }
    }
    
}
