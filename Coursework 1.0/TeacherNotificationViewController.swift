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

    override func viewDidLoad() {
        super.viewDidLoad()
        StudentLabel.text = studentEmail
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
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func generateFeedbackReference() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //all alphanumeric characters
        let reference = String((0..<12).map{ _ in characters.randomElement()!}) //creates a random string of length 8 by mapping the characters and selecting a random element of this 12 times.
        return reference //returns a unique reference that can be used to store the document in firestore
    }
    
    func emptyField() -> Bool {
        if ReplyText.text == "" {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func Send(_ sender: Any) {
        if emptyField() == false {
            let email = user?.email
            db.collection("Users").document(studentEmail).collection("Classes").document(set).collection("Feedback").document(generateFeedbackReference()).setData([
                "Message": ReplyText.text!,
                "Teacher Email": email!,
                "Message Type": messageType
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
