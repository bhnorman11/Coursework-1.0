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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        <#code#>
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var sets = [String]()
    
    func getSets() {
        let email = user?.email
        let docRef = self.db.collection("Teachers").document(email!).collection("Classes").document()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideEverything()
        getSets()
        
    }
    
    func hideEverything() {
        SubjectLabel.isHidden = true
        SubjectText.isHidden = true
        BlockLabel.isHidden = true
        BlockTest.isHidden = true
        AddEmailLabel.isHidden = true
        AddEmailText.isHidden = true
        AddEmailButton.isHidden = true
        StudentTable.isHidden = true
    }
    

    @IBOutlet weak var SetPicker: UIPickerView!
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var SubjectText: UILabel!
    @IBOutlet weak var BlockLabel: UILabel!
    @IBOutlet weak var BlockTest: UILabel!
    @IBOutlet weak var StudentTable: UITableView!
    @IBOutlet weak var AddEmailLabel: UILabel!
    @IBOutlet weak var AddEmailText: UITextField!
    @IBOutlet weak var AddEmailButton: UIButton!
    

}
