//
//  NewNotificationsCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/15/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    
    @IBOutlet weak var  notificationImage: UIImageView!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationUser: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupImage(image: UIImage)
    {
        notificationImage.image = image
        notificationImage.layer.masksToBounds = true
        notificationImage.layer.cornerRadius = 5
    }
    
    func setupUserImage(image: UIImage)
    {
        notificationUser.image = image
        notificationUser.layer.masksToBounds = true
        notificationUser.layer.cornerRadius = 5
    }
}
