//
//  RightView.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/8/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase

class RightView: UITableViewController {

    var allUser : [AppUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavBar()
        
        //query order by key thru all the users
        DataService.instance.REF_USER.queryOrderedByKey().observe(.childAdded) { (snapshot) in
            if let userDict = snapshot.value as? NSDictionary {
                if let name = userDict["name"] as? String , let email = userDict["email"] as? String, let username = userDict["username"] as? String {
                    
                    let user = AppUser(uid: snapshot.key, email: email, name: name, username: username)

                    //user.email = email
                    //user.name = name
                    //user.uid = snapshot.key
                    
                    self.allUser.append(user)
                    self.tableView.reloadData()
                }
                else {
                     print("unsuccessful acquire Friend name and email--Add friend view")
                }
            }
            else{
                print("unsuccessful acqurie snapshot value-Add friend view")
            }
        }
        
        
    }
    


    // MARK: - Table view data source

    //MARK: cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    //MARK: cell count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allUser.count
    }

    //MARK: cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCustomCell", for: indexPath) as! CustomCell

        let user = allUser[indexPath.row]
        cell.userLbl.text = user.username
        cell.userLbl.textColor = UIColor.white
        cell.userLbl.backgroundColor = UIColor.clear
        
        return cell
    }
    
    //MARK: Select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = allUser[indexPath.row]
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        //MARK: access to current cell
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomCell
        
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.userLbl.text = "ADDING.."
            currentCell.userLbl.alpha = 0.9
            currentCell.isUserInteractionEnabled = false
            
        }) { (finished) in
            
            UIView.animate(withDuration: 1.5, animations: {
                currentCell.userLbl.alpha = 1.0
                currentCell.userLbl.text = "ADDED!"
                currentCell.isUserInteractionEnabled = false
                
                
            }, completion: { (finished) in
                //MARK: write into the contact child
                if let userUID = Auth.auth().currentUser?.uid {
                    DataService.instance.addContact(userUID: userUID, friendUID: friend.uid, email: friend.email, name: friend.name, username: friend.username)
                    
                    var curUser = AppUser(uid: "", email: "", name: "", username: "")
                    var index = 0
                    for user in self.allUser {
                        if userUID == user.uid {
                            curUser = self.allUser[index]
                        }
                        index+=1
                    }
                    
                    DataService.instance.addContact(userUID: friend.uid, friendUID: userUID, email: curUser.email, name: curUser.name, username: curUser.username)
                    
                }
                
                //restore name and color, renale user interaction
                currentCell.userLbl.text = friend.username
                currentCell.isUserInteractionEnabled = true
                currentCell.userLbl.backgroundColor = UIColor.clear
                
            })
            
            
        }
        
        //MARK: write into the the contact for friend's contact
        
        //MARK: deselect row
         tableView.deselectRow(at: indexPath, animated: false)
    
    }
    
    //MARK: delegate for animation of loading cell
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }



}
