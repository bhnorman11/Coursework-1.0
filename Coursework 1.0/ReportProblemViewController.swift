//
//  ReportProblemViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ReportProblemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Successful.isHidden = true
    }
    
    @IBOutlet weak var Successful: UILabel!
    
    
    @IBOutlet weak var Problem: UITextField!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func EmptyField() -> Bool{
        if Problem.text == "" {
            Successful.textColor = .red
            Successful.text = "Please fill in what problem you have."
            Successful.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func checkProblemTooLong() -> Bool{
        var counter = 0
        for _ in Problem.text! {
            counter += 1
        }
        if counter > 100 {
            Successful.textColor = .red
            Successful.text = "Maximum: 150 characters."
            Successful.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func sendData(_ sender: Any) {
        if (checkProblemTooLong() == false) && (EmptyField() == false) {
            let email = user?.email
            db.collection("Problems").document(email!).setData([
                "Problem": Problem.text!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.Successful.textColor = .blue
                    self.Successful.text = "Problem reported!"
                    self.Successful.isHidden = false
                }
            }
        }
    }
    
    
}

