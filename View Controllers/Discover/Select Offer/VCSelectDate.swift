//
//  VCSelectDate.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 07/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class VCSelectDate: VCBase {
    
    @IBOutlet weak var startingDate: UITextField!
    @IBOutlet weak var endingDate: UITextField!
    
    @IBOutlet weak var pricePDay: UITextField!
    
    @IBOutlet weak var total: UITextField!
    
    @IBAction func makeOffer(_ sender: Any) {
        self.messageMake()
    }
    
    func messageMake() {
        guard let space = self.initSpace, let brand = self.initBrand, let id = UserDefaults.standard.string(forKey: "uid") else { return }
        
        Tools.showHUD(viewController: self)
        
        self.defineType(space: space, brand: brand, id: id)
        
        self.message["messageDate"] = Timestamp(date: Date())
        self.message["price"] = self.totalVal
        self.message["type"] = self.type
        self.message["status"] = 0
        self.message["startDate"] = self.startDate
        self.message["endDate"] = self.endDate
       
        let reqId = "req-" + Tools.randomString(length: 12)
        
        self.message["reqId"] = reqId
        
        db.collection("messages").document(reqId).setData(self.message) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
                let dispatchGroup = DispatchGroup()
                
                let ref = self.db.collection("messages").document(reqId)
                
                let userRef1 = self.db.collection("users").document("\(space.ownerId)")
                
                let userRef2 = self.db.collection("users").document("\(id)")
                
                dispatchGroup.notify(queue: .main, execute: {
                    Tools.dismissHUD(viewController: self)
                    self.back()
                })
                
                dispatchGroup.enter()
                
                userRef1.updateData(
                    ["messages": FieldValue.arrayUnion([ref])],
                    completion: { (error) in
                    dispatchGroup.leave()
                    if let err = error {
                        print("Error updating brands: \(err)")
                    } else {
                        print("userRef1 successfully updated")
                    }
                })
                
//                userRef1.updateData(["messages": FieldValue.arrayUnion([messageData])])
//                userRef1.setData([
//                    "messages": [ref]
//                ], merge : true) { err in
//                    dispatchGroup.leave()
//                    
//                    if let err = err {
//                        print("Error updating brands: \(err)")
//                    } else {
//                        print("userRef1 successfully updated")
//                    }
//                }
                dispatchGroup.enter()
                userRef2.setData([
                    "messages": [ref]
                ], merge : true) { err in
                    dispatchGroup.leave()
                    
                    if let err = err {
                        print("Error updating brands: \(err)")
                    } else {
                        print("userRef2 successfully updated")
                    }
                }
                
            }
        }
        
    }
    
    func defineType(space: Space, brand : Brand, id: String) {
        switch self.type {
            
        case 0:
            /// A brand wanting to Rent
            
            self.message["brandId"] = brand.id
            self.message["spaceId"] = space.id
            
            self.message["senderName"] = brand.name
            self.message["senderId"] = id
            
            self.message["recieverName"] = space.name
            self.message["recieverId"] = space.ownerId
            
            let days = self.daysBetween(date1: datePicker1.date, date2: datePicker2.date)
            
            let startDate = Tools.getDate(format: "dd-MM-yyyy", date: datePicker1.date)
            let endDate = Tools.getDate(format: "dd-MM-yyyy", date: datePicker2.date)
            
            let messageText = """
            Greetings Owner of \(space.name),
            I would like to rent \(space.name) for \(days) days starting from \(startDate) to \(endDate).
            Sincerely,
            \(brand.name)
            """
            
            self.message["message"] = messageText
            
            let textMessage : [String : Any] = [
                "text" : messageText,
                "time" : Timestamp(date: Date()),
                "senderId" : id
            ]
            
            self.message["messages"] = [
                textMessage
            ]
            
            break
        case 1:
            /// A space want to offer
            
            self.message["brandId"] = brand.id
            self.message["spaceId"] = space.id
            self.message["senderId"] = id
            
            self.message["recieverName"] = brand.name
            self.message["recieverId"] = brand.ownerId
            self.message["senderName"] = space.name
            
            let days = self.daysBetween(date1: datePicker1.date, date2: datePicker2.date)
            
            let startDate = Tools.getDate(format: "dd-MM-yyyy", date: datePicker1.date)
            let endDate = Tools.getDate(format: "dd-MM-yyyy", date: datePicker2.date)
            
            let messageText = """
            Greetings Owner of \(brand.name),
            I want to offer you to rent \(space.name) for \(days) days starting from \(startDate) to \(endDate).
            Sincerely,
            \(space.name)
            """
            
            self.message["message"] = messageText
            
            let textMessage : [String : Any] = [
                "text" : messageText,
                "time" : Timestamp(date: Date()),
                "senderId" : id
            ]
            
            self.message["messages"] = [
                textMessage
            ]
            break
        default:
            return
        }
    }
    
    func back() {
        let alert = UIAlertController(title: "Your offer has been sent successfully!", message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Nice", style: .default) { (action) in
            if self.type == 0 {
                self.performSegue(withIdentifier: "tospace", sender: alert)
            } else {
                self.performSegue(withIdentifier: "tobrand", sender: alert)
            }
            
        }
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var initSpace : Space?
    var initBrand : Brand?
    
    var message : [String : Any] = [:]
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var startDate :Timestamp?
    var endDate :Timestamp?
    
    var totalVal : Double = 0.0
    
    var type : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ppday = initSpace?.pricePerDay {
            self.pricePDay.text = "\(ppday)"
        }
        self.createDate()
    }
    
    func createDate() {
        
        datePicker1.datePickerMode = .date
        datePicker2.datePickerMode = .date
        
        datePicker1.minimumDate = self.initSpace?.availabilityS?.dateValue() ?? Date()
        datePicker1.maximumDate = self.initSpace?.availabilityE?.dateValue() ?? nil
        
        datePicker2.minimumDate = self.initSpace?.availabilityS?.dateValue() ?? datePicker1.date
        datePicker2.maximumDate = self.initSpace?.availabilityE?.dateValue() ?? nil
        
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
        datePicker2.minimumDate = datePicker1.date
        self.endingDate.becomeFirstResponder()
    }
    
    @objc func doneDate2() {
        endingDate.text = Tools.getDate(format: "dd-MM-yyyy", date: datePicker2.date)
        self.endDate = Timestamp(date: datePicker2.date)
        
        let day = self.daysBetween(date1: datePicker1.date, date2: datePicker2.date)
        
        if let ppday = initSpace?.pricePerDay {
            self.totalVal = Double(day) * ppday
            self.total.text = "\(Double(day) * ppday)"
        }
        
        self.view.endEditing(true)
    }
    
    func daysBetween(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: date1)
        let date2 = calendar.startOfDay(for: date2)
        
        let components = calendar.dateComponents([Calendar.Component.day], from: date1, to: date2)
        
        return components.day ?? 0
    }
}
