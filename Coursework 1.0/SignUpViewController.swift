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
    @IBOutlet weak var Error: UILabel!
    
    func emptyFields() -> Bool {
        if Email.text == "" {
            Error.text = "Please input your email address."
            Error.isHidden = false
            return true
        }
        else if Password.text == "" {
            Error.text = "Please input your password."
            Error.isHidden = false
            return true
        }
        else if FirstName.text == "" {
            Error.text = "Please input your first name."
            Error.isHidden = false
            return true
        }
        else if LastName.text == "" {
            Error.text = "Please input your last name."
            Error.isHidden = false
            return true
        }
        else if Block.text == "" {
            Error.text = "Please input your block."
            Error.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func validEmail() -> Bool {
        var atSymbol = false
        var fullStop = false
        for character in Email.text!.characters {
            if character == "@"{
                atSymbol = true
            }
            else if character == "." {
                fullStop = true
            }
        }
        if atSymbol == false {
            Error.text = "Please include an @ symbol in your email."
            Error.isHidden = false
            return false
        }
        else if fullStop == false {
            Error.text = "Please include a full stop in your email."
            Error.isHidden = false
            return false
        }
        else {
            return true
        }
    }
    
    func selectedStudentOrTeacher () -> Bool {
        if (Student.alpha == 1.0) && (Teacher.alpha == 1.0) {
            Error.text = "Please select whether you're a student or a teacher."
            Error.isHidden = false
            return false
        }
        else {
            return true
        }
    }
    
    func validYear() -> Bool {
        if (Block.text != "13") && (Block.text != "12") && (Block.text != "11") && (Block.text != "10") && (Block.text != "9") {
            Error.text = "Please select 13, 12, 11, 10 or F9 as your year."
            Error.isHidden = false
            return false
        }
        else {
            return true
        }
    }
    
    func checkValidInputs() -> Bool {
        if (emptyFields() == false) && (validEmail() == true) && (selectedStudentOrTeacher() == true) && (validYear() == true) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        if checkValidInputs() == true {
            if Student.alpha == 1.0 {
                Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        self.db.collection("Users").document(self.Email.text!).setData([
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
                    }
                })
                self.performSegue(withIdentifier: "StudentSignUp", sender: self)
            }
            else if Student.alpha != 1.0 {
                Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        self.db.collection("Teachers").document(self.Email.text!).setData([
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
                    }
                })
                self.performSegue(withIdentifier: "TeacherSignUp", sender: self)
            }
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
    
    
    
}
