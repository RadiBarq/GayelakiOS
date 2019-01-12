//
//  ResetPasswordViewController.swift
//  Chottky
//
//  Created by Radi Barq on 1/14/18.
//  Copyright © 2018 Chottky. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
    
            resetPassword()
        
    }
    
    func resetPassword()
    {
        
         var alertEmailController:UIAlertController = UIAlertController()
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
            
            if (error == nil)
            {
                print("it works")
                alertEmailController = UIAlertController(title: "تم ارسال الرسالة بنجاح", message: "الرجاء تفحص بريدك الالكتروني لاكمال عملية اعادة كلمة السر", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler:{(alert)
                    in  self.resetCompleted()})
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
            }
            
            else
            {
                print(error?.localizedDescription)
                
                alertEmailController = UIAlertController(title: "حدث خطأ ما!", message: "الرجاء التاكد من البريد الالكتروني المدخل او اتصال الشبكة", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
            }
            
        })
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        
         self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func resetCompleted()
    {
        
        
        
        
         self.dismiss(animated: true, completion: nil)

        
        
    }
    
    
}
