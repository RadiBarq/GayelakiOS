//
//  Item.swift
//  Chottky
//
//  Created by Radi Barq on 1/1/18.
//  Copyright © 2018 Chottky. All rights reserved.
//

import Foundation

class Item
{
    public var category = String()
    public var currency = String()
    public var description = String()
    public var displayName = String()
    public var imagesCount = String()
    public var price = String()
    public var timestamp = String()
    public var title = String()
    public var userId = String()
    public var itemPrice = String()
    
    init(category: String, currency: String, description: String, displayName: String, imagesCount: String, price: String, timestamp:String, title: String, userId: String)
    {
        self.category = category
        self.currency = currency
        self.description = description
        self.displayName = displayName
        self.imagesCount = imagesCount
        self.price = price
        self.timestamp = timestamp
        self.title = title
    }
    
    init()
    {
        
        
    }
}
