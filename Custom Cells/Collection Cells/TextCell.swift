//
//  TextCell.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 08/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet weak var dateText: UILabel!
    
    
    var message : TextMessage! {
        didSet {
            guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
            self.textView.text = message.text
            self.textView.textColor = .white
            let size = CGSize(width: 250,height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.text)
                .boundingRect(with: size, options: options, attributes:
                    [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context: nil)
            
            self.dateText.text = Tools.getDate(format: "hh:mm a", date: message.time.dateValue())
            
            self.textView.layer.cornerRadius = 15
            self.textView.layer.masksToBounds = true
            self.textView.layer.borderWidth = 1
            self.textView.layer.borderColor = #colorLiteral(red: 0.199667722, green: 0.1562016606, blue: 0.3751972914, alpha: 1)
            
            self.textView.isUserInteractionEnabled = true
            
            if self.message.senderId == uid || self.message.senderId == "0" {
                self.textView.contentMode = .right
                self.dateText.textAlignment = .right
                self.textView.backgroundColor = #colorLiteral(red: 0.199667722, green: 0.1562016606, blue: 0.3751972914, alpha: 1)
                self.textView.textColor = #colorLiteral(red: 0.9450054765, green: 0.9451642632, blue: 0.9793649316, alpha: 1)
                self.textView.frame = CGRect(x: self.frame.width - estimatedFrame.width - 40, y: 0, width: estimatedFrame.width + 30, height: estimatedFrame.height + 20)
            } else {
                self.textView.contentMode = .left
                self.dateText.textAlignment = .left
                self.textView.backgroundColor = #colorLiteral(red: 0.9450054765, green: 0.9451642632, blue: 0.9793649316, alpha: 1)
                self.textView.textColor = #colorLiteral(red: 0.199667722, green: 0.1562016606, blue: 0.3751972914, alpha: 1)
                
                self.textView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 30, height: estimatedFrame.height + 20)
            }
        }
    }
}

