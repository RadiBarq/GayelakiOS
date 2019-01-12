//
//  LeftMenuTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorageUI
import MessageUI

class LeftMenuTableViewController: UITableViewController{
    
    var menus = [String]()
    public static var profileImageView: UIImageView = UIImageView()
    let userID = Auth.auth().currentUser!.uid
    let user = Auth.auth().currentUser
    public var browsingViewController: BrowseCollectionViewController!


    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        intitializeMenusArray()
        self.tableView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
       // navigationController?.navigationBar.isHidden = true
        tableView.separatorColor = UIColor.white
        tableView.register(MenuBarCell.self, forCellReuseIdentifier: "cellId")
        self.navigationController?.navigationBar.isTranslucent = false
       // UIApplication.shared.isStatusBarHidden = true
        self.tableView.isScrollEnabled = false
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      // self.tableView.register(BrowseCollectionViewController(, forCellReuseIdentifier: "leftMenuBarCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
         //UIApplication.shared.isStatusBarHidden = true
    }
    
    func intitializeMenusArray()
    {
        menus.append("بيع المنتجات الخاصة بك")
        menus.append("اكتشف")
        menus.append("الصفحة الشخصية")
        menus.append("ادعو اصحاب الفيسبوك")
        menus.append("بحاجة الى مساعدة")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.textAlignment = .right
        addThePhoto(cell: cell as! MenuBarCell, indexPath: indexPath.row)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var backgroundFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 150)
        var backgroundImageView: UIImageView = UIImageView(frame: backgroundFrame)
        let backgroundImage: UIImage = #imageLiteral(resourceName: "Triangle Pattern")
        backgroundImageView.image = backgroundImage
        
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150)
        let headerView = UIView(frame:rect)
       // headerView.addSubview(backgroundImageView)
        
        var profileBackgroundFrame = CGRect(x: 15, y: headerView.frame.size.height / 3 - 32.3
            , width: 100, height: 100)
        
        var profileBackgroundImageView = UIImageView(frame: profileBackgroundFrame)
        var profileBackgroundImage = UIImage()
        profileBackgroundImageView.backgroundColor = .white
        profileBackgroundImageView.layer.cornerRadius = 50
        profileBackgroundImageView.layer.masksToBounds = true
        headerView.addSubview(profileBackgroundImageView)
        
        var profileImageFrame = CGRect(x: 17.3, y: headerView.frame.size.height / 3 - 30
            , width: 60, height: 60)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        
        LeftMenuTableViewController.profileImageView.addGestureRecognizer(tapGesture)
        LeftMenuTableViewController.profileImageView.isUserInteractionEnabled = true
        LeftMenuTableViewController.profileImageView.frame = profileImageFrame
        LeftMenuTableViewController.profileImageView.layer.cornerRadius = 30
        LeftMenuTableViewController.profileImageView.layer.masksToBounds = true
        //LeftMenuTableViewController.profileImageView.sd_setImage(with: storageRef)
        headerView.addSubview(LeftMenuTableViewController.profileImageView)
        
        var nameTextFrame = CGRect(x: 17.3, y: headerView.frame.size.height / 3 + 45, width: 45, height: 7)
        var nameLabel = UILabel(frame: nameTextFrame)
//        nameLabel.text = WelcomeViewController.user.getUserDisplayName()

        nameLabel.text = user?.displayName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textColor = .black
        nameLabel.sizeToFit()
        headerView.addSubview(nameLabel)
        
//        var userName = UILabel()
//        headerView.addSubview(userName)
//        userName.text = "Radi Barq"
//        userName.font = UIFont.boldSystemFont(ofSize: 20)
//        userName.translatesAutoresizingMaskIntoConstraints = false
//        userName.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
//        userName.topAnchor.constraint(equalTo: profileBackgroundImageView.bottomAnchor, constant: 10).isActive = true
//
//        var cityLabel = UILabel()
//        headerView.addSubview(userName)
//        cityLabel.text = "Ramallah"
//        cityLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        cityLabel.translatesAutoresizingMaskIntoConstraints = false
//        cityLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
//        cityLabel.topAnchor.constraint(equalTo: profileBackgroundImageView.bottomAnchor, constant: 10).isActive = true
        
         return headerView
    }

    func imageTapped(gesture: UIGestureRecognizer) {
        // What to do here is like the following my little lord
        ProfileViewController.userId = userID
        ProfileViewController.userDisplayName = WelcomeViewController.user.displayName
        
        let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func addThePhoto(cell: MenuBarCell, indexPath: Int) -> UITableViewCell
    {
        if (indexPath == 0)
        {
            cell.initializeImageView(name: "ic_photo_camera")

        }
        
        else if (indexPath == 1)
        {
            
            cell.initializeImageView(name: "ic_dashboard")
            
        }
        
        else if (indexPath == 2)
        {
            
            cell.initializeImageView(name: "ic_account_box")
            
        }
        
        else if (indexPath == 3)
        {
            
            
            cell.initializeImageView(name: "ic_supervisor_account")
        }
        
        
        else if (indexPath == 4)
        {
            
            cell.initializeImageView(name: "ic_help")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 170
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    
    func showMailComposer()
    {
        
        
        guard MFMailComposeViewController.canSendMail() else
        {
            // Show alert informing the user
            print("cannot send an email")
            
            let alertEmailController = UIAlertController(title: "لا يمكنك ارسال الرسائل", message: "الرجاء تفعيل خدمة البريد الالكتروني خاصتك!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
           // self.dismiss(animated: true, completion: nil)
             self.navigationController?.present(alertEmailController, animated: true, completion: nil)

             return
            
        }
    
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("Gayelak Help")
        composer.setToRecipients(["radibaraq@gmail.com"])
        present(composer, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Here where we just test the items
        if (indexPath.item == 0)
        {
            self.dismiss(animated: true, completion: {
                
                 UIApplication.shared.isStatusBarHidden = true
                 self.browsingViewController.tabBarController?.selectedIndex = 2
                
            })
        }
            
        else if (indexPath.item == 1)
        {
//                let collectionsStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let collectionsViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "CollectionsCollectionViewController") as! CollectionsCollectionViewController
//                self.navigationController?.pushViewController(collectionsViewController, animated: true)
            self.browsingViewController.tabBarController?.selectedIndex = 1
            self.dismiss(animated: true, completion: nil)
            
        }
            
        else if (indexPath.item == 2)
        {
            ProfileViewController.userId = userID
            ProfileViewController.userDisplayName = (user?.displayName)!
            let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
               true
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        else if(indexPath.item == 3)
        {
            let alertEmailController = UIAlertController(title: "عذرا هاذا الخدمة غير متوفرة حالية!", message: "سنعمل لتفعيل هاذه الخدمة في اقرب وقت ممكن", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            // self.dismiss(animated: true, completion: nil)
            self.navigationController?.present(alertEmailController, animated: true, completion: nil)
        }
        
        
        else if (indexPath.item == 4)
        {
            
           //TODO Work here
        
           
            showMailComposer()
            
            
            
        }
    }
}


extension LeftMenuTableViewController: MFMailComposeViewControllerDelegate{
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            
            let alertEmailController = UIAlertController(title: "حدث خطأ ما!", message: "لم نتمكن من ارسال الرسالة الرجاء المحاولة لاحقا", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            // self.dismiss(animated: true, completion: nil)
            self.navigationController?.present(alertEmailController, animated: true, completion: nil)
            controller.dismiss(animated: true)
            return
        }
        
        
        switch result{
            
        case .cancelled:
            print("Cancelled")
           
        case .failed:
            print("Failed to send")
            
        case .saved:
            print("Saved")
            
        case .sent:
            print("Email Sent")
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}
