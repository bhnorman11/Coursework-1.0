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


    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var studentType = false
    
    
    @IBAction func Login(_ sender: Any) {
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
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
