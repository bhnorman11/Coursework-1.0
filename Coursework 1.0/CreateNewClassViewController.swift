//
//  CreateNewClassViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 01/03/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateNewClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel?.text = studentArray[indexPath.row]
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var StudentEmail: UITextField!
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Block: UITextField!
    @IBOutlet weak var Set: UITextField!
    @IBOutlet weak var studentTable: UITableView!
    var studentArray = [String]()
    
    @IBAction func AddStudent(_ sender: Any) {
        studentArray.append(StudentEmail.text!)
        self.studentTable.reloadData()
        StudentEmail.text = ""
    }
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBAction func CreateClass(_ sender: Any) {
        let email = user?.email
        db.collection("Teachers").document(email!).collection("Classes").document(Set.text!).setData([
            "Block": Block.text!,
            "Subject": Subject.text!
        ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        for i in 0...studentArray.count - 1 {
            db.collection("Teachers").document(email!).collection("Classes").document(Set.text!).collection("Students").document(studentArray[i]).setData([
                "Email": studentArray[i],
            ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    
                }
            }
        }
        
    }
    
}
