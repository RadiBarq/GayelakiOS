//
//  ChangeProfileUserNameViewController.swift
//  Chottky
//
//  Created by Radi Barq on 12/27/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase

class ChangeProfileUserNameViewController: UIViewController, UITextFieldDelegate {

    let userNameMaxLength = 20
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    let userID = Auth.auth().currentUser!.uid
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
            var alertEmailController:UIAlertController = UIAlertController()
            let userName = userNameTextField.text!
        let firebaseUser = Auth.auth().currentUser
        let changeRequest = firebaseUser?.createProfileChangeRequest()
            changeRequest?.displayName = userName
        
    
            changeRequest?.commitChanges { error in
              if let error = error {
            
               } else {
                // Profile updated.
                Database.database().reference().child("Users").child(self.userID).updateChildValues(["UserName": userName], withCompletionBlock: {_,_ in
                    alertEmailController = UIAlertController(title: "تمت العملية بنجاح", message: "تم تغير اسم المستخدم بنجاح", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: { (alert: UIAlertAction!) in
                        
                        WelcomeViewController.user.displayName = self.userNameTextField.text!
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: {
                    })
                }
                )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        self.navigationController?.navigationBar.topItem?.title = ""
        userNameTextField.text = WelcomeViewController.user.getUserDisplayName()
  
        // Do any additional setup after loading the view.
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= userNameMaxLength
        
    }

}
