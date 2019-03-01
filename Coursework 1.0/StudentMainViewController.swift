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
        VisualEffectView.isHidden = true
        
        SettingsView.layer.cornerRadius = 5
        LogoutView.layer.cornerRadius = 5
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
    
    var effect:UIVisualEffect!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    
    func animateInLogout () {
        self.view.addSubview(LogoutView)
        LogoutView.center = self.view.center
        self.VisualEffectView.effect = nil
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
            
        }) {(success:Bool) in
            self.LogoutView.removeFromSuperview()
        }
    }
    
    @IBOutlet var LogoutView: UIView!
    
    @IBAction func goToLogoutPopUp(_ sender: Any) {
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
    
    func animateOutSettings () {
        UIView.animate(withDuration: 0.3, animations: {
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.SettingsView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.SettingsView.removeFromSuperview()
        }
    }
    
    @IBOutlet var SettingsView: UIView!
    
    @IBAction func goToSettingsPopUp(_ sender: Any) {
        animateInSettings()
        VisualEffectView.isUserInteractionEnabled = true
    }
    
    @IBAction func dismissSettings(_ sender: Any) {
        animateOutSettings()
        VisualEffectView.isUserInteractionEnabled = false
        self.VisualEffectView.isHidden = true
        LogoutView.isHidden = true
        LogoutView.isUserInteractionEnabled = false
    }
    
}
