//
//  Snaps.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/14/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
class Snaps {
    
    var msgType = ""
    var msgColor = ""
    var email = ""
    var name = ""
    var message = ""
    var fromUid = ""
    var snapID = ""
    var date : NSDate
    var imageName = ""
    var imageURL = ""
    
    init(msgType: String, msgColor: String, email: String, name: String, fromUid: String, message: String, snapID: String, date: NSDate, imageName: String, imageURL: String){
        self.msgType = msgType
        self.msgColor = msgColor
        self.message = message
        self.email = email
        self.name = name
        self.fromUid = fromUid
        self.snapID = snapID
        self.date = date
        self.imageName = imageName
        self.imageURL = imageURL
    }
}
