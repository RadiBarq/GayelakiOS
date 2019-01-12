//
//  ChangeProfilePasswordViewController.swift
//  Chottky
//
//  Created by Radi Barq on 12/27/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase

class ChangeProfilePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }

  
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        var alertEmailController:UIAlertController = UIAlertController()
        let password = oldPasswordTextField.text!
        let confirmPassword = newPasswordTextField.text!
        
        if (password != confirmPassword)
        {

            alertEmailController = UIAlertController(title: "الرجاء اعد المحاولة", message: "تاكيد كلمة السر غير مطابق لكلمة السر", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            self.present(alertEmailController, animated: true, completion: nil)

        }
        
        else
        {
            
            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                
                if (error == nil)
                {
                    
                    alertEmailController = UIAlertController(title: "تمت العملية بنجاح", message:  "تم تغيير كلمة السر بنجاح",  preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: { (alert: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)

                    })
                
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: nil)
        
                }
                
                else
                
                {
                     alertEmailController = UIAlertController(title: "الرجاء اعد المحاولة", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    print(error?.localizedDescription)
                    
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: nil)
                    
                }
            }
            
        }

    }
    
}
