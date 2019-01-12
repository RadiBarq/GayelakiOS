//
//  ItemsCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/19/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class ItemsCell: UICollectionViewCell {
    
    
    var itemImageView: UIImageView = {
        
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        itemImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        
        addSubview(itemImageView)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupImage(image: UIImage)
    {
        
        itemImageView.image = image
        
    }
  
    
}
