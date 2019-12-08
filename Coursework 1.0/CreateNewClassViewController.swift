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

class CreateNewClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count //sets tableview's number of rows to the length of the studentArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = studentArray[indexPath.row] //creates a cell using each member of the studentArray
        return cell
    }
    
    func updateStudents() {
        db.collection("Codes").document(Code.text!).collection("Students").getDocuments() { (QuerySnapshot, err) in //gets all documents in the Students collection of the created code
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                self.studentArray = []
                for document in QuerySnapshot!.documents { //populates the student array by reading all student documents in Firestore
                    let studentEmail = (document.get("Email") as! String) //gets the student email from the field in Firestore
                    self.studentArray.append(studentEmail)
                    self.tableView.reloadData() //updates the table view with the new student array
                }
            }
        }
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        updateStudents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Error.isHidden = true
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        PopUpView.layer.cornerRadius = 5
        VisualEffectView.isHidden = true
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    @IBOutlet weak var Code: UILabel!
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Block: UITextField!
    @IBOutlet weak var Set: UITextField!
    var studentArray = [String]()
    var effect:UIVisualEffect!
    
    @IBOutlet weak var Error: UILabel!
    @IBOutlet weak var PopUpSet: UILabel!
    @IBOutlet weak var PopUpSubject: UILabel!
    @IBOutlet weak var PopUpYear: UILabel!
    @IBOutlet weak var PopUpCode: UILabel!
    @IBOutlet weak var PopUpError: UILabel!
    @IBOutlet weak var PopUpSuccessful: UILabel!
    
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
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    @IBAction func DismissPopUp(_ sender: Any) {
        animateOut()
        db.collection("Codes").document(Code.text!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    @IBAction func GenerateCode(_ sender: Any) {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //all alphanumeric characters
        Code.text = String((0..<8).map{ _ in characters.randomElement()!}) //creates a random string of length 8 by mapping the characters and selecting a random element of this 8 times.
    }
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBAction func Continue(_ sender: Any) {
        if validContinue() == true && validYear() == true {
            animateIn() //performs pop up animation
            PopUpSubject.text = Subject.text
            PopUpSet.text = Set.text
            PopUpYear.text = Block.text
            PopUpCode.text = Code.text //sets all the pop up labels to the typed in values in the view
            let email = user?.email
            db.collection("Codes").document(Code.text!).setData([ //creates a new document in the "Codes" collection in Firestore
                "Block": Block.text!,
                "Subject": Subject.text!,
                "Set": Set.text!,
                "Teacher email": email!
                ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        else {
            Error.text = "Please fill in all information." //if validContinue and validYear aren't met, display the error message
            Error.isHidden = false
        }
        
    }
    
    func validContinue() -> Bool { //checks if any fields are blank
        if Code.text == "" {
            return false
        }
        if Subject.text == "" {
            return false
        }
        if Set.text == "" {
            return false
        }
        if Block.text == "" {
            return false
        }
        else {
            return true
        }
    }
    
    func validYear() -> Bool { //checks that only years of the correct form are entered
        if (Block.text != "13") && (Block.text != "12") && (Block.text != "11") && (Block.text != "10") && (Block.text != "9") {
            return false
        }
        else{
            return true
        }
    }
    
    @IBAction func CreateClass(_ sender: Any) {
        if studentArray.count != 0 {
            let email = user?.email
            db.collection("Users").document(email!).collection("Classes").document(Set.text!).setData([ //creates a new set within the collection of classes, which is within the collection of users
                "Block": Block.text!,
                "Subject": Subject.text!,
                "Set": Set.text!,
                "Active Set": true, //determines if a set is still in use
                "Code": Code.text!
                ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    
                }
            }
            for i in 0...studentArray.count - 1 {
                db.collection("Users").document(email!).collection("Classes").document(Set.text!).collection("Students").document(studentArray[i]).setData([ //within this created class a collection of students is created
                    "Email": studentArray[i] //each student email is then added
                    ])
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        if i == self.studentArray.count - 1 { //checks to see if iteration has gone through the whole array
                            self.Subject.text = ""
                            self.Block.text = ""
                            self.Set.text = ""
                            self.Code.text = "" //resets all fields to blank
                        }
                        
                    }
                }
            }
            self.PopUpError.isHidden = true
            self.PopUpSuccessful.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.animateOut()
            }
        }
        else {
            self.PopUpError.isHidden = false
        }
    }
    
}
