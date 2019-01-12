//
//  ChangeProfileEmailViewController.swift
//  Chottky
//
//  Created by Radi Barq on 12/27/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase

class ChangeProfileEmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let email = emailTextField.text
        
        var alertEmailController:UIAlertController = UIAlertController()
        
        Auth.auth().currentUser?.updateEmail(to: email!) { (error) in

            if (error != nil)
            {
                if (error!.localizedDescription == "The email address is already in use by another account.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "هاذا البريد الالكتروني تم تسجيله مسبقا", preferredStyle: .alert)
                }
                    
                else if (error!.localizedDescription == "The email address is badly formatted.")
                {
                    
                    alertEmailController = UIAlertController(title: "صيغة البريد الالكتروني غير صحيحة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
                    
                }
                    
                else if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "خطأ في الشبكة الرجاء اعد المحاولة", preferredStyle: .alert)
                }
                    
                else
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: error?.localizedDescription, preferredStyle: .alert)
                }

    
                print (error?.localizedDescription)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
            }
            
            else
            {

                alertEmailController = UIAlertController(title: "تمت العملية بنجاح", message: "تم تغيير بريدك الالكتروني", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: { (alert: UIAlertAction!) in
        
                    WelcomeViewController.user.email = email!
                    self.navigationController?.popViewController(animated: true)
                    
                })
                
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: {
            })
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        emailTextField.text = WelcomeViewController.user.email
        
    }
    
}
