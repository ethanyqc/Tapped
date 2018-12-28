//
//  BlockViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/10/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase

class BlockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var allFriend : [AppUser] = []
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    override func viewDidLoad() {
        super.viewDidLoad()

        if let curUid = Auth.auth().currentUser?.uid {

            
            //MARK: Snapshoting the contact of current users
            DataService.instance.REF_CONTACT.child(curUid).observe(.childAdded) {(snapshot) in
                if let friendDict = snapshot.value as? NSDictionary {
                    if let name = friendDict["name"] as? String, let email = friendDict["email"] as? String, let username = friendDict["username"] as? String {
                        
                        //MARK: friend object
                        let friend = AppUser(uid: snapshot.key, email: email, name: name, username: username)
                        self.allFriend.append(friend)
                        self.tableView.reloadData()
                        
                        //MARK: add remove listener
                        DataService.instance.REF_CONTACT.child(curUid).observe(.childRemoved, with: { (snapshot) in
                            var index = 0
                            for friend in self.allFriend {
                                if snapshot.key == friend.uid {
                                    self.allFriend.remove(at: index)
                                }
                                index+=1
                            }
                            self.tableView.reloadData()
                        })
                        
                        
                    }
                    else{
                        print("unsuccessful acquire friend name and email")
                    }
                }
                else{
                    print("unsuccessful acquire Friend Dcitionary snap value")
                }
            }
            
        }
        else {
            print("unsuccessful acqurie uid")
        }
    }
    
    func createAlertToDelete(title: String, message: String, curUid: String, contactID: String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            //remove contact if yes clicked
            DataService.instance.removeContact(curUid: curUid, contactID: contactID)
            DataService.instance.removeContact(curUid: contactID, contactID: curUid)
            
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: TableView Configuration
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFriend.count
    }
    
    //MARK: delegate for animation of loading cell
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockCell", for: indexPath) as! CustomBlockCell
        let friend = allFriend[indexPath.row]
        cell.blockLbl.text = friend.name
        cell.blockLbl.textColor = UIColor.white
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.isUserInteractionEnabled = false //disable touch on other cell
        //impact gen
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        if let curUid = Auth.auth().currentUser?.uid {
            let friend = allFriend[indexPath.row]
            createAlertToDelete(title: "Delete Friend?", message: "Do you want to delete this firend", curUid: curUid, contactID: friend.uid )
        }
  
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }


}
