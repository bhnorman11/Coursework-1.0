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
        if (Email.text == "" ) || (Password.text == "") {
            Error.text = "Please fill in all spaces."
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
        for character in Email.text!.characters {
            if character == "@" {
                atSymbol = true
            }
            else if character == "." {
                fullStop = true
            }
        }
        if (atSymbol == true) && (fullStop == true) {
            return true
        }
        else {
            Error.text = "Please have an @ and full stop in your email."
            Error.isHidden = false
            return false
        }
    }
    
    @IBAction func Login(_ sender: Any) {
        if (checkFieldsEmpty() == true) && (checkEmail() == true){
            Auth.auth().signIn(withEmail: (Email.text!), password: (Password.text!)) { (user, error) in
                if error != nil{
                    print(error!)
                    self.Error.isHidden = false
                }else{
                    let email = self.Email.text!
                    let docRef = self.db.collection("Users").document(email)
                    docRef.getDocument(source: .cache) { (document, error) in
                        if let document = document{
                            self.studentType = (document.get("Student") as! Bool)
                            if self.studentType == true {
                                self.performSegue(withIdentifier: "StudentMain", sender: self)
                            }
                            else if self.studentType == false {
                                self.performSegue(withIdentifier: "TeacherMain", sender: self)
                            }
                        }
                        else{
                            print("Document does not exist in firestore")
                        }
                    }
                }
            }
        }
    }
    
    
}
