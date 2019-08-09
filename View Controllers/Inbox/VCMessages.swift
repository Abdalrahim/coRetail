//
//  VCMessages.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 07/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase
import UIKit

class VCMessages: VCBase {
    
    var initMessage : Message?
    var textMessages : [TextMessage] = []
    
    @IBOutlet weak var messageCollection: UICollectionView!
    
    @IBOutlet weak var messagetf: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let message = self.initMessage, let id = UserDefaults.standard.string(forKey: "uid"),
        let text = self.messagetf.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        if text.isEmpty { return }
        
        let messageRef = self.db.collection("messages").document(message.reqId)
        
        let messageData : [String : Any] = [
            "text" : text,
            "time": Timestamp(date: Date()),
            "senderId": id
        ]
        
        messageRef.updateData(["messages": FieldValue.arrayUnion([messageData])])
        
        self.messagetf.text?.removeAll()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: "uid"), let message = self.initMessage else {
            return
        }
        
        self.title = message.senderName
        
        if message.recieverId == id, message.status == 0 {
            self.detailsButton.isEnabled = true
        } else if message.status == 2 {
            self.messagetf.isEnabled = false
            self.sendButton.isEnabled = false
        }
        
        db.collection("messages").document(message.reqId).addSnapshotListener({ (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                
                if let data = querySnapshot?.data() {
                    
                    let message = Message(doc: data)
                    
                    if let textdataArr = data["messages"] as? [[String : Any]] {
                        var textArr : [TextMessage] = []
                        for txt in textdataArr {
                            let text = TextMessage(doc: txt)
                            textArr.append(text)
                        }
                        self.textMessages = textArr
                        message.textMessages = textArr
                    } else {
                        print("no messages in message")
                    }
                    
                    self.initMessage = message
                    
                    self.messageCollection.reloadData()
                } else {
                    print("no message")
                }
            }
        })
        
    }
    
    @IBOutlet weak var detailsButton: UIBarButtonItem!
    
    @IBAction func showOption(_ sender: Any) {
        
        guard let message = self.initMessage, let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        if message.recieverId != id {
            return
        }
        
        let option = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let accept = UIAlertAction(title: "Accept Offer", style: .default) { (action) in
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.notify(queue: .main, execute: {
                Tools.dismissHUD(viewController: self)
                self.back(isSuccess: true)
            })
            
            let transactions = self.db.collection("transactions").document(message.reqId)
            let userRef1 = self.db.collection("users").document(id)
            let userRef2 = self.db.collection("users").document(message.senderId)
            let messageRef = self.db.collection("messages").document(message.reqId)
            let space = self.db.collection("space").document(message.spaceId)
            
            dispatchGroup.enter()
            transactions.setData([
                "brandId" : message.brandId,
                "spaceId": message.spaceId,
                "buyerId": message.senderId,
                "sellerId": message.recieverId,
                "status": 1,
                "type": message.type
                
            ], merge : true) { err in
                dispatchGroup.leave()
                
                if let err = err {
                    print("Error updating transaction: \(err)")
                } else {
                    print("userRef1 successfully updated")
                }
            }
            
            dispatchGroup.enter()
            space.updateData(["isAvailable" : false]){ err in
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            messageRef.updateData(["status" : 1]){ err in
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            userRef1.setData([
                "transaction": [transactions]
            ], merge : true) { err in
                dispatchGroup.leave()
                
                if let err = err {
                    print("Error updating transaction: \(err)")
                } else {
                    print("userRef1 successfully updated")
                }
            }
            
            dispatchGroup.enter()
            userRef2.setData([
                "transaction": [transactions]
            ], merge : true) { err in
                dispatchGroup.leave()
                
                if let err = err {
                    print("Error updating transaction: \(err)")
                } else {
                    print("userRef2 successfully updated")
                }
            }
            
        }
        
        let decline = UIAlertAction(title: "Decline Offer", style: .default) { (action) in
            let messageRef = self.db.collection("messages").document(message.reqId)
            let userRef = self.db.collection("users").document(id)
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            userRef.updateData([
                "messages" : FieldValue.arrayRemove([message.reqId])
                ], completion: { (error) in
                    dispatchGroup.leave()
                    
                    if let err = error {
                        print("Error updating brands: \(err)")
                    } else {
                        Tools.dismissHUD(viewController: self)
                        self.back(isSuccess: false)
                    }
            })
            
            dispatchGroup.enter()
            messageRef.updateData(["status" : 2]){ err in
                dispatchGroup.leave()
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        option.addAction(accept)
        option.addAction(decline)
        option.addAction(cancel)
        option.view.tintColor = #colorLiteral(red: 0.199667722, green: 0.1562016606, blue: 0.3751972914, alpha: 1)
        self.present(option, animated: true, completion: nil)
    }
    
    func back(isSuccess: Bool) {
        let title : String = {
            if isSuccess {
                return "You have accepted the offer succefully"
            } else {
                return "You have declined the offer succefully"
            }
        }()
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension VCMessages : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.textMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as! TextCell
        
        cell.message = self.textMessages[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = self.textMessages[indexPath.row].text
        
        let size = CGSize(width: 250,height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context: nil)
        
        var height = estimatedFrame.height + 40
        
        
        return CGSize(width: view.frame.width, height: height)
    }
}
