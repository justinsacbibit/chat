//
//  Message.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-29.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

class Message: NSObject, JSQMessageData {
    private var body: String
    private var creator: String
    private var created: NSDate
    
    init(body: String, sender: String) {
        self.body = body
        self.creator = sender
        self.created = NSDate.date()
    }
    
    func text() -> String! {
        return self.body
    }
    
    func sender() -> String! {
        return self.creator
    }
    
    func date() -> NSDate! {
        return self.created
    }
}
