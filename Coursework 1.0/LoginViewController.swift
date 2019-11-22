//
//  LoginViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 26/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewController: UIViewController { 

    override func viewDidLoad() {
        super.viewDidLoad()
        Error.isHidden = true
        Email.text = ""
        Password.text = ""

    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var studentType = false
    
    func checkFieldsEmpty() -> Bool{
        if (Email.text == "" ) || (Password.text == "") { //presence check for email and password
            Error.text = "Please fill in all spaces." //error message is displayed
            Error.isHidden = false
            return false
        }
        else {
            return true
        }
    }
    
    func checkEmail() -> Bool {
        var atSymbol = false
        var fullStop = false
        for character in Email.text! {
            if character == "@" { //format check for @ symbol
                atSymbol = true
            }
            else if character == "." { //format check for . symbol
                fullStop = true
            }
        }
        if (atSymbol == true) && (fullStop == true) {
            return true
        }
        else {
            Error.text = "Please have an @ and full stop in your email."
            Error.isHidden = false //displays error message
            return false
        }
    }
    
    @IBAction func Login(_ sender: Any) {
        if (checkFieldsEmpty() == true) && (checkEmail() == true){ //ensures all inputs are valid before allowing a login
            Auth.auth().signIn(withEmail: (Email.text!), password: (Password.text!)) { (user, error) in
                if error != nil{
                    print(error!)
                    self.Error.isHidden = false //error message is displayed if any errors are encountered
                }else{
                    let email = self.Email.text!
                    let docRef = self.db.collection("Users").document(email) //creates a document reference in order to reference and read a document in Firestore
                    docRef.getDocument(source: .cache) { (document, error) in
                        if let document = document{
                            self.studentType = (document.get("Student") as! Bool) //reads the studentType field in Firestore
                            if self.studentType == true {
                                self.performSegue(withIdentifier: "StudentMain", sender: self)//performs the segue to the student home page if student = true
                            }
                            else if self.studentType == false {
                                self.performSegue(withIdentifier: "TeacherMain", sender: self) //else goes to the teacher home page
                            }
                        }
                        else{
                            print("Document does not exist in firestore") //the case when the document does not exist
                        }
                    }
                }
            }
        }
    }
    
    
}
