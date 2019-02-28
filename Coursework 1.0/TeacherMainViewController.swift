//
//  TeacherMainViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 27/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class TeacherMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Logout(_ sender: Any) {
        performSegue(withIdentifier: "TeacherLogout", sender: self)
    }
    
    
}
