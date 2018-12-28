//
//  InboxViewController.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/22/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet


class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    var allSnaps : [Snaps] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 20
        //setupNavBar()
        tableView.tableFooterView = UIView() // delete seperator for unused rows
        
        if let curUid = Auth.auth().currentUser?.uid {
            
            //MARK: ADD LISTENER 1
            DataService.instance.REF_SNAPS.child(curUid).observe(.childAdded) {(snapshot) in
                if let snapDict = snapshot.value as? NSDictionary {
                    if let msgType = snapDict["msgType"] as? String, let msgColor = snapDict["msgColor"] as? String, let fromName = snapDict["fromName"] as? String, let fromEmail = snapDict["fromEmail"] as? String, let message = snapDict["message"] as? String, let fromUid = snapDict["fromUid"] as? String, let date = snapDict["date"] as? String, let imageName = snapDict["imageName"] as? String, let imageURL = snapDict["imageURL"] as? String {
                        
                        //convert date string to nsdate
                        //yyyy-MM-dd HH:mm:ss
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        //get var of NSDate
                        let dateNS = dateFormatter.date(from: date)
                        
                        
                        //MARK: snap object
                        let snap = Snaps(msgType: msgType, msgColor: msgColor, email: fromEmail, name: fromName, fromUid: fromUid, message: message, snapID: snapshot.key, date: dateNS! as NSDate, imageName: imageName, imageURL: imageURL)
                        
                        self.allSnaps.insert(snap, at: 0)
                        self.tableView.reloadData()
                        
                        UIApplication.shared.applicationIconBadgeNumber = self.allSnaps.count
                        
                        
                        //MARK: ADD LISTENER 2
                        DataService.instance.REF_SNAPS.child(curUid).observe(.childRemoved, with: { (snapshot) in
                            var index = 0
                            for snap in self.allSnaps {
                                if snapshot.key == snap.snapID {
                                    self.allSnaps.remove(at: index)
                                    UIApplication.shared.applicationIconBadgeNumber = self.allSnaps.count
                                }
                                index+=1
                            }
                            self.tableView.reloadData()
                            
                        })
                        
                    }
                    else{
                        print("unsuccessful acquire msg details")
                    }
                }
                else{
                    print("unsuccessful acquire snap Dcitionary snap value")
                }
            }
        }
        else {
            print("unsuccessful acquire uid")
        }
    }
    
    //MARK: empty message
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "ALL READ"
        let font = UIFont(name: "ZillaSlab-Regular", size: 20)
        let attrs = [NSAttributedStringKey.font: font as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //dismiss InboxVC
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "an hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) min ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 min ago"
            } else {
                return "a minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "just now"
        }
        
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allSnaps.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inbox", for: indexPath) as! CustomInboxCell
        
        
        let snap = allSnaps[indexPath.row]
        if snap.imageURL == "" {
            cell.msgType.text = "💬"
        }
        else {
            if snap.msgType == "pic" {
                cell.msgType.text = "🏙"
            }
            else {
               cell.msgType.text = "📸"
            }
            
        }
        cell.senderName.text = snap.name
        cell.date.text = timeAgoSinceDate(date:snap.date, numericDates:false)
        cell.senderName.textColor = UIColor.white
        
        
        return cell
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.33) {
            cell.alpha = 1
        }
        
    }
    
    //MARK: Select cell
    //MARK: Select cell, sycronized time refresh
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.isUserInteractionEnabled = false //disable touch on other cell
        //impact gen
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        let snap = allSnaps[indexPath.row]
        /*
         //remove snap
         if let curUid = Auth.auth().currentUser?.uid {
         DataService.instance.removeSnap(curUid: curUid, snapID: snap.snapID)
         }
         */
        if snap.imageName == "" {
            performSegue(withIdentifier: "viewMessage", sender: snap)
        }
        else {
            performSegue(withIdentifier: "viewSnap", sender: snap)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }//end
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnap" {
            if let snapView = segue.destination as? SnapDisplayViewController {
                if let snap = sender as? Snaps {
                    snapView.snap = snap
                }
            }
            
            
        }
        else if segue.identifier == "viewMessage" {
            if let messageView = segue.destination as? MessageDisplayViewController {
                if let snap = sender as? Snaps {
                    messageView.snap = snap
                }
            }
            
        }
    }
    
    


}
