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

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Error: UILabel!
    

    @IBAction func Login(_ sender: Any) {
        Auth.auth().signIn(withEmail: (Email.text!), password: (Password.text!)) { (user, error) in
            if error != nil{
                print(error!)
                self.Error.isHidden = false
            }else{
                print("Login successful")
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
