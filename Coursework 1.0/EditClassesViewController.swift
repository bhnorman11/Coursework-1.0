//
//  EditClassesViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 04/01/2020.
//  Copyright © 2020 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditClassesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = studentArray[indexPath.row] //creates a cell using each member of the student array
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let email = user?.email
            db.collection("Users").document(email!).collection("Classes").document(set).collection("Students").document(studentArray[myIndex]).delete() { err in //deletes the student from the teacher's student collection
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            db.collection("Users").document(studentArray[myIndex]).collection("Classes").document(set).delete() { err in
                if let err = err { //deletes the set from the students Classes collection in Firestore
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            self.studentArray.remove(at: self.myIndex) //removes that student from the studentArray
            self.tableView.reloadData() //reloads the table data
        }
    }
    
    func sortStudents() { //uses an insertion sort to sort the order of the students in alphabetical order
        for i in 1..<studentArray.count {
            let temp = studentArray[i]
            var j = i - 1
            while j >= 0 {
                if temp < studentArray[j] {
                    studentArray[j+1] = studentArray[j]
                    j -= 1
                } else {
                    break
                }
            }
            studentArray[j+1] = temp
        }
    }
    
    override func viewDidLoad() { //sets all labels to passed in data about the set and displays them
        super.viewDidLoad()
        setLabel.text = set
        subjectLabel.text = subject
        yearLabel.text = year
        codeLabel.text = code
        setLabel.isHidden = false
        subjectLabel.isHidden = false
        yearLabel.isHidden = false
        codeLabel.isHidden = false
        
    }
    
    var code = String()
    var subject = String()
    var set = String()
    var year = String()
    var studentArray = [String]()
    var myIndex = 0

    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
}
