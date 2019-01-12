//
//  ProfileItemCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/25/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class ProfileItemsCell: UICollectionViewCell {
    
    var itemImageView: UIImageView = {
        
        var image = UIImageView()
        return image
        
    }()
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        itemImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.red.cgColor
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
