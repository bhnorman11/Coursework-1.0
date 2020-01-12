//
//  StudentMainViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 27/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class StudentMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messageArray = [String]()
    var messageTypeArray = [String]()
    var teacherEmailArray = [String]()
    var messageReferenceArray = [String]()
    var setArray = [String]()
    var myIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTypeArray[indexPath.row] //creates a cell using each member of the messageType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row //sets myIndex to the selected feedback cell
        performSegue(withIdentifier: "NotificationSegue", sender: self) //segues to the notification view
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete { //if the teacher swipes left and clicks the delete button on the cell
            let email = user?.email
            db.collection("Users").document(email!).collection("Classes").document(setArray[myIndex]).collection("Feedback").document(messageReferenceArray[myIndex]).delete() { err in //deletes the document from the Codes collection to save memory
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.messageTypeArray.remove(at: self.myIndex)
                    self.messageArray.remove(at: self.myIndex)
                    self.messageReferenceArray.remove(at: self.myIndex)
                    self.setArray.remove(at: self.myIndex)
                    self.teacherEmailArray.remove(at: self.myIndex)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func updateFeedback() {
        self.messageArray = []
        self.messageTypeArray = []
        self.teacherEmailArray = []
        self.messageReferenceArray = []
        let email = user?.email //sets email to email used to login/sign up with
        db.collection("Users").document(email!).collection("Classes").getDocuments() { (QuerySnapshot, err) in //gets all sets in the teacher's classes
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in QuerySnapshot!.documents {
                    self.db.collection("Users").document(email!).collection("Classes").document(document.documentID).collection("Feedback").getDocuments() { (QuerySnapshot, err) in //gets all feedback in the set in the teacher's classes
                        let set = document.documentID
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }
                        else {
                            for document in QuerySnapshot!.documents { //populates the message and message type arrays by reading all documents in Firestore
                                let messageType = (document.get("Message Type") as! String) //gets the message type from the field in Firestore
                                let message = (document.get("Message") as! String) //gets the message from the field in Firestore
                                let teacherEmail = (document.get("Teacher Email") as! String) //gets the student email from Firestore
                                let messageReference = document.documentID
                                self.messageArray.append(message)
                                self.messageTypeArray.append(messageType)
                                self.teacherEmailArray.append(teacherEmail)
                                self.messageReferenceArray.append(messageReference)
                                self.setArray.append(set)
                                print(self.messageArray)
                                print(self.messageTypeArray)
                                print(self.teacherEmailArray)
                                print(self.setArray)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotificationSegue" {
            let notificationController = segue.destination as! StudentNotificationViewController
            notificationController.teacherEmail = teacherEmailArray[myIndex]
            notificationController.message = messageArray[myIndex]
            notificationController.messageType = messageTypeArray[myIndex]
            notificationController.messageReference = messageReferenceArray[myIndex]
            notificationController.set = setArray[myIndex]
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFeedback()
        VisualEffectView.isHidden = true
        SettingsView.layer.cornerRadius = 5
        LogoutView.layer.cornerRadius = 5
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindScaleSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    @IBAction func Logout(_ sender: Any) {
        performSegue(withIdentifier: "StudentLogout", sender: self) //segues back to main page
    }
    
    var effect:UIVisualEffect!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    
    func animateInLogout () {
        self.view.addSubview(LogoutView)
        LogoutView.center = self.view.center
        self.VisualEffectView.effect = nil
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
            
        }) {(success:Bool) in
            self.LogoutView.removeFromSuperview()
        }
    }
    
    @IBOutlet var LogoutView: UIView!
    
    @IBAction func goToLogoutPopUp(_ sender: Any) {
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
        self.view.addSubview(SettingsView) //adds a new subview
        SettingsView.center = self.view.center
        SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)//applies the tranformation to pop up
        SettingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) { //fade duration of 0.4 seconds
            self.VisualEffectView.isHidden = false //shows the visual effect (blur)
            self.SettingsView.alpha = 1 //pop up becomes visible by changing the alpha
            self.SettingsView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutSettings () {
        UIView.animate(withDuration: 0.3, animations: { //fades out a bit faster
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3) //reapplies the transition
            self.SettingsView.alpha = 0 //settings view "disappears" from main view
            self.VisualEffectView.effect = nil //ensures that the visual effect is completely removed to allow interaction with main code
        }) {(success:Bool) in
            self.SettingsView.removeFromSuperview() //completely remove any interactions
        }
    }
    
    @IBOutlet var SettingsView: UIView!
    
    @IBAction func goToSettingsPopUp(_ sender: Any) {
        animateInSettings() //calles the animate in animation
        VisualEffectView.isUserInteractionEnabled = true //allows interaction with the visual effect
    }
    
    @IBAction func dismissSettings(_ sender: Any) {
        animateOutSettings() //calles the animate out
        VisualEffectView.isUserInteractionEnabled = false //disables interaction
        self.VisualEffectView.isHidden = true //hides the visual effect to stop blur effect remaining
        LogoutView.isHidden = true //hides the logout view
        LogoutView.isUserInteractionEnabled = false //stops any interaction with the logout view that may block the settings view
    }
    
}
