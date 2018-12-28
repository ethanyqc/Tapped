//
//  DataService.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/3/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USERNAMES = DB_BASE.child("userNAMES")
    private var _REF_SNAPS = DB_BASE.child("snaps")
    private var _REF_CONTACT = DB_BASE.child("contact")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USER: DatabaseReference {
        return _REF_USERS
    }
    var REF_USERNAMES: DatabaseReference {
        return _REF_USERNAMES
    }
    var REF_SNAPS: DatabaseReference {
        return _REF_SNAPS
    }
    var REF_CONTACT: DatabaseReference {
        return _REF_CONTACT
    }
    
    func creatDBUser(uid: String, email: String, name: String){
        let userProfile = ["email": email,"name": name]
        _REF_USERS.child(uid).setValue(userProfile)
    }
    
    func createUserNameforUser(uid: String, username: String){
        _REF_USERS.child(uid).updateChildValues(["username": username])
    }
    
    func updateUserList(userName: String, uid: String){
        _REF_USERNAMES.child(userName).setValue(uid)
    }
    
    //MARK: add contact
    func addContact(userUID: String, friendUID: String, email: String, name: String, username: String){
        let friendProfile = ["email": email,"name": name, "username": username]
        _REF_CONTACT.child(userUID).child(friendUID).updateChildValues(friendProfile)
    }
    
    func removeContact(curUid: String, contactID: String){
        _REF_CONTACT.child(curUid).child(contactID).removeValue()
    }
    
    //MARK: sending snaps
    func sendSnap(msgType: String, msgColor: String, friendUID: String, message: String, email: String, name: String, fromUid: String, date: String, imageName: String, imageURL: String){
        let msgProfile = ["msgType": msgType, "msgColor": msgColor, "fromEmail": email,"fromName": name, "fromUid": fromUid, "message": message, "date": date, "imageName": imageName, "imageURL": imageURL]
        _REF_SNAPS.child(friendUID).childByAutoId().updateChildValues(msgProfile)
    }
    
    func removeSnap(curUid: String, snapID: String){
        _REF_SNAPS.child(curUid).child(snapID).removeValue()
    }
    
    //MARK: add notification keys
    func addNoteKey(curUid: String, key: String){
        _REF_USERS.child(curUid).child("NotificationKeys").updateChildValues([key : true])
    }
    func removeKey(curUid: String, key: String){
        _REF_USERS.child(curUid).child("NotificationKeys").child(key).removeValue()
    }

    
    //remove observer at user
    func removeObserverUser(){
        _REF_USERS.removeAllObservers()
    }
    
    //remove observer at contact
    func removeObserverAtContact(){
        
    }

    
    
    
}
