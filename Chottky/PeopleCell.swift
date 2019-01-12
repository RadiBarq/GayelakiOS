//
//  UserCell.swift
//  Chottky
//
//  Created by Radi Barq on 3/8/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell
{

    override func layoutSubviews() {
        
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64 ,y : textLabel!.frame.origin.y, width: textLabel!.frame.width, height: (textLabel?.frame.height)!
        )
    }
  
    let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilepicture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}

