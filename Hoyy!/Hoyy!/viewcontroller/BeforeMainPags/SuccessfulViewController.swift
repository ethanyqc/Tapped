//
//  SuccessfulViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/4/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class SuccessfulViewController: UIViewController {
    

    @IBOutlet weak var userNameTF: MadokaTextField!
    @IBOutlet weak var signUpName: UILabel!
    var namePassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpName.text = namePassed

    }
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void) {
        
        DataService.instance.REF_USERNAMES.queryOrderedByKey().queryEqual(toValue: newUserName)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
                if snapshot.exists() {
                    completion(true)
                }
                else {
                    completion(false)
                }
            })
    }
    

    //MARK: check user name avaliability and record the username to proceed to home page.
    @IBAction func signOut(_ sender: Any) {
        //MARK: check avaliability
        if userNameTF.text != "" {
            if let username = userNameTF.text {
                self.checkUserNameAlreadyExist(newUserName: username) { isExist in
                    if isExist {
                        self.createAlertToDelete(title: "Username existed", message: "Please choose a different name")
                    }
                    else {
                        print("Username avaliable")
                        if let curUid = Auth.auth().currentUser?.uid, let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            
                            print("create new user")
                            DataService.instance.createUserNameforUser(uid: curUid, username: username)
                            DataService.instance.updateUserList(userName: username, uid: curUid)
                            
                                //MARK: update display name 
                                changeRequest.displayName = self.namePassed
                                changeRequest.commitChanges(completion: { (error) in
                                    if error == nil {//if no error in creating user
                                        
                                        print("success updating displayname")
 
                                        self.performSegue(withIdentifier: "proceed", sender: nil)
                                        
                                    }
                                    else{
                                        self.createAlertToDelete(title: "Error updating user", message: "Check your connection and try again")
                                        print(error!._code)
                                    }
                                })

                        }
                        else {
                            self.createAlertToDelete(title: "Error updating user", message: "user not authenticated, check your connection and try again")
                        }
                        
                    }
                }
            }
            else {
                self.createAlertToDelete(title: "Username Imcomplete", message: "Fill in all the required field please")
            }
        }
        else {
            self.createAlertToDelete(title: "Username Imcomplete", message: "Fill in all the required field please")
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
