//
//  MakeSuggestionViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MakeSuggestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Successful.isHidden = true
    }
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var Suggestion: UITextField!
    @IBOutlet weak var Successful: UILabel!
    
    func EmptyField() -> Bool{
        if Suggestion.text == "" {
            Successful.textColor = .red
            Successful.text = "Please fill in what suggestion you have."
            Successful.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func checkSuggestionTooLong() -> Bool{
        var counter = 0
        for character in Suggestion.text!.characters {
            counter += 1
        }
        if counter > 100 {
            Successful.textColor = .red
            Successful.text = "Maximum of 150 characters."
            Successful.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func Send(_ sender: Any) {
        if (checkSuggestionTooLong() == false) && (EmptyField() == false) {
            let email = user?.email
            db.collection("Suggestions").document(email!).setData([
                "Suggestion": Suggestion.text!
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
    

}
