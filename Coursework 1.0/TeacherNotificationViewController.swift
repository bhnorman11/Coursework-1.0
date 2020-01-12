//
//  TeacherNotificationViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 01/01/2020.
//  Copyright © 2020 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TeacherNotificationViewController: UIViewController {

    override func viewDidLoad() { //set labels to values passed in from teacher main through the prepare for segue
        super.viewDidLoad()
        StudentLabel.text = studentEmail //sets labels to passed in values from the teacher home page
        MessageLabel.text = message
        SetLabel.text = set
    }
    
    var studentEmail = String()
    var message = String()
    var messageType = String()
    var messageReference = String()
    var set = String()
    @IBOutlet weak var StudentLabel: UILabel!
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var SetLabel: UILabel!
    @IBOutlet weak var Successful: UILabel!
    @IBOutlet weak var ReplyText: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func emptyField() -> Bool { //presence check in reply field
        if ReplyText.text == "" { //checks against an empty string
            Error.text = "Please write your reply."
            Error.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func replyTooLong() -> Bool { //length check of reply field
        var counter = 0
        for _ in ReplyText.text! { //counts the length of the comment
            counter += 1
        }
        if counter > 300 { //if the comment exceeds 300 characters, error message appears
            Error.text = "Maximum: 300 characters"
            Error.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func generateFeedbackReference() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //all alphanumeric characters
        let reference = String((0..<12).map{ _ in characters.randomElement()!}) //creates a random string of length 8 by mapping the characters and selecting a random element of this 12 times.
        return reference //returns a unique reference that can be used to store the document in firestore
    }
    
    @IBAction func Send(_ sender: Any) { //creates a new document in the student's feedback collection with the response of the teacher
        if (emptyField() == false) && (replyTooLong() == false) {
            let email = user?.email //email of the current user
            let reference = generateFeedbackReference() //generates a reference that the document will use to be stored in Firestore
            db.collection("Users").document(studentEmail).collection("Classes").document(set).collection("Feedback").document(reference).setData([ //creates a new feedback document in the student's feedback class within the given set
                "Message": ReplyText.text!, //teacher's feedback
                "Teacher Email": email!, //tells the student which teacher is responding
                "Message Type": messageType //tells the student what type of feedback their inital feedback was
                ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                    self.Successful.isHidden = false //displays successful reply
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { //delays segue
                        self.performSegue(withIdentifier: "exitNotification", sender: self) //calls segue when the reply is sent
                    }
                }
            }
        }
    }
    
}
