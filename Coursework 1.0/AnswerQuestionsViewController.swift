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
    
    @IBOutlet var TimesButtons: [UIButton]!
    
    @IBOutlet weak var Today: UIButton!
    @IBOutlet weak var Yesterday: UIButton!
    @IBOutlet weak var ThisWeek: UIButton!
    @IBOutlet weak var ThisMonth: UIButton!
    @IBOutlet weak var ThisTerm: UIButton!
    
    func DateToday() -> String{ // gets todays date and time
        let dateToday = "\(NSDate())"
        return dateToday
    }
    
    func DateYesterday() -> String { // gets yesterdays date and time
        let yesterday = "\(Calendar.current.date(byAdding: .day, value: -1, to: Date())!)"
        return yesterday
        
    }
    
    @IBAction func TodaySelection(_ sender: Any) {
        Today.alpha = 1 // changes the alpha (transparency setting) when one of the options is selected
        Yesterday.alpha = 0.3
        ThisWeek.alpha = 0.3
        ThisMonth.alpha = 0.3
        ThisTerm.alpha = 0.3
    }
    
    @IBAction func YesterdaySelection(_ sender: Any) {
        Today.alpha = 0.3
        Yesterday.alpha = 1
        ThisWeek.alpha = 0.3
        ThisMonth.alpha = 0.3
        ThisTerm.alpha = 0.3
    }
    
    @IBAction func ThisWeekSelection(_ sender: Any) {
        Today.alpha = 0.3
        Yesterday.alpha = 0.3
        ThisWeek.alpha = 1
        ThisMonth.alpha = 0.3
        ThisTerm.alpha = 0.3
    }
    
    @IBAction func ThisMonthSelection(_ sender: Any) {
        Today.alpha = 0.3
        Yesterday.alpha = 0.3
        ThisWeek.alpha = 0.3
        ThisMonth.alpha = 1
        ThisTerm.alpha = 0.3
    }
    
    @IBAction func ThisTermSelection(_ sender: Any) {
        Today.alpha = 0.3
        Yesterday.alpha = 0.3
        ThisWeek.alpha = 0.3
        ThisMonth.alpha = 0.3
        ThisTerm.alpha = 1
    }
    
    @IBOutlet weak var QuestionOne: UITextField!
    @IBOutlet weak var QuestionTwo: UITextField!
    @IBOutlet weak var QuestionThree: UITextField!
    @IBOutlet weak var Successful: UILabel!
    
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    
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
