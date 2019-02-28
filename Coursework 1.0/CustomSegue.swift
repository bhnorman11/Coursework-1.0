//
//  CustomSegue.swift
//  Coursework 1.0
//
//  Created by Ben Norman on 28/02/2019.
//  Copyright © 2019 Ben Norman. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue { // class for the forward segue
    
    override func perform() {
        scale()
    }
    
    func scale () { // code to perform custom animation between views
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
        
    }

}

class UnwindScaleSegue: UIStoryboardSegue { // class for the backward segue
    override func perform() {
        scale()
    }
    
    func scale () { // code to perform custom animation between views
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }, completion: { success in
            fromViewController.dismiss(animated: false, completion: nil)
        })
        
    }
}
