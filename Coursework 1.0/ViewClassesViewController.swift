//
//  ViewClassesViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 08/03/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var setArray = [String]()
    var yearArray = [String]()
    var subjectArray = [String]()
    var codeArray = [String]()
    var studentArray = [String]()
    var myIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = setArray[indexPath.row] //creates a cell using each member of the messageType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row //sets myIndex to the index of the selected row
        performSegue(withIdentifier: "classSegue", sender: self) //performs the segue to view the selected class
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete { //if the user swipes left and clicks on delete
            let email = user?.email //sets email to the current users email
            db.collection("Users").document(email!).collection("Classes").document(setArray[myIndex]).delete() { err in //deletes the document from the Codes collection to save memory
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            getStudents() //calls getStudents function to populate the studentArray
            for student in studentArray {
                db.collection("Users").document(student).collection("Classes").document(setArray[myIndex]).delete() { err in //for each student in the student array, the selected set is deleted from their Classes in Firestore
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
            self.setArray.remove(at: self.myIndex) //removes all details of that deleted set from each individual array
            self.subjectArray.remove(at: self.myIndex)
            self.yearArray.remove(at: self.myIndex)
            self.codeArray.remove(at: self.myIndex)
            self.tableView.reloadData()
        }
    }
    
    func getStudents() { //populates the studentArray with students from a particular set in Firestore
        let email = user?.email //sets email to the current users email
        db.collection("Users").document(email!).collection("Classes").document(setArray[myIndex]).collection("Students").getDocuments() { (querySnapshot, err) in //gets all students in the selected set from Firestore
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let studentEmail = document.documentID //sets the studentEmail to the name of the document in Firestore
                    self.studentArray.append(studentEmail) //appends that email to the studentArray
                }
            }
        }
    }
   
    func getSets() { //populates the set array with all of the logged in teachers sets from Firestore
        let email = user?.email //sets email to the current users email
        db.collection("Users").document(email!).collection("Classes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents { //loops through each set to get the details of that set
                    let set = document.documentID //sets constants to each field in Firestore
                    let subject = (document.get("Subject") as! String)
                    let year = (document.get("Block") as! String)
                    let code = (document.get("Code") as! String)
                    self.setArray.append(set) //appends each constant to the appropriate array
                    self.subjectArray.append(subject)
                    self.yearArray.append(year)
                    self.codeArray.append(code)
                    DispatchQueue.main.async {
                        self.tableView.reloadData() //updates the table view with the teacher's sets
                    }
                }
            }
        }
    }
    
    func sortSets() { //insertion sort to sort the sets in alphabetical order
        for i in 1..<setArray.count {
            let temp = setArray[i]
            var j = i - 1
            while j >= 0 {
                if temp < setArray[j] {
                    setArray[j+1] = setArray[j]
                    j -= 1
                } else {
                    break
                }
            }
            setArray[j+1] = temp
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        getStudents() //makes sure the array of students is up to date
        if segue.identifier == "classSegue" { //only performs code if the segue is going to view the selected class
            let notificationController = segue.destination as! EditClassesViewController //sets the destination view controller
            notificationController.subject = subjectArray[myIndex] //sets values in the destination view controller to the values read from Firestore
            notificationController.year = yearArray[myIndex]
            notificationController.code = codeArray[myIndex]
            notificationController.set = setArray[myIndex]
            notificationController.studentArray = studentArray
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSets() //function is called to populate the table view on entrance of the view
    }
    

}
