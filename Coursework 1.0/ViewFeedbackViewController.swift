//
//  ViewFeedbackViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 28/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class ViewFeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count //sets number of row to the number of element in student array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel?.text = studentArray[indexPath.row]
        return cell //returns the cell created with the information from studentArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //only 1 section in the table
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var StudentEmail: UITextField!
    var studentArray = [String]()
    @IBOutlet weak var studentTable: UITableView!
    
    @IBAction func AddStudent(_ sender: Any) {
        studentArray.append(StudentEmail.text!) //appends the student email entered to the studentArray
        self.studentTable.reloadData() //reloads the table so the new students are reloaded
        StudentEmail.text = "" //resets the text box to an empty string
    }
    
    
    
}
