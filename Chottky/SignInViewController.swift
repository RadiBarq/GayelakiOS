//
//  SignInViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/9/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SideMenu
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.view.backgroundColor = UIColor.clear
        var backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "house-photo")
        backgroundImage.frame = self.view.bounds
        self.backgroundView.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        //backgroundImage.widthAnchor.constraint(equalToConstant: self.backgroundView.frame.width).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: self.backgroundView.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "البريد الاكتروني", attributes: [NSForegroundColorAttributeName: UIColor.white])

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "كلمة المرور", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
       emailTextField.underlined()
        passwordTextField.underlined()
        
        
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
       //  emailTextField.text = nil
        // passwordTextField.text = nil
    //
        //emailTextField.placeholder = "البريد الاكتروني"
       // passwordTextField.placeholder = "كلمة المرور"

        // Do any additional setup after loading the view.
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickSingIn(_ sender: UIButton) {
        
        signIn()
    }
    
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var resetPasswordController = mainStoryboard.instantiateViewController(withIdentifier: "resetPasswordViewController") as! ResetPasswordViewController
        present(resetPasswordController, animated: true, completion:nil)
    }
    
    
    func signIn()
    {
        
        let alertEmailController = UIAlertController(title: "صيغة البريد الالكتروني غير صحيحة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
         alertEmailController.addAction(defaultAction)
        let emailText:String = emailTextField.text!
        let passwordText:String = passwordTextField.text!
        
        
        if (emailText.isEmail == false)
        {
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else
        {
            authenticateWithFirebase(email: emailText, password: passwordText)
        }
    }
    
    
    func authenticateWithFirebase(email:String, password:String)
    {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
        var alertEmailController:UIAlertController = UIAlertController()
            
        if ((error) != nil)
        {
            if (error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.")
            {
                    
                alertEmailController = UIAlertController(title: "عذرا", message: "البريد الالكتروني الذي تم ادخاله غير صحيح", preferredStyle: .alert)
                    
            }
                
            else if (error!.localizedDescription == "The password is invalid or the user does not have a password.")
            {
                    
                alertEmailController = UIAlertController(title: "عذرا", message: "كلمة المرور التي تم ادخالها غير صحيحة", preferredStyle: .alert)
            }
                    
                
            else if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
            {
                alertEmailController = UIAlertController(title: "عذرا", message: "خطأ في الشبكة الرجاء اعد المحاولة", preferredStyle: .alert)
            }
                    
                
            else
            {
                    alertEmailController = UIAlertController(title: "عذرا", message: "حدث خطأ ما الرجاء اعد المحاولة", preferredStyle: .alert)
            }
                
            print (error!.localizedDescription)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            self.present(alertEmailController, animated: true, completion: nil)
           // self.dismiss(animated: false, completion: nil)
        }
            
         // Nothing Happened Here
            else
            {
    
                     let userEmail:String = (user?.email)!
                     let endEmailTextIndex = userEmail.index(userEmail.endIndex, offsetBy: -4)
                     var emailTruncatedDotCom = userEmail.substring(to: endEmailTextIndex)
                     let userId = user?.uid as! String
                     WelcomeViewController.user.setUserEmail(email: emailTruncatedDotCom)
                     WelcomeViewController.user.setUpUserId(userId: userId)
                let ref = Database.database().reference().child("Users").child(userId).child("UserName")
                    WelcomeViewController.user.setUserDisplayName(name: (user?.displayName)!)
                var userInstanceId = InstanceID.instanceID().token()
                Database.database().reference().child("Users").child(userId).child("instanceId").setValue(userInstanceId)
                     let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
                     let addItemViewController = mainStoryboard.instantiateViewController(withIdentifier: "PostedItemViewController")
                     self.present(tabViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onClickedSignUp(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
         self.dismiss(animated: false, completion: nil)
    }

}

extension UITextField {
    
    
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    // Next step here
}

