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
        VisualEffectView.isHidden = true
        SettingsView.layer.cornerRadius = 5
        LogoutView.layer.cornerRadius = 5
    }
    
    func animateInLogout () {
        self.view.addSubview(LogoutView)
        LogoutView.center = self.view.center
        LogoutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        LogoutView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.LogoutView.alpha = 1
            self.LogoutView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutLogout () {
        UIView.animate(withDuration: 0.3, animations: {
            self.LogoutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.LogoutView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.LogoutView.removeFromSuperview()
        }
    }
    
    @IBAction func LogoutConfirmed(_ sender: Any) {
        performSegue(withIdentifier: "Logout", sender: self)
    }
    
    @IBAction func Logout(_ sender: Any) {
        animateInLogout()
        LogoutView.isUserInteractionEnabled = true
        LogoutView.isHidden = false
        VisualEffectView.isUserInteractionEnabled = true
    }
    
    @IBAction func cancelLogout(_ sender: Any) {
        animateOutLogout()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
    }
    
    func animateInSettings () {
        self.view.addSubview(SettingsView)
        SettingsView.center = self.view.center
        SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        SettingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.isHidden = false
            self.SettingsView.alpha = 1
            self.SettingsView.transform = CGAffineTransform.identity
        }
    }
    
    var effect:UIVisualEffect!
    
    func animateOutSettings () {
        UIView.animate(withDuration: 0.3, animations: {
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.SettingsView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.SettingsView.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    
    @IBOutlet var LogoutView: UIView!
    @IBOutlet var SettingsView: UIView!
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOutSettings()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
        LogoutView.isHidden = true
        LogoutView.isUserInteractionEnabled = false
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        animateInSettings()
        VisualEffectView.isUserInteractionEnabled = true
    }
    
}
