//
//  ProfileSettingsTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 12/27/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class ProfileSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emaiLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    static var profileSettingsImageStorageRef: StorageReference?
    var imageLibraryController = UIImagePickerController()
    let userID = Auth.auth().currentUser!.uid
    var newImage = UIImage()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        imageLibraryController.navigationBar.isTranslucent = false
        imageLibraryController.navigationBar.tintColor = UIColor.white
        self.imageLibraryController.delegate = self
        self.imageLibraryController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        initializeIndicatior()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        emaiLabel.text = WelcomeViewController.user.email
        userNameLabel.text = WelcomeViewController.user.getUserDisplayName()
        profilePicture.sd_setImage(with:   ProfileSettingsTableViewController.profileSettingsImageStorageRef!)
        title = "اعدادات الحساب"
        //self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.row == 0)
        {
                   let alert = UIAlertController(title: "تحميل الصور بواسطة", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "مكتبة الصور", style: .default, handler: { (action) in

                    self.imageLibraryController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    self.present(self.imageLibraryController, animated: true)
  
                    }))
            
            alert.addAction(UIAlertAction(title: "اغلاق", style: .cancel, handler: { (action) in
                //execute some code when this option is selected
                // self.skinType = "Dark Skin"
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (indexPath.row == 1)
        {
            let changeProfileEmailViewController = mainStoryboard.instantiateViewController(withIdentifier: "changeProfileEmailViewController") as! ChangeProfileEmailViewController
            self.navigationController?.pushViewController(changeProfileEmailViewController, animated: true)
        }
        
        else if (indexPath.row == 2)
        {
            let changeProfileUserNameViewController = mainStoryboard.instantiateViewController(withIdentifier: "changeProfileUserNameViewController") as! ChangeProfileUserNameViewController
            self.navigationController?.pushViewController(changeProfileUserNameViewController, animated: true)
        }
        
        else if (indexPath.row == 3)
        {
            let changeProfileUserNameViewController = mainStoryboard.instantiateViewController(withIdentifier: "changeProfilePasswordViewController") as! ChangeProfilePasswordViewController
            self.navigationController?.pushViewController(changeProfileUserNameViewController, animated: true)
        }
        
        else if(indexPath.row == 4)
        {
            var reportedUsersViewController = mainStoryboard.instantiateViewController(withIdentifier: "blockedUsersTableViewController") as!
            BlockedUsersTableViewController
            self.navigationController?.pushViewController(reportedUsersViewController, animated: true)
            
        }
        
    }
    
    
    @IBAction func onClickSignOut(_ sender: UIButton) {
        
        do
        {
            try Auth.auth().signOut()
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.tabBarController?.navigationController?.dismiss(animated: false, completion: nil)
            self.present(welcomeViewController, animated: true, completion: nil)
            
          //  self.navigationController?.dismiss(animated: true, completion: nil)®

        }
        
        catch
        {
            print("error happened while signing out")
        }
    }

    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.color = Constants.FirstColor
        indicator.center = self.view.center
        // indicator.stopAnimating()
        self.view.addSubview(indicator)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as?  UIImage
        {
            indicator.startAnimating()
            
            let storageRef = Storage.storage().reference().child("Profile_Pictures").child(userID).child("Profile.jpg")
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.5)
            {
                storageRef.putData(uploadData, metadata: nil)
                {
                    (metadata, error) in
                    
                    if error != nil
                    {
                        // Here ther is an error
                        print (error?.localizedDescription)
                        let alertEmailController = UIAlertController(title: "حدث خطأ ما", message: "الرجاء اعد المحاولة لاحقا", preferredStyle: .alert)
                        alertEmailController.view.tintColor = Constants.FirstColor
                        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                        alertEmailController.addAction(defaultAction)
                        self.present(alertEmailController, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        self.profilePicture.image? = image
                        SDImageCache.shared().clearMemory()
                        SDImageCache.shared().clearDisk()
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
            
        else
        {
        
        }
        
        //isBackButtonClicked = true
        imageLibraryController.dismiss(animated: true, completion: nil)
    }
}
