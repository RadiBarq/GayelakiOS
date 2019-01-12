 //
 //  ChatMessageCell.swift
 //  pokemongotradcenterios
 //
 //  Created by Radi Barq on 12/30/16.
 //  Copyright © 2016 Radi Barq. All rights reserved.
 //
 
 import UIKit
 
 class ChatMessageCell: UICollectionViewCell {
    

    let textView: UITextView =
        {
            let textV = UITextView()
            textV.text = "SAMPLE TEXT FOR NOW"
            textV.font = UIFont.systemFont(ofSize: 16)
            textV.translatesAutoresizingMaskIntoConstraints = false
            textV.backgroundColor = UIColor.clear
            textV.textColor = .white
            textV.textAlignment = .center
            textV.isEditable = false
            return textV
            
            

    }()
    
    var profileImageView: UIImageView =
        {
            let imagView = UIImageView()
            //  imagView.image = UIImage(named: "profilepicture")
            imagView.translatesAutoresizingMaskIntoConstraints = false
            imagView.layer.cornerRadius = 16
            imagView.layer.masksToBounds = true
            imagView.contentMode = .scaleAspectFill
            return imagView
    }()
    
    
    let bubbleView: UIView = {
        
        let view = UIView()
        view.backgroundColor = Constants.LightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
        
    }()
    
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleViewRightAnchor  = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        //  bubbleViewLeftAnchor?.isActive = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        // This is for the profileImage
        profileImageView.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 0).isActive = true
       // textView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true

        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -10).isActive = true
        // textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        // ios9 constraitns x, y, w, h
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 }
