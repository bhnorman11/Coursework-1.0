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
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        PopUpView.layer.cornerRadius = 5
        VisualEffectView.isHidden = true
    }
    
    
    @IBOutlet weak var NoClassFound: UILabel!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    var effect: UIVisualEffect!
    @IBOutlet weak var Code: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    func animateIn () {
        self.view.addSubview(PopUpView)
        PopUpView.center = self.view.center
        self.VisualEffectView.effect = nil
        PopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        PopUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.PopUpView.alpha = 1
            self.PopUpView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.PopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.PopUpView.alpha = 0
            
        }) {(success:Bool) in
            self.PopUpView.removeFromSuperview()
        }
    }
    
    @IBAction func Continue(_ sender: Any) {
        if validateEntry() == true {
            animateIn()
            
        }
    }
    @IBAction func DismissPopUp(_ sender: Any) {
        animateOut()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    func validateEntry() -> Bool{
        if Code.text!.count != 8 {
            Error.isHidden = false
            return false
        }
        else{
            return true
        }
    }

}
