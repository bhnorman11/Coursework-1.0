//
//  TeacherMainViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 27/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TeacherMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTypeArray[indexPath.row] //creates a cell using each member of the messageType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row //index of the selected row
        performSegue(withIdentifier: "NotificationSegue", sender: self) //segues to the notification view
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete { //if the teacher swipes left and clicks the delete button on the cell
            let email = user?.email
            db.collection("Users").document(email!).collection("Classes").document(setArray[myIndex]).collection("Feedback").document(messageReferenceArray[myIndex]).delete() { err in //deletes the document from the feedback collection
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.messageTypeArray.remove(at: self.myIndex) //removes all data from arrays so that the tableView can be reloaded
                    self.messageArray.remove(at: self.myIndex)
                    self.messageReferenceArray.remove(at: self.myIndex)
                    self.setArray.remove(at: self.myIndex)
                    self.studentEmailArray.remove(at: self.myIndex)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func updateFeedback() { //populates all arrays with different fields read from Firestore in preparation to pass to the notification view
        self.messageArray = []
        self.messageTypeArray = []
        self.studentEmailArray = []
        self.messageReferenceArray = []
        let email = user?.email //sets email to email used to login/sign up with
        db.collection("Users").document(email!).collection("Classes").getDocuments() { (QuerySnapshot, err) in //gets all sets in the teacher's classes
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in QuerySnapshot!.documents { //loops through all classes documents in Firestore
                    self.db.collection("Users").document(email!).collection("Classes").document(document.documentID).collection("Feedback").getDocuments() { (QuerySnapshot, err) in //gets all feedback in the set in the teacher's classes
                        let set = document.documentID
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }
                        else {
                            for document in QuerySnapshot!.documents { //loops through all feedback documents within each class
                                let messageType = (document.get("Message Type") as! String) //gets the message type from the field in Firestore
                                let message = (document.get("Message") as! String) //gets the message from the field in Firestore
                                let studentEmail = (document.get("Student Email") as! String) //gets the student email from Firestore
                                let messageReference = document.documentID
                                self.messageArray.append(message)
                                self.messageTypeArray.append(messageType)
                                self.studentEmailArray.append(studentEmail)
                                self.messageReferenceArray.append(messageReference)
                                self.setArray.append(set)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData() //updates the table view with the new message types
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //prepares for segue by setting values created in the notification view to the selected cells data using myIndex
        if segue.identifier == "NotificationSegue" { //multiple segues are performed from this view, only sets the values if it is the notification segue
            let notificationController = segue.destination as! TeacherNotificationViewController //sets the destination view controller
            notificationController.studentEmail = studentEmailArray[myIndex] //sets values in the destination view controller to the values read from Firestore
            notificationController.message = messageArray[myIndex]
            notificationController.messageType = messageTypeArray[myIndex]
            notificationController.messageReference = messageReferenceArray[myIndex]
            notificationController.set = setArray[myIndex]
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var messageArray = [String]()
    var messageTypeArray = [String]()
    var studentEmailArray = [String]()
    var messageReferenceArray = [String]()
    var setArray = [String]()
    var myIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        updateFeedback()
        VisualEffectView.isHidden = true
        SettingsView.layer.cornerRadius = 5
        LogoutView.layer.cornerRadius = 5
    }
    
    func animateInLogout () {
        self.view.addSubview(LogoutView)
        LogoutView.center = self.view.center
        LogoutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        LogoutView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.LogoutView.alpha = 1
            self.LogoutView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutLogout () {
        UIView.animate(withDuration: 0.3, animations: {
            self.LogoutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.LogoutView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.LogoutView.removeFromSuperview()
        }
    }
    
    @IBAction func LogoutConfirmed(_ sender: Any) {
        performSegue(withIdentifier: "Logout", sender: self)
    }
    
    @IBAction func Logout(_ sender: Any) {
        animateInLogout()
        LogoutView.isUserInteractionEnabled = true
        LogoutView.isHidden = false
        VisualEffectView.isUserInteractionEnabled = true
    }
    
    @IBAction func cancelLogout(_ sender: Any) {
        animateOutLogout()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    func animateInSettings () {
        self.view.addSubview(SettingsView)
        SettingsView.center = self.view.center
        SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        SettingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.SettingsView.alpha = 1
            self.SettingsView.transform = CGAffineTransform.identity
        }
    }
    
    var effect:UIVisualEffect!
    
    func animateOutSettings () {
        UIView.animate(withDuration: 0.3, animations: {
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.SettingsView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.SettingsView.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    
    @IBOutlet var LogoutView: UIView!
    @IBOutlet var SettingsView: UIView!
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOutSettings()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
        LogoutView.isHidden = true
        LogoutView.isUserInteractionEnabled = false
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        animateInSettings()
        VisualEffectView.isUserInteractionEnabled = true
    }
    
}
