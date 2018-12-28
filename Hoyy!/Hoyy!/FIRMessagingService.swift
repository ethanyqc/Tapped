//
//  FIRMessagingService.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/26/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.


// TOPIC:newMessage

import Foundation
import FirebaseMessaging

enum SubscriptionTopic: String {
    case newMessage = "newMessage"
}

class FIRMessagingService {
    
    private init() {}
    
    
    static let shared = FIRMessagingService()
    let messaging = Messaging.messaging()
    
    
    
    //Functions for subscribe or unsubscribe to a specific topc
    func subscribe(to topic: SubscriptionTopic) {
        messaging.subscribe(toTopic: topic.rawValue)
    }
    func unsubscribe(from topic: SubscriptionTopic) {
        messaging.unsubscribe(fromTopic: topic.rawValue)
    }
    
    
}
