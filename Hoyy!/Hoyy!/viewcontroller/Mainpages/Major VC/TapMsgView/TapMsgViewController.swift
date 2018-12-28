//
//  TapMsgViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/17/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import SCTableIndex
import NVActivityIndicatorView


class TapMsgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tbIndex: SCTableIndex!
    
    var allFriend : [AppUser] = []
    var allFriendNames : [String] = []
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    var indexLoaded = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        startAnimating(type: .ballClipRotateMultiple)
        tbIndex.delegate = self
        tableView.tableFooterView = UIView() // delete seperator for unused rows
        setupLongPressGesture()
        
        //MARK: send FCM token
        if let curUid = Auth.auth().currentUser?.uid {
            
            if let token = Messaging.messaging().fcmToken {
                DataService.instance.addNoteKey(curUid: curUid, key: token)
                print("send token")
            }
            else {
                print("Please reenable notificating in setting and log in again")
            }
            
            
            //MARK: Snapshoting the contact of current users
            DataService.instance.REF_CONTACT.child(curUid).observe(.childAdded) {(snapshot) in
                if let friendDict = snapshot.value as? NSDictionary {
                    if let name = friendDict["name"] as? String, let email = friendDict["email"] as? String, let username = friendDict["username"] as? String {
                        
                        //MARK: friend object
                        let friend = AppUser(uid: snapshot.key, email: email, name: name, username: username)
                        self.allFriend.append(friend)
                        self.allFriendNames.append(friend.name)
                        self.allFriend = self.allFriend.sorted { $0.name < $1.name }
                        self.allFriendNames = self.allFriendNames.sorted()
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
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        scrollView.isScrollEnabled = true
        if offset < -150 {
            scrollView.isScrollEnabled = false
            generator.prepare()
            generator.impactOccurred()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toPopUp", sender: self)
            }
            
        }
        
    }
    

    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.3// 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        //let p = gestureRecognizer.location(in: self.tableView)
        
        
        if gestureRecognizer.state == .began {
            //let indexPath = self.tableView.indexPathForRow(at: p)
           
        }
    /*   when long hold end
        if gestureRecognizer.state == .ended {
            print("ended")
        }
    */
        
    }
    
    // MARK: - Table view data source.......................................................................
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFriend.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendMsgCell", for: indexPath) as! CustomSenMsgCell
        
        let friend = allFriend[indexPath.row]
        if friend.name == Auth.auth().currentUser?.displayName {
            cell.tapMsgUserLbl.text = friend.name+"(me)"
        }
        else {
            cell.tapMsgUserLbl.text = friend.name
        }
        cell.tapMsgUserLbl.backgroundColor = UIColor.clear
        
        
        return cell
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                // everything is loaded
                self.stopAnimating()
                
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in

                    //load indexes
                    if !self.indexLoaded {
                        self.tbIndex.initialFont = UIFont(name: "ZillaSlab-Regular", size: 12)!
                        self.tbIndex.setView(self.allFriendNames)
                        
                        
                        self.indexLoaded = true
                        
                    }
                })

            }
        }
        
    }
    
    //MARK: Select cell
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = allFriend[indexPath.row]
        
        print(friend.uid+" "+friend.name+" "+friend.email)
        
        //impact ge
        generator.prepare()
        generator.impactOccurred()
        
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomSenMsgCell
        
        
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.tapMsgUserLbl.text = ":)"
            currentCell.tapMsgUserLbl.alpha = 0.9
            currentCell.isUserInteractionEnabled = false
            
        }) { (finished) in
            
            UIView.animate(withDuration: 1.5, animations: {
                currentCell.tapMsgUserLbl.alpha = 1.0
                currentCell.tapMsgUserLbl.text = "TAPPED!"
                currentCell.isUserInteractionEnabled = false
                
            }, completion: { (finished) in
                
                //Send message
                if let name = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email, let userUid = Auth.auth().currentUser?.uid{
                    
                    let today = Date()

                    
                    DataService.instance.sendSnap(msgType: "msg", msgColor: MsgData.instance.colorStr, friendUID: friend.uid, message: MsgData.instance.msg, email: userEmail, name: name, fromUid: userUid, date:today.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), imageName: "", imageURL: "")
                    
                }
                //Restore name and color, reenable user interaction
                currentCell.tapMsgUserLbl.text = friend.name
                currentCell.isUserInteractionEnabled = true
                currentCell.tapMsgUserLbl.backgroundColor = UIColor.clear
            })
            
            
        }//end animation
        
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK：PASS info to popup, prepeare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopUp" {
            if let popup = segue.destination as? PopUpViewController {
                popup.popTitle = MsgData.instance.msg
            }
            
        }

    }
    
    


}

extension TapMsgViewController: SCTableIndexDelegate {
    // Move starting point item that select initial text
    func scTableIndexReturnInitialText(_ strInitial: String, index: Int) {
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }
}
