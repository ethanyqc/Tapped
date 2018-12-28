//
//  SignUpViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/3/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxtField: MadokaTextField!
    @IBOutlet weak var emailTxtField: MadokaTextField!
    @IBOutlet weak var pswdTxtField: MadokaTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxtField.delegate = self
        pswdTxtField.delegate = self
        nameTxtField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        
    
    //CREATE USER AND SIGN IN TO THE NEXT SCENE
    @IBAction func authButtPressed(_ sender: Any) {
        if emailTxtField.text != "" && pswdTxtField.text != "" && nameTxtField.text != "" {
            if let email = emailTxtField.text, let pswrd = pswdTxtField.text {
                Auth.auth().createUser(withEmail: email, password: pswrd, completion: { (user, error) in
                    if error == nil {//if no error in creating user
                        if let fullName = self.nameTxtField.text, let user = user {
                            
                             //MARK：add user into db
                            DataService.instance.creatDBUser(uid: user.uid, email: email, name: fullName)
                            
                    
                            print("added into database, user created and signed in")
                            //FIXME: could result bug, go to welcome page
                            self.performSegue(withIdentifier: "signUpToWelcome", sender: nil)
                        }
                        else {
                            print("no name or user")
                        }

                        
                    }
                    else{
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            
                            switch errorCode {
                            case .invalidEmail:
                                print("email not valid")
                                self.createAlertToDelete(title: "Unable to Create Account", message: "Email not valid")
                            
                            case .emailAlreadyInUse:
                                self.createAlertToDelete(title: "Unable to Create Account", message: "Email already in use")
                                
                            case .weakPassword:
                                self.createAlertToDelete(title: "Unable to Create Account", message: "Weak password")
                                
                            default:
                                self.createAlertToDelete(title: "Unexpected Error", message: "Check your connection and try again later")
                            }
                        }
                    }
                })
            }
            else {
                print("no email and pswrd")
                self.createAlertToDelete(title: "Imcomplete", message: "Fill in all the required field please")
            }
            
        }
        else {
            print("Please fill the required field")
            self.createAlertToDelete(title: "Imcomplete", message: "Fill in all the required field please")
        }
    }
    
    
    //MARK: Preapare for segue to welcome screen
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "signUpToWelcome" {
            if let welcomeVC = segue.destination as? SuccessfulViewController {
                if let fullName = self.nameTxtField.text {
                    welcomeVC.namePassed = fullName
                }
            }
            
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
