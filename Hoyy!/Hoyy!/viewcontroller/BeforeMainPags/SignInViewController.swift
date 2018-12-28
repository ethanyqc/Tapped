//
//  ViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 12/31/17.
//  Copyright © 2017 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {


    @IBOutlet weak var logInConstriant: NSLayoutConstraint!
    @IBOutlet weak var signUpConstriant: NSLayoutConstraint!
    let slideAnimator = SlideAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        logInConstriant.constant -= view.bounds.width
        signUpConstriant.constant -= view.bounds.width

        
        
    }
    
    
    
    var buttonMovedOnce = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "logInDirectly", sender: nil)
            
        }
        else {
            
            if !buttonMovedOnce {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.signUpConstriant.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                
                UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                    self.logInConstriant.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                buttonMovedOnce = true
                           
            }
            
        }
        

        
    }

    
    


}

