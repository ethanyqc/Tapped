//
//  SearchFriendViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 3/3/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class SearchFriendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    var potentiallFriend : [AppUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.delegate = self
        searchField.becomeFirstResponder()

    }

  
    @IBAction func dismiss(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        //MARK: check avaliability
        
        if searchField.text != "" {
            if let username = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                self.checkUserNameAlreadyExist(newUserName: username, completion: { (frID) in
                    if frID == "" {
                        let leftView = UIImageView(image: #imageLiteral(resourceName: "cancel"))
                        let banner = NotificationBanner(title: "User not found! 😵", subtitle: "Check your spelling and try again", leftView: leftView, style: .warning)
                        banner.show(bannerPosition: .top)
                    }
                    else {
                        print("Username avaliable")
                        if let curUid = Auth.auth().currentUser?.uid {
                            
                            DataService.instance.REF_USER.child(frID).observeSingleEvent(of: .value, with: { (snapshot) in
                                // Get user value
                                if let value = snapshot.value as? NSDictionary {
                                    if let name = value["name"] as? String, let email = value["email"] as? String, let username = value["username"] as? String {
                                        DataService.instance.addContact(userUID: curUid, friendUID: frID, email: email, name: name, username: username)
                                        
    
                                        DataService.instance.REF_USER.child(curUid).observeSingleEvent(of: .value, with: { (snapshot) in
                                            // Get user value
                                            if let value = snapshot.value as? NSDictionary {
                                                if let name = value["name"] as? String, let email = value["email"] as? String, let username = value["username"] as? String {
                                                    DataService.instance.addContact(userUID: frID, friendUID: curUid, email: email, name: name, username: username)
                                                    
                                                    //dismiss view
                                                    self.dismiss(animated: true, completion: nil)
                                                    //show banner
                                                    let banner = NotificationBanner(title: "Hoory! 🎉", subtitle: "You have added a new friend", style: .success)
                                                    banner.show(bannerPosition: .top)
                                                }
                                            }
                                            
                                        }) { (error) in
                                            print(error.localizedDescription)
                                        }
                                        
                                    }
                                }
                                
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            
                            
                        }
                        else {
                            self.createAlert(title: "Error updating user", message: "user not authenticated, check your connection and try again")
                        }
                        
                    }
                })
                
                
            }
            else {
                self.createAlert(title: "Username Imcomplete", message: "Fill in all the required field please")
            }
        }
        else {
            self.createAlert(title: "Username Empty", message: "Fill in all the required field please")
        }
        
        
        return true
    }
    

    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(String) -> Void) {
        DataService.instance.REF_USERNAMES.queryOrderedByKey().queryEqual(toValue: newUserName)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
                if snapshot.exists() {
                    if let friendDict = snapshot.value as? NSDictionary {
                        if let id = friendDict[newUserName] as? String {
                            completion(id)
                        }
                    }
                }
                else {
                    completion("")
                    
                }
            })
    }
    
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        self.present(alert, animated: true, completion: nil)
    }
    
    

    

    
}
