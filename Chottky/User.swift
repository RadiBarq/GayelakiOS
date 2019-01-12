//
//  User.swift
//  Chottky
//
//  Created by Radi Barq on 3/12/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import Foundation


class User
{
    var email = String()
    var displayName = String()
    var userImage:URL?
    var userId = String()
    
    
    public func setUserEmail(email:String)
    {
        self.email = email
    
    }
    
    public func setUserDisplayName(name:String)
    {
        self.displayName = name
    
    }
    
    
    public func setUpUserId(userId: String)
    {
        
            self.userId = userId
    }
    
    
    public func getEmail() ->  String
    {
        return email
        
    }
    
    public func getUserDisplayName() -> String
    {
        return self.displayName
        
    }

}
