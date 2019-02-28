//
//  StudentMainViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 27/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class StudentMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func prepareforUnwind (segue: UIStoryboardSegue) {
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindScaleSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    @IBAction func Logout(_ sender: Any) {
        performSegue(withIdentifier: "StudentLogout", sender: self)
    }
    
    
}
