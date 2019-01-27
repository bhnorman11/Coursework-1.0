//
//  SignUpViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 26/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }


    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func SignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Registration successful")
            }
        })
        self.performSegue(withIdentifier: "SignUp", sender: self)
    }
    
    
    @IBOutlet var peopleButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: Any) {
        peopleButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
}
