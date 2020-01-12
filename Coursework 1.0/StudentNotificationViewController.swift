//
//  StudentNotificationViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 03/01/2020.
//  Copyright © 2020 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class StudentNotificationViewController: UIViewController {

    override func viewDidLoad() { //set labels to values passed in from student main through the prepare for segue
        super.viewDidLoad()
        TeacherLabel.text = teacherEmail //sets labels to passed in values from the student home page
        MessageLabel.text = message
        SetLabel.text = set
    }
    
    var teacherEmail = String()
    var message = String()
    var messageType = String()
    var messageReference = String()
    var set = String()
    @IBOutlet weak var SetLabel: UILabel!
    @IBOutlet weak var TeacherLabel: UILabel!
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var ReplyText: UITextField!
    @IBOutlet weak var Successful: UILabel!
    @IBOutlet weak var Error: UILabel!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func generateFeedbackReference() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //all alphanumeric characters
        let reference = String((0..<12).map{ _ in characters.randomElement()!}) //creates a random string of length 8 by mapping the characters and selecting a random element of this 12 times.
        return reference //returns a unique reference that can be used to store the document in firestore
    }
    
    func emptyField() -> Bool { //presence check for the replyText
        if ReplyText.text == "" { //if there is no text
            Error.text = "Please write your reply."
            Error.isHidden = false //reveal error message
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func Send(_ sender: Any) {
        if emptyField() == false { //if validation is passed
            let email = user?.email //sets email to current users email
            db.collection("Users").document(teacherEmail).collection("Classes").document(set).collection("Feedback").document(generateFeedbackReference()).setData([ //creates a new feedback document in the teacher's feedback class within the given set
                "Message": ReplyText.text!, //teacher's feedback
                "Student Email": email!, //tells the student which teacher is responding
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
