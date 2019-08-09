//
//  VCInbox.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 29/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import Firebase
import UIKit

class VCInbox: VCBase {
    
    @IBOutlet weak var messageTable: UITableView!
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        db.collection("users").document(id).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let messageArr = querySnapshot?.data()?["messages"] as? [DocumentReference] {
                    var messageArray : [Message] = []
                    for messageRef in messageArr {
                        messageRef.getDocument(completion: { (snapshot, error) in
                            if let err = error {
                                Logger.error(tag: "VCMyBrands: get brands", message: err.localizedDescription)
                            } else {
                                if let data = snapshot?.data() {
                                    
                                    let message = Message(doc: data)

                                    if let productsArr = data["messages"] as? [[String : Any]] {
                                        var prdctArr : [TextMessage] = []
                                        for product in productsArr {
                                            let prdct = TextMessage(doc: product)
                                            prdctArr.append(prdct)
                                        }
                                        message.textMessages = prdctArr
                                    } else {
                                        print("no messages in message")
                                    }
                                    
                                    messageArray.append(message)
                                    self.messages = messageArray
                                    self.messageTable.reloadData()
                                }
                            }
                        })
                    }
                    
                } else {
                    print("no message")
                }
            }
        })
        
    }
    
}

extension VCInbox : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        let message = self.messages[indexPath.row]
        cell.textLabel?.text = message.recieverName
        
        if message.type == 0 {
            cell.detailTextLabel?.text = "Rent Space"
        } else {
            cell.detailTextLabel?.text = "Offer Space"
        }
        
        return cell
    }
    
    
}

extension VCInbox : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "VCMessages") as! VCMessages
        vc.initMessage = message
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
