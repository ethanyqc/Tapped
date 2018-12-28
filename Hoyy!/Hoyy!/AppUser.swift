//
//  AppUser.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/10/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
class AppUser {
    var uid = ""
    var email = ""
    var name = ""
    var username = ""
    
    init(uid: String, email: String, name: String, username: String){
        self.uid = uid
        self.email = email
        self.name = name
        self.username = username
    }
}
