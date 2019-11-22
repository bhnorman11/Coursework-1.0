//
//  AnswerQuestionsViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class AnswerQuestionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TimesButtons.forEach { (button) in
            button.isHidden = !button.isHidden // hides all the different time buttons when view loads
        }
        Successful.isHidden = true

    }
    
    @IBAction func HandleSelection(_ sender: Any) { // used to display time period buttons in stack view with nice animation
        TimesButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func DateToday() -> String{ // gets todays date and time
        let dateToday = "\(NSDate())"
        return dateToday
    }
    
    func DateYesterday() -> String { // gets yesterdays date and time
        let yesterday = "\(Calendar.current.date(byAdding: .day, value: -1, to: Date())!)"
        return yesterday
    }
    
    @IBOutlet weak var QuestionOne: UITextField!
    @IBOutlet weak var QuestionTwo: UITextField!
    @IBOutlet weak var QuestionThree: UITextField!
    @IBOutlet weak var Successful: UILabel!
    
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    func EmptyField() -> Bool{ //Makes sure all fields are filled in
        if (QuestionOne.text == "") && (QuestionTwo.text == "") && (QuestionThree.text == "") {
            Successful.textColor = .red
            Successful.text = "Please fill in one or more answers."
            Successful.isHidden = false //Successful message becomes an error message
            return true
        }
        else {
            return false
        }
    }
    
    func checkSuggestionTooLong() -> Bool{
        var counter = 0
        for character in QuestionOne.text!.characters {
            counter += 1
        }
        if counter > 100 {
            Successful.textColor = .red
            Successful.text = "Maximum of 150 characters."
            Successful.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    
    @IBAction func Send(_ sender: Any) {
        let email = user?.email
        db.collection("Answers").document(email!).setData([
            "Answer 1": QuestionOne.text!,
            "Answer 2": QuestionTwo.text!,
            "Answer 3": QuestionThree.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.Successful.isHidden = false
            }
        }
    }
    

}
