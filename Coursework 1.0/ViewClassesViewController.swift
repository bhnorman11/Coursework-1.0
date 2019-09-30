//
//  ViewClassesViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 08/03/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewClassesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var sets = [String]()
    var new_sets = [String]()
   
    func getSets() -> [String]{
        let email = user?.email
        db.collection("Users").document(email!).collection("Classes").whereField("Active Set", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    self.sets.append(document.documentID)
                }
                print(self.sets)
                
            }
        }
        return sets
    }
 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        new_sets = getSets()
        return new_sets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        new_sets = getSets()
        return new_sets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        new_sets = getSets()
        SetLabel.text = new_sets[row]
        unhideEverything()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideEverything()
    }
    
    func hideEverything() {
        SubjectLabel.isHidden = true
        SubjectText.isHidden = true
        BlockLabel.isHidden = true
        BlockTest.isHidden = true
        AddEmailLabel.isHidden = true
        AddEmailText.isHidden = true
        AddEmailButton.isHidden = true
    }
    
    func unhideEverything() {
        SubjectLabel.isHidden = false
        SubjectText.isHidden = false
        BlockLabel.isHidden = false
        BlockTest.isHidden = false
        AddEmailLabel.isHidden = false
        AddEmailText.isHidden = false
        AddEmailButton.isHidden = false
    }
    

    @IBOutlet weak var SetLabel: UILabel!
    @IBOutlet weak var SetPicker: UIPickerView!
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var SubjectText: UILabel!
    @IBOutlet weak var BlockLabel: UILabel!
    @IBOutlet weak var BlockTest: UILabel!
    @IBOutlet weak var AddEmailLabel: UILabel!
    @IBOutlet weak var AddEmailText: UITextField!
    @IBOutlet weak var AddEmailButton: UIButton!
    

}
