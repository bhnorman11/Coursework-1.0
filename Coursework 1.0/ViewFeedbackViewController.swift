//
//  ViewFeedbackViewController.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 28/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class ViewFeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        VisualEffectView.isHidden = true
        
        settingsView.layer.cornerRadius = 5
    }
    
    func animateIn () {
        self.view.addSubview(settingsView)
        settingsView.center = self.view.center
        
        settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        settingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.settingsView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.settingsView.removeFromSuperview()
        }
    }
    
    
    var effect:UIVisualEffect!
    
    @IBOutlet var settingsView: UIView!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    
 
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    
    @IBAction func goToSettings(_ sender: Any) {
        animateIn()
        VisualEffectView.isUserInteractionEnabled = true
    }
    
}
