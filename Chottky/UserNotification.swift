//
//  UserNotification.swift
//  Chottky
//
//  Created by Radi Barq on 6/10/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import Foundation

class UserNotification
{
    
    
    var email: String?
    var type: String?
    var userName: String?
    var timestamp: Double?
    var isItNew: Bool?
    
    
    func setEmail(email: String)
    {
        self.email = email
    }
    
    func setType(type: String)
    {
        self.type = type
    }
    
    func setUserName(userName: String)
    {
        self.userName = userName
    }
    
    func setTimestamp(timestamp: Double?)
    {
        self.timestamp = timestamp
    }
    
    
    func setIsItNew(isIt: Bool)
    {
        self.isItNew = isIt
    }
    
    func returnEmail() -> String?
    {
        return email
    }
    
    func returnType() -> String?
    {
        return type
    }
    
    func returnUserName() -> String?
    {
        
        return userName
        
    }
    
    func returnTimestamp() -> Double?
    {
        
        return timestamp
        
        
    }
    
    func returnIsItNew() -> Bool?
    {
        return isItNew
        
    }
}
