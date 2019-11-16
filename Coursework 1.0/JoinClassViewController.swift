//
//  JoinClassViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 10/11/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class JoinClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Error.isHidden = true
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        PopUpView.layer.cornerRadius = 5
        VisualEffectView.isHidden = true
    }
    
    
    @IBOutlet weak var NoClassFound: UILabel!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    var effect: UIVisualEffect!
    @IBOutlet weak var Code: UITextField!
    @IBOutlet weak var Error: UILabel!
    @IBOutlet weak var PopUpTeacher: UILabel!
    @IBOutlet weak var PopUpTeacherLabel: UILabel!
    @IBOutlet weak var PopUpYear: UILabel!
    @IBOutlet weak var PopUpYearLabel: UILabel!
    @IBOutlet weak var PopUpSubject: UILabel!
    @IBOutlet weak var PopUpSubjectLabel: UILabel!
    @IBOutlet weak var PopUpSet: UILabel!
    @IBOutlet weak var PopUpSetLabel: UILabel!
    
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
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBAction func Continue(_ sender: Any) {
        if validateEntry() == true {
            animateIn()
            let docRef = self.db.collection("Codes").document(Code.text!)
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document{
                    self.PopUpTeacher.text = (document.get("Teacher email") as! String)
                    self.PopUpTeacher.isHidden = false
                    self.PopUpTeacherLabel.isHidden = false
                    self.PopUpYear.text = (document.get("Block") as! String)
                    self.PopUpYear.isHidden = false
                    self.PopUpYearLabel.isHidden = false
                    self.PopUpSet.text = (document.get("Set") as! String)
                    self.PopUpSet.isHidden = false
                    self.PopUpSetLabel.isHidden = false
                    self.PopUpSubject.text = (document.get("Subject") as! String)
                    self.PopUpSubject.isHidden = false
                    self.PopUpSubjectLabel.isHidden = false
                    self.NoClassFound.isHidden = true
                    
                }
                else{
                    print("Document does not exist in firestore")
                    self.NoClassFound.isHidden = false
                    self.PopUpTeacher.isHidden = true
                    self.PopUpTeacherLabel.isHidden = true
                    self.PopUpSet.isHidden = true
                    self.PopUpSetLabel.isHidden = true
                    self.PopUpSubject.isHidden = true
                    self.PopUpSubjectLabel.isHidden = true
                    self.PopUpYear.isHidden = true
                    self.PopUpYearLabel.isHidden = true
                }
            }
        }
    }

    @IBAction func DismissPopUp(_ sender: Any) {
        animateOut()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    func validateEntry() -> Bool{
        if Code.text!.count != 8 {
            Error.isHidden = false
            return false
        }
        else{
            return true
        }
    }

}
