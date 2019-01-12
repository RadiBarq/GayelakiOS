//
//  MessagesTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/12/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI


class MessagesTableViewController: UITableViewController {
    
    var messagesKeys:[String] = []
    // static var messageTo_Email = String()f
    //static var messageTo_DisplayName = String()
    var usersNames: [String: String] = [:]
    var holdingRow = String()
    var holdingTouchIndex:IndexPath!
    let userID = Auth.auth().currentUser!.uid
    var messagesTimeDic: [String: Double] = [:]
    var usersKeys: [String: String] = [:]
    var itemsKeys: [String: String] = [:]
    var lastMessages: [String: NSDictionary?] = [:]
    var storageRef: StorageReference!
    @IBOutlet var holdView: UIView!
    var indicator = UIActivityIndicatorView()
    var holdingName = String()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        tabBarController?.tabBar.items?[2].badgeValue = nil
        // FirstViewController.notificationsNumber = 0
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        self.navigationController?.navigationBar.topItem?.title = "الرسائل"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId" ) // here remember to use self because the function needs an objedct, rememebr these very well
        //usersKeys = [String]()
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.hidesBackButton = false
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
        
        indicator.backgroundColor = UIColor.white
        title = "الرسائل"
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //title = ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        storageRef = Storage.storage().reference(withPath: "Profile_Pictures")
        initializeIndicatior()
        fetchUsers()
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        
        removeView()
    }
    
    @IBAction func deleteView(_ sender: UIButton) {
        
        var reference = Database.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
    }
    
    @IBAction func blockUser(_ sender: UIButton) {
        
        var blockReference = Database.database().reference().child("Users").child(userID).child("block").child(holdingRow).setValue(holdingName)
        var deleteReference = Database.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            
            if let indexPath =  tableView.indexPathForRow(at: touchPoint){
                
                var messageKey = messagesKeys[indexPath.row]
                holdingRow = usersKeys[messageKey]!
                holdingName = usersNames[messageKey]!
                holdingTouchIndex = indexPath
                popOutTheHoldView(name: holdingRow) // That's it
            }
        }
    }
    
    func addView()
    {
        //view.superview?.addSubview(holdView)
        //self.tableView.isScrollEnabled = false
        //self.tableView.allowsSelection = false
        
    //    holdView.layer.cornerRadius = 5
        //   holdView.translatesAutoresizingMaskIntoConstraints = false
      //  holdView.center = view.center
       // holdView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        //holdView.alpha = 0
        
      //  UIView.animate(withDuration: 0.4)
       // {
            // self.visualEffect.effect = self.effect
         //   self.holdView.alpha = 1
          //  self.holdView.transform = CGAffineTransform.identity
       // }
    
        let alert = UIAlertController(title: "العملية على هاذا المستخدم", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "حذر المستخدم", style: .default, handler: { (action) in
            // PostedItemViewController.imageClickedNumber = indexPath.item
            // let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //  let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
            //  self.navigationController?.pushViewController(cameraViewController, animated: true)
            self.blockUser(userKey: self.holdingRow, userName: self.holdingName)
            
        }))
        
        alert.addAction(UIAlertAction(title: "التبليغ عن المستخدم", style: .default, handler: { (action) in
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let reportViewController = mainStoryboard.instantiateViewController(withIdentifier: "reportUserViewController") as! ReportUserViewController
            self.navigationController?.pushViewController(reportViewController, animated: true)
            ProfileViewController.userId = self.holdingRow

        }))
        
        alert.addAction(UIAlertAction(title: "حذف من الرسائل", style: .default, handler: { (action) in
            
            var reference = Database.database().reference().child("Users").child(self.userID).child("chat").child(self.holdingRow).removeValue()
        }))
        
        alert.addAction(UIAlertAction(title: "اغلاق", style: .cancel, handler: { (action) in
            //execute some code when this option is selected
            // self.skinType = "Dark Skin"
            alert.dismiss(animated: true, completion: nil)
            print("close")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func popOutTheHoldView(name: String)
    {
        addView()
    }
    
    @IBAction func handlelDelete(_ sender: UIButton) {
        
        var reference = Database.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
        
        // var seconRef = FIRDatabase.database().reference().child("Users").child(holdingRow).child("chat").child(userID).removeValue()
    }
    
    @IBAction func handleBlock(_ sender: UIButton) {
        
        var blockReference = Database.database().reference().child("Users").child(userID).child("block").child(holdingRow).setValue("true")
        var deleteReference = Database.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
    }
    
    @IBAction func handleClose(_ sender: UIButton) {
        
        removeView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return messagesKeys.count
    }
    
    func fetchUsers()
    {
        let ref = Database.database().reference()
        let handle = ref.child("Users").child(userID).child("chat").observe(.value, with: { snapshot in
            
             self.indicator.startAnimating()
             self.messagesKeys = [String]()
             self.messagesTimeDic = [:]
             self.usersKeys = [:]
             self.itemsKeys  = [:]
             self.usersNames = [:]
             self.lastMessages = [:]
            
            for user in snapshot.children
            {
                let messageKey = String(describing: (user as! DataSnapshot).key)
                let messageValue = ((user as! DataSnapshot).value!) as! NSDictionary
                self.messagesKeys.append(messageKey)
                let lastMessage =  messageValue["lastMessage"] as? NSDictionary
                // this is because we update the messages then the last message so it may be null
                let userKey = messageValue["user-id"] as? String
                let userName = messageValue["user-name"] as? String
                
                if (userKey == nil || self.lastMessages == nil)
                {
                    self.indicator.stopAnimating()
                    self.messagesKeys = []
                    self.tableView.reloadData()
                    return
                }
                
                let itemKey = messageValue["item-id"] as? String
                
                if (lastMessage == nil || userKey == nil || itemKey == nil || userName == nil)
                {
                    self.messagesKeys = [String]()
                    self.tableView.reloadData()
                    return
                }
                
                self.lastMessages[messageKey] = lastMessage
                var timestamp =  lastMessage!["time"] as! Double
                self.messagesTimeDic[messageKey] = timestamp
                self.usersKeys[messageKey] = userKey
                self.itemsKeys[messageKey] = itemKey
                self.usersNames[messageKey] = userName    
        }
            
        if (self.messagesKeys.isEmpty == true)
        {
            self.messagesKeys = [String]()
            self.indicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
            
        self.messagesKeys = self.messagesTimeDic.keysSortedByValue(isOrderedBefore: >)
        self.tableView.reloadData()
            
    })
}
    
    func removeView()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.holdView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.holdView.alpha = 0
        })
            
        {(success: Bool) in
            
            self.holdView.removeFromSuperview()
        }
        
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.deselectRow(at: holdingTouchIndex, animated: true)
        // fetchUsers()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let messageId = messagesKeys[indexPath.row]
        let userId =  usersKeys[messageId]
        let itemId = itemsKeys[messageId]
        var userName = usersNames[messageId]
        let lastMessage = lastMessages[messageId]!
        
                cell.lastMessageLabel.text = lastMessage!["message"] as! String
                //childValue = Double(childValue)!
                let date = Date(timeIntervalSince1970: TimeInterval(lastMessage!["time"] as! Double))
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ar_JO")
                dateFormatter.dateStyle = .short
                cell.lastMessageTimeLabel.text =  dateFormatter.string(from: date)
                
                if (lastMessage!["recent"] as! String == "false")
                {
                    cell.lastMessageLabel.textColor = UIColor.gray
                }
                    
                else{
                    
                     cell.lastMessageLabel.textColor = Constants.SecondColor
                }
            
                let imageRef = self.storageRef.child(userId! + "/" + "Profile.jpg")
        let itemRef = Storage.storage().reference().child("Items_Photos").child(itemId!).child("1.jpeg")
        
                cell.profileImageView.sd_setShowActivityIndicatorView(true)
                cell.profileImageView.sd_setIndicatorStyle(.gray)
                cell.profileImageView.sd_addActivityIndicator()
                cell.profileImageView.sd_setImage(with: imageRef,  placeholderImage: nil, completion:
                    
                    {  (image, error, cache, ref) in
                        
                        cell.profileImageView.sd_removeActivityIndicator()
                    })
        
                cell.itemImageView.sd_setShowActivityIndicatorView(true)
                cell.itemImageView.sd_setIndicatorStyle(.gray)
                cell.itemImageView.sd_addActivityIndicator()
                cell.itemImageView.sd_setImage(with: itemRef,  placeholderImage: nil, completion:
                    {  (image, error, cache, ref) in
            
                        cell.itemImageView.sd_removeActivityIndicator()
                })
        
                cell.messageContact.text = userName
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
        
        return cell
    }
    
    
    @IBAction func onClickBackButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }

    private func blockUser(userKey: String, userName: String)
    {
        Database.database().reference().child("Users").child(WelcomeViewController.user.userId).child("chat").observeSingleEvent(of: .value, with:{ (snapshot) in
            
            for message in snapshot.children
            {
                let messageValue = ((message as! DataSnapshot).value!) as! NSDictionary
                 let blockedUserKey = messageValue["user-id"] as? String
                
                if (blockedUserKey == userKey)
                {
                    var messageKey = (String(describing: (message as! DataSnapshot).key))
                    Database.database().reference().child("Users").child(WelcomeViewController.user.userId).child("chat").child(messageKey).removeValue()
                }
            }
        });
        
        Database.database().reference().child("Users").child(userKey).child("chat").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for message in snapshot.children
            {
                let messageValue = ((message as! DataSnapshot).value!) as! NSDictionary
                let blockedUserKey = messageValue["user-id"] as? String
                
                if (blockedUserKey == WelcomeViewController.user.userId)
                {
                    var messageKey = (String(describing: (message as! DataSnapshot).key))
                    Database.database().reference().child("Users").child(userKey).child("chat").child(messageKey).removeValue()
                }
            }
        });
        Database.database().reference().child("Users").child(WelcomeViewController.user.userId).child("block").child(userKey).setValue(userName)
    }

    // When the user click on the message
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messageId = messagesKeys[indexPath.row]
        let userId =  usersKeys[messageId]
        let itemId = itemsKeys[messageId]
        let userName = usersNames[messageId]
        
        
        Database.database().reference().child("Users").child(userId!).child("UserName").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //    users = [String]()
        })

        //FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(messagesKeys[indexPath.row]).child("lastMessage").updateChildValues(["recent": "false"])
        
        ///This is related to move the controller()
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let firstViewController = storyboard.instantiateViewController(withIdentifier: "SendMessage"
        //   ) as! UICollectionViewControllerd
        // self.present(firstViewController, animated: true, completion: nil)
        
        ChatCollectionViewController.messageFromDisplayName = userName!
        ChatCollectionViewController.messageToId = userId!
        ChatCollectionViewController.itemId = itemId!
        let flowLayout = UICollectionViewFlowLayout()
        let chatLogController = ChatCollectionViewController(collectionViewLayout:flowLayout)
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.color = Constants.FirstColor
        indicator.center = self.view.center
        indicator.stopAnimating()
        self.view.addSubview(indicator)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

class UserCell: UITableViewCell
{
    override func layoutSubviews() {
    
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: self.frame.width - 200, y: textLabel!.frame.origin.y - 10, width: 200, height: (textLabel?.frame.height)!)
        textLabel?.textAlignment = .right
    }
    
    
    public var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        //    imageView.image = UIImage(named: "profilepicture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public var itemImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
        
    }()

    public var messageContact: UILabel = {
        
        var lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
        
    }()
    
    public var lastMessageTimeLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.lightGray
        return lbl
        
    }()
    
    public var lastMessageLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        // ios9 constraints anchors
        // need x, y, width, height anchors
        profileImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(itemImageView)
        itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        itemImageView.image = #imageLiteral(resourceName: "adidas")
        // Related to the last message label
        
        addSubview(lastMessageLabel)
       // lastMessageLabel.textColor = Constants.SecondColor
        lastMessageLabel.rightAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -10).isActive = true
        lastMessageLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: 10).isActive = true
        lastMessageLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        lastMessageLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        lastMessageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        addSubview(lastMessageTimeLabel)
        lastMessageTimeLabel.leftAnchor.constraint(equalTo: self.itemImageView.rightAnchor, constant: 10).isActive = true
        lastMessageTimeLabel.centerYAnchor.constraint(equalTo: self.lastMessageLabel.centerYAnchor).isActive = true
        lastMessageTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lastMessageTimeLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        //lastMessageTimeLabel.text = "٥د"
        
        addSubview(messageContact)
        messageContact.rightAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -5).isActive = true
        messageContact.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: -10).isActive = true
        messageContact.widthAnchor.constraint(equalToConstant: self.frame.width - 110).isActive = true
        messageContact.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
}


