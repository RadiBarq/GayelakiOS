//
//  BrowseSettingsTableViewCell.swift
//  Chottky
//
//  Created by Radi Barq on 9/8/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class BrowseSettingsTableViewCell: UITableViewCell {

    var tickImageView: UIImageView = {
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0,width: 20, height: 20))
        imageView.image = UIImage(named: "checkmark")
        return imageView
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func addImageView()
    {
        self.addSubview(tickImageView)
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        tickImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        tickImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tickImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    }
    
    
    func removeImageView()
    {
        tickImageView.removeFromSuperview()
    }

}
