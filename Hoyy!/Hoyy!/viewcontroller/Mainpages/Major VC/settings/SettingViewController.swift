//
//  SettingViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/9/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    var shareText = "CHECK HOO OUT!!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    //MARK: function to check if username exist
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

    

    @IBAction func block(_ sender: Any) {
        print(Messaging.messaging().fcmToken!)
    }
    
    

    //MARK: share on social metdia
    @IBAction func share(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
 
    }
    
    
    //MARK: logout function
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            DataService.instance.removeKey(curUid: (firebaseAuth.currentUser?.uid)!, key: Messaging.messaging().fcmToken!)
            try firebaseAuth.signOut()
            print("successful signout")
            self.performSegue(withIdentifier: "backHome", sender: nil)
            //MARK: remove observer
            DataService.instance.removeObserverUser()
            
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }

    


}
