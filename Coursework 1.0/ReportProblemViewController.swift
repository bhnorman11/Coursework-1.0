//
//  ReportProblemViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 30/01/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ReportProblemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    var classesArray = [String]()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func getClasses() { //retrieves all documents in Firestore and loops through them, finding each set
        let email = user?.email
        db.collection("Users").document(email!).collection("Classes").getDocuments() { (querySnapshot, err) in //retrieves all the classes from the registered student
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents { //loops through each document
                    let className = document.documentID //reads the names of the document (as it is the set)
                    self.classesArray.append(className) //appends to class array
                }
                DispatchQueue.main.async {
                        self.pickerView.reloadAllComponents() //reloads the picker view with the newly retrieved data
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //returns how many rows are in the picker view
        return classesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //sets all rows values to members of the classesArray
        return classesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //sets the chosen class to the class selected in the picker view
        ChosenClass.text = classesArray[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Successful.isHidden = true
        getClasses() //gets all sets so the student can pick which one straight away
    }
    
    @IBOutlet weak var Successful: UILabel!
    @IBOutlet weak var Problem: UITextField!
    @IBOutlet weak var ChosenClass: UILabel!
    
    
    func EmptyField() -> Bool{ //performs a presence check on the chosen class and the text box
        if (Problem.text == "") || (ChosenClass.text == "") {
            Successful.textColor = .red
            Successful.text = "Please write your problem and choose a class."
            Successful.isHidden = false //displays error message
            return true
        }
        else {
            return false
        }
    }
    
    func checkProblemTooLong() -> Bool{ //ensures that the message sent does not exceed 300 characters
        var counter = 0
        for _ in Problem.text! {
            counter += 1 //finds the length of the entered text by adding 1 for each character looped through
        }
        if counter > 300 { //if it exceeds 300 characters, an error message is displayed
            Successful.textColor = .red
            Successful.text = "Maximum: 300 characters."
            Successful.isHidden = false //displays error message
            return true
        }
        else {
            return false
        }
    }
    
    func generateFeedbackReference() -> String { //returns a unique reference that can be used to store the document in firestore
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //all alphanumeric characters
        let reference = String((0..<12).map{ _ in characters.randomElement()!}) //creates a random string of length 12 by mapping the characters and selecting a random element 12 times
        return reference
    }
    
    func getTeacherEmail() -> String { //reads the student's chosen set to retrieve the teacher's email address
        var teacherEmail = ""
        let email = user?.email //sets email to email used to login/sign up with
        let docRef = self.db.collection("Users").document(email!).collection("Classes").document(self.ChosenClass.text!) //creates a document reference in order to read the set
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document, document.exists{
                teacherEmail = (document.get("Teacher email") as! String) //reads the teacher email field in Firestore
            }
            else{
                print("Document does not exist in firestore") //the case when the document does not exist
            }
        }
        return teacherEmail
    }
    
    @IBAction func sendData(_ sender: Any) { //writes a new document in the teacher's feedback collection
        if (checkProblemTooLong() == false) && (EmptyField() == false) { //ensures checks have been made
            let email = user?.email //sets email to email used to login/sign up with
            let reference = generateFeedbackReference() //generates reference to store feedback with
            let teacherEmail = self.getTeacherEmail() //sets the teacherEmail to the result of the function
            self.db.collection("Users").document(teacherEmail).collection("Classes").document(self.ChosenClass.text!).collection("Feedback").document(reference).setData([ //creates a new feedback document in the teacher's feedback class within the given set
                "Message": self.Problem.text!, //feedback being sent
                "Message Type": "Problem", //tells the teacher what type of feedback the student is sending
                "Student Email": email! //tells the teacher which student is responding
                ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                }
            }
            self.Successful.text = "Problem reported!"
            self.Successful.textColor = .blue
            self.Successful.isHidden = false //reveals the successful message
            self.Problem.text = ""
            self.ChosenClass.text = "" //resets the fields to empty strings ready to accept more feedback
        }
    }
    
    
}

