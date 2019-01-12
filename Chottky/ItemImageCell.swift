//
//  ItemImageCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/15/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class ItemImageCell: UICollectionViewCell {
    
    
    var itemImageView: UIImageView = {
        
        var image = UIImageView()
        return image
        
    }()
    
    override init (frame: CGRect)
    {
        
        super.init(frame: frame)
        itemImageView.frame = CGRect(x: 0, y: -110, width: self.frame.width, height: self.frame.height + 100)
//        itemImageView.contentMode = 
        itemImageView.layer.masksToBounds = true
        addSubview(itemImageView)
        
    }
    
    func setupImage(image: UIImage)
    {
        
       itemImageView.image = image
    
    }

    //This is a required initializer, my friend
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
