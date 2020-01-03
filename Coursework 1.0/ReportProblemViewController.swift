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
    
    func getClasses() {
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ChosenClass.text = classesArray[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Successful.isHidden = true
        getClasses()
        getTeacherEmail()
    }
    
    @IBOutlet weak var Successful: UILabel!
    @IBOutlet weak var Problem: UITextField!
    @IBOutlet weak var ChosenClass: UILabel!
    
    
    func EmptyField() -> Bool{
        if (Problem.text == "") || (ChosenClass.text == "") { //performs a presence check
            Successful.textColor = .red
            Successful.text = "Please write your problem and choose a class."
            Successful.isHidden = false //displays error message
            return true
        }
        else {
            return false
        }
    }
    
    func checkProblemTooLong() -> Bool{
        var counter = 0
        for _ in Problem.text! {
            counter += 1 //finds the length of the entered text
        }
        if counter > 100 { //if it exceeds 100 characters, an error message is displayed
            Successful.textColor = .red
            Successful.text = "Maximum: 150 characters."
            Successful.isHidden = false
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
    
    func getTeacherEmail() -> String {
        var teacherEmail = ""
        let email = user?.email //sets email to email used to login/sign up with
        let docRef = self.db.collection("Users").document(email!).collection("Classes").document(self.ChosenClass.text!) //creates a document reference in order to reference and read a document in Firestore
        print(docRef)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document, document.exists{
                teacherEmail = (document.get("Teacher email") as! String) //reads the teacher email field in Firestore
            }
            else{
                print("Document does not exist in firestore") //the case when the document does not exist
            }
        }
        print(teacherEmail)
        return teacherEmail
    }
    
    @IBAction func sendData(_ sender: Any) {
        if (checkProblemTooLong() == false) && (EmptyField() == false) { //ensures checks have been made
            let email = user?.email //sets email to email used to login/sign up with
            let reference = generateFeedbackReference()
            var teacherEmail = ""
            let docRef = self.db.collection("Users").document(email!).collection("Classes").document(self.ChosenClass.text!) //creates a document reference in order to reference and read a document in Firestore
            print(docRef)
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document, document.exists{
                    teacherEmail = (document.get("Teacher email") as! String) //reads the teacher email field in Firestore
                    let newTeacherEmail = teacherEmail
                    self.db.collection("Users").document(newTeacherEmail).collection("Classes").document(self.ChosenClass.text!).collection("Feedback").document(reference).setData([ //inserts data into the teachers Firebase, giving message contents, type and which student sent it
                        "Message": self.Problem.text!,
                        "Message Type": "Problem",
                        "Student Email": email!
                        ])
                    { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
                else{
                    print("Document does not exist in firestore") //the case when the document does not exist
                }
            }
            self.Successful.text = "Problem reported!"
            self.Successful.textColor = .blue
            self.Successful.isHidden = false
            self.Problem.text = ""
            self.ChosenClass.text = ""
        }
    }
    
    
}

