//
//  CreateNewClassViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 01/03/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateNewClassViewController: UIViewController  {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Successful.isHidden = true
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        PopUpView.layer.cornerRadius = 5
        VisualEffectView.isHidden = true
    }
    
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    @IBOutlet weak var Code: UILabel!
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Block: UITextField!
    @IBOutlet weak var Set: UITextField!
    @IBOutlet weak var Successful: UILabel!
    var studentArray = [String]()
    var effect:UIVisualEffect!
    
    func animateIn () {
        self.view.addSubview(PopUpView)
        PopUpView.center = self.view.center
        self.VisualEffectView.effect = nil
        PopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        PopUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.PopUpView.alpha = 1
            self.PopUpView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.PopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.PopUpView.alpha = 0
            
        }) {(success:Bool) in
            self.PopUpView.removeFromSuperview()
        }
    }
    
    @IBAction func DismissPopUp(_ sender: Any) {
        animateOut()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    
    @IBAction func GenerateCode(_ sender: Any) {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        Code.text = String((0..<8).map{ _ in characters.randomElement()! })
    }
    
    
    @IBAction func Continue(_ sender: Any) {
        animateIn()
    }
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBAction func CreateClass(_ sender: Any) {
        let email = user?.email
        db.collection("Users").document(email!).collection("Classes").document(Set.text!).setData([
            "Block": Block.text!,
            "Subject": Subject.text!,
            "Set": Set.text!,
            "Active Set": true
            ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        for i in 0...studentArray.count - 1 {
            db.collection("Users").document(email!).collection("Classes").document(Set.text!).collection("Students").document(studentArray[i]).setData([
                "Email": studentArray[i],
                ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    if i == self.studentArray.count - 1 {
                        self.Successful.isHidden = false
                        self.Subject.text = ""
                        self.Block.text = ""
                        self.Set.text = ""
                        self.Code.text = ""
                    }
                    
                }
            }
        }
    }
    
}
