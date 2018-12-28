//
//  LogInViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/1/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects



class LogInViewController: UIViewController {

    
    @IBOutlet weak var logInEmailTxtField: MadokaTextField!
    @IBOutlet weak var logInPassTxtField: MadokaTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInCancel(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Login method
    @IBAction func logInPressed(_ sender: Any) {
        
        if logInEmailTxtField.text != "" && logInPassTxtField.text != "" {
            if let email = logInEmailTxtField.text, let pswrd = logInPassTxtField.text {
                Auth.auth().signIn(withEmail: email, password: pswrd, completion: { (user, error) in
                    if error == nil {//if no error in creating user
                        
                        //FIXME: could result bug
                        self.performSegue(withIdentifier: "logInToTable", sender: nil)
                        print("Log in success")
                        
                    }
                    else{
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            
                            switch errorCode {
                            case .invalidEmail:
                                self.createAlertToDelete(title: "Unable to Log in", message: "Invalid email")
                                
                            case .wrongPassword:
                                self.createAlertToDelete(title: "Unable to Log in", message: "Wrong password")
                                
                            case .userNotFound:
                                self.createAlertToDelete(title: "Unable to Log in", message: "User not found")
                                
                            default:
                                self.createAlertToDelete(title: "Unexpected Error", message: "Check your connection and try again later")
                            }
                        }
                    }
                })
            }
            else {
                self.createAlertToDelete(title: "Imcomplete", message: "Fill in all the required field please")
            }
            
        }
        else {
            self.createAlertToDelete(title: "Imcomplete", message: "Fill in all the required field please")
        }
    }

    func createAlertToDelete(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        self.present(alert, animated: true, completion: nil)
        
    }


}
