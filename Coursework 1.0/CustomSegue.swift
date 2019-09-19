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
        let toViewController = self.destination //destination of segue
        let fromViewController = self.source //view being segued from
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05) //transforms the view into the destination
        toViewController.view.center = originalCenter //centers the segue
        containerView?.addSubview(toViewController.view)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity //type of segue being performed "curveEaseInOut": animation starts slowly, accelerates, then slows down
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil) //view controller being travelled to is presented
        })
    }
}

class UnwindScaleSegue: UIStoryboardSegue { // class for the backward segue
    override func perform() {
        scale()
    }
    func scale () { // code to perform custom animation between views
        let toViewController = self.destination //destination of the segue
        let fromViewController = self.source //view that you are seguing from
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }, completion: { success in
            fromViewController.dismiss(animated: false, completion: nil)
        })
        
    }
}
