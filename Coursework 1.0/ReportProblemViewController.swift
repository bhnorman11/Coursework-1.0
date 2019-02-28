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
    
    @IBAction func sendData(_ sender: Any) {
        let email = user?.email
        db.collection("Problems").document(email!).setData([
            "Problem": Problem.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.Successful.isHidden = false
            }
        }
    }
    
    
}

