//
//  CustomView.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 21/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

/// Designable class for view
@IBDesignable class CustomView : UIView {
    
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
    
//    @IBInspectable var putShadow : Bool {
//        set {
//            self.dropShadow()
//        } get {
//            return false
//        }
//    }
}
