//
//  ReportProblemViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ReportProblemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Problem: UITextField!
    
    
    let db = Firestore.firestore()
    
    @IBAction func sendData(_ sender: Any) {
        db.collection("Reviews").document(Problem.text!).setData([
            "Problem": Problem.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
}

