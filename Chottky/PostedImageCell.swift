//
//  PostedImageCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/20/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class PostedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    var insideImage: UIView = {
        
       var imgv = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return imgv
        
    }()
    
    public func setUpImage(image: UIImage)
    {
        itemImageView.image = image
        insideImage.removeFromSuperview()
        //insideImage.isHidden = true
    }
    
    public func setUpEmptyImage()
    {
        //self.backgroundColor = UIColor.clear
        //self.layer.cornerRadius = 5
        //self.layer.masksToBounds = true
        //itemImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //itemImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //insideImage.isHidden = false
        
        itemImageView.backgroundColor = Constants.FirstColor
        itemImageView.image = nil
        // itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //temImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //itemImageView.translatesAutoresizingMaskIntoConstraints = false
        //insideImage = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backgroundImage.image = UIImage(named: "ic_add_a_photo_white")
        insideImage.addSubview(backgroundImage)
        itemImageView.addSubview(insideImage)
        insideImage.translatesAutoresizingMaskIntoConstraints = false
        insideImage.centerXAnchor.constraint(equalTo: itemImageView.centerXAnchor).isActive = true
        insideImage.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor).isActive = true
        insideImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        insideImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
