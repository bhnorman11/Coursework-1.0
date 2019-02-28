//
//  AskQuestionViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AskQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var Question: UITextField!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBAction func Send(_ sender: Any) {
        let email = user?.email
        db.collection("Questions").document(email!).setData([
            "Question": Question.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
}
