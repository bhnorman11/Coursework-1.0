//
//  SignUpViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 26/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    @IBOutlet weak var BlockLabel: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Block: UITextField!
    @IBOutlet weak var Error: UILabel!
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    func emptyFields() -> Bool { 
        if Email.text == "" {
            Error.text = "Please input your email address."
            Error.isHidden = false
            return true
        }
        else if Password.text == "" {
            Error.text = "Please input your password."
            Error.isHidden = false
            return true
        }
        else if ConfirmPassword.text == "" {
            Error.text = "Please input your confirmed password."
            Error.isHidden = false
            return true
        }
        else if FirstName.text == "" {
            Error.text = "Please input your first name."
            Error.isHidden = false
            return true
        }
        else if LastName.text == "" {
            Error.text = "Please input your last name."
            Error.isHidden = false
            return true
        }
        else if (Block.text == "") && (Teacher.alpha != 1.0){
            Error.text = "Please input your block."
            Error.isHidden = false
            return true
        }
        else {
            return false
        }
    }
    
    func validEmail() -> Bool {
        var atSymbol = false
        var fullStop = false
        for character in Email.text! {
            if character == "@"{ //format check for @ symbol
                atSymbol = true
            }
            else if character == "." { //format check for .
                fullStop = true
            }
        }
        if atSymbol == false {
            Error.text = "Please include an @ symbol in your email."
            Error.isHidden = false //displayed error message
            return false
        }
        else if fullStop == false {
            Error.text = "Please include a full stop in your email."
            Error.isHidden = false //displayed error message
            return false
        }
        else {
            return true
        }
    }
    
    func selectedStudentOrTeacher () -> Bool {
        if (Student.alpha == 1.0) && (Teacher.alpha == 1.0) { //ensures that at least one of student or teacher has been selected
            Error.text = "Please select whether you're a student or a teacher."
            Error.isHidden = false
            return false
        }
        else {
            return true
        }
    }
    
    func validYear() -> Bool {
        if (Block.text != "13") && (Block.text != "12") && (Block.text != "11") && (Block.text != "10") && (Block.text != "9") && (Teacher.alpha != 1.0) { //performs format check
            Error.text = "Please select 13, 12, 11, 10 or 9 as your year."
            Error.isHidden = false //error message is displayed
            return false
        }
        else {
            return true
        }
    }
    
    func confirmPassword() -> Bool{
        if ConfirmPassword.text == Password.text { //performs format check on the re-entered passwords, ensuring they match
            return true
        }
        else{
            Error.text = "Your passwords do not match."
            Error.isHidden = false //displays error message
            return false
        }
    }
    
    func validPassword() -> Bool{
        var counter = 0
        var containsNumber = false
        var containsCharacter = false
        var containsCapital = false
        let symbols = "!@#$%^&*()-_=+][{};:'/.,<>`~"
        let capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for character in Password.text! {
            counter += 1
            if (character == "0") || (character == "1") || (character == "2") || (character == "3") || (character == "4") || (character == "5") || (character == "6") || (character == "7") || (character == "8") || (character == "9") { //performs format check for numbers
                containsNumber = true
            }
            for symbol in symbols {
                if character == symbol { //performs format check for symbols
                    containsCharacter = true
                }
            }
            for capitalLetter in capitalLetters {
                if character == capitalLetter { //performs format check for capital letters
                    containsCapital = true
                }
            }
        }
        if counter < 8 { //performs length check on password
            Error.text = "Password length must be greater than 7."
            Error.isHidden = false
        }
        if containsNumber == false {
            Error.text = "Please put a number in your password."
            Error.isHidden = false
        }
        if containsCharacter == false {
            Error.text = "Please use a symbol in your password."
            Error.isHidden = false
        }
        if containsCapital == false {
            Error.text = "Please put a capital letter in your password."
            Error.isHidden = false
        }
        if (containsNumber == true) && (counter >= 8) && (containsCharacter == true) && (containsCapital == true) { //returns true if all password conditions are met
            return true
        }
        else {
            return false //otherwise the password is declared invalid
        }
        
    }
    
    func checkValidInputs() -> Bool {
        if (emptyFields() == false) && (validEmail() == true) && (selectedStudentOrTeacher() == true) && (validYear() == true) && (confirmPassword() == true) && (validPassword() == true) {
            return true //ensures that all fields on sign up have been entered validly before proceeding.
        }
        else {
            return false
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        if checkValidInputs() == true {
            if Student.alpha == 1.0 { //checks if student has been selected
                Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in //creates a user with the email address given on sign up
                    if error != nil{
                        print(error!) //process is terminated if an error is discovered
                    }else{
                        self.db.collection("Users").document(self.Email.text!).setData([ //creates a new document and sets the information to the data entered
                            "Student": true,
                            "First Name": self.FirstName.text!,
                            "Second Name": self.LastName.text!,
                            "Block": self.Block.text!]) //since student has been selected, year goes to Firestore
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                })
                self.performSegue(withIdentifier: "StudentSignUp", sender: self) //performs a segue to the student home page
            }
            else if Student.alpha != 1.0 { //same code as above
                Auth.auth().createUser(withEmail: Email.text!, password: Password.text!, completion: {(user, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        self.db.collection("Users").document(self.Email.text!).setData([
                            "Student": false,
                            "First Name": self.FirstName.text!,
                            "Last Name": self.LastName.text!]) //teacher has no year group, so not stored in Firestore
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                })
                self.performSegue(withIdentifier: "TeacherSignUp", sender: self) //performs segue to the teacher home page
            }
        }
    }
    
    let db = Firestore.firestore()
    
    @IBOutlet var peopleButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: Any) { //handles animation for the selection of student or teacher on sign up
        peopleButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    @IBOutlet weak var Student: UIButton!
    @IBOutlet weak var Teacher: UIButton!
    
    @IBAction func StudentSelect(_ sender: Any) { //if the user selects the student button
        Teacher.alpha = 0.3 //lowers the teacher transparency
        Student.alpha = 1.0 //raises the student transparency
        Block.isHidden = false
        BlockLabel.isHidden = false //shows the year so that the student can input their year
    }
    @IBAction func TeacherSelect(_ sender: Any) {
        Student.alpha = 0.3
        Teacher.alpha = 1.0
        Block.isHidden = true
        BlockLabel.isHidden = true //hides the year as the teacher has no need to input a year
    }
    
    
    
}
