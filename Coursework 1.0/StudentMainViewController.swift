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
        self.view.addSubview(SettingsView) //adds a new subview
        SettingsView.center = self.view.center
        SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3) //applies the tranformation to the pop up setting
        SettingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) { //fade duration of 0.4 seconds
            self.VisualEffectView.isHidden = false //shows the visual effect (blur)
            self.SettingsView.alpha = 1 //pop up becomes visible by changing the alpha
            self.SettingsView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutSettings () {
        UIView.animate(withDuration: 0.3, animations: { //fades out a bit faster
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3) //reapplies the transition
            self.SettingsView.alpha = 0 //settings view "disappears" from main view
            self.VisualEffectView.effect = nil //ensures that the visual effect is completely removed to allow interaction with main code
        }) {(success:Bool) in
            self.SettingsView.removeFromSuperview() //completely remove any interactions
        }
    }
    
    @IBOutlet var SettingsView: UIView!
    
    @IBAction func goToSettingsPopUp(_ sender: Any) {
        animateInSettings() //calles the animate in animation
        VisualEffectView.isUserInteractionEnabled = true //allows interaction with the visual effect
    }
    
    @IBAction func dismissSettings(_ sender: Any) {
        animateOutSettings() //calles the animate out
        VisualEffectView.isUserInteractionEnabled = false //disables interaction
        self.VisualEffectView.isHidden = true //hides the visual effect to stop blur effect remaining
        LogoutView.isHidden = true //hides the logout view
        LogoutView.isUserInteractionEnabled = false //stops any interaction with the logout view that may block the settings view
    }
    
}
