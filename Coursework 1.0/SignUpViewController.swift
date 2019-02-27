//
//  SignUpViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 26/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }


    }
    
    @IBOutlet weak var BlockLabel: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Block: UITextField!
    
    @IBAction func SignUp(_ sender: Any) {
        if Student.alpha == 1.0 {
            Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
                if error != nil{
                    print(error!)
                }else{
                    print("Registration successful")
                }
            })
            self.db.collection("Users").document(Email.text!).setData([
                "Student": true,
                "First Name": self.FirstName.text!,
                "Second Name": self.LastName.text!,
                "Block": self.Block.text!])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            self.performSegue(withIdentifier: "StudentSignUp", sender: self)
        }
        else if Student.alpha != 1.0 {
            Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
                if error != nil{
                    print(error!)
                }else{
                    print("Registration successful")
                }
            })
            self.db.collection("Users").document(Email.text!).setData([
                "Student": false,
                "First Name": self.FirstName.text!,
                "Last Name": self.LastName.text!])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            self.performSegue(withIdentifier: "TeacherSignUp", sender: self)
        }
        
        
    }
    
    let db = Firestore.firestore()
    
    @IBOutlet var peopleButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: Any) {
        peopleButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    @IBOutlet weak var Student: UIButton!
    @IBOutlet weak var Teacher: UIButton!
    
    @IBAction func StudentSelect(_ sender: Any) {
        Teacher.alpha = 0.3
        Student.alpha = 1.0
        Block.isHidden = false
        BlockLabel.isHidden = false
    }
    @IBAction func TeacherSelect(_ sender: Any) {
        Student.alpha = 0.3
        Teacher.alpha = 1.0
        Block.isHidden = true
        BlockLabel.isHidden = true
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
