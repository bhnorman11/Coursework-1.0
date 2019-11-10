//
//  JoinClassViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 10/11/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class JoinClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Error.isHidden = true
    }
    
    @IBOutlet weak var Code: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    @IBAction func Continue(_ sender: Any) {
    }
    
    func validateEntry(){
        if Code.text!.count != 8 {
            Error.isHidden = false
        }
    }

}
