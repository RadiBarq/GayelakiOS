//
//  SignUpViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/9/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    let passwordMaxLength  = 1000
    let emailMaxLength = 1000
    let userNameLength = 20
    var differenceChecker: Bool?
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButton: UIButton!
    
    
    var loadingAnimation = LOTAnimationView(name: "animation-w500-h500")
    var indicatior = UIActivityIndicatorView()
    var animationSuperView = UIView()
    var indicatioAnimation = LOTAnimationView(name: "animation-w500-h500")
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        initializeIndicator()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        differenceChecker = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        userNameTextField.tag = 2
        UIApplication.shared.isStatusBarHidden = false
     //   UIApplication.shared.statusBarStyle = .lightContent
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        
    }
    
    func initializeIndicator()
    {
        indicatior = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatior.color = Constants.FirstColor
        indicatior.center = self.view.center
        indicatior.backgroundColor = .clear
        self.view.addSubview(indicatior)
    }
    
    func addAnimationSuperView()
    {
        
        self.view.addSubview(animationSuperView)
        animationSuperView.layer.masksToBounds = true
        animationSuperView.translatesAutoresizingMaskIntoConstraints = false
        animationSuperView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        animationSuperView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        animationSuperView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        animationSuperView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        animationSuperView.layer.cornerRadius = 5
        animationSuperView.backgroundColor = Constants.FirstColor.withAlphaComponent(0.85)
        
        animationSuperView.addSubview(indicatioAnimation)
        indicatioAnimation.translatesAutoresizingMaskIntoConstraints = false
        indicatioAnimation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        indicatioAnimation.heightAnchor.constraint(equalToConstant: 100).isActive = true
        indicatioAnimation.centerYAnchor.constraint(equalTo: animationSuperView.centerYAnchor).isActive = true
        indicatioAnimation.centerXAnchor.constraint(equalTo: animationSuperView.centerXAnchor).isActive = true
        indicatioAnimation.animationProgress = 0.0
        indicatioAnimation.loopAnimation = true
        indicatioAnimation.play()
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
    
    func keyboardWillShow(notification: NSNotification) {
        
      if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            
            print(self.signInButton.frame.origin.y.magnitude)
            print(keyboardHeight)
            print(self.view.frame.size.height)

        
                var differentSpace = self.view.frame.size.height - self.signInButton.frame.origin.y.magnitude - keyboardHeight
  
                    self.differenceChecker = true
                    UIView.animate(withDuration: 0.5, delay: 0.4, options: [],
                           animations: {
    
                            
                            self.topImageConstraint.constant =    differentSpace
                            
                            self.view.layoutIfNeeded()
                        
            },
                           completion: nil
            )
        }

        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        
                
                var differentSpace = self.view.frame.size.height - self.signInButton.frame.origin.y
                
                if (self.differenceChecker == true)
                {
                    self.differenceChecker = false
                    
                    
                     UIView.animate(withDuration: 0.5, delay: 0.4, options: [],
                           animations: {
                            
                            
                                    self.topImageConstraint.constant = 40
                                    self.view.layoutIfNeeded()
       
            },
                
                           completion: nil
            )
        }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == emailTextField)
        {
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= emailMaxLength
            
        }
        
        else if (textField == passwordTextField)
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= passwordMaxLength
        }
        
        else
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= userNameLength
        }
    }
    
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        
        signUp()
    }
    
    func signUp()
    {
        
        var alertEmailController = UIAlertController(title: "صيغة البريد الالكتروني غير صحيحة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
        alertEmailController.addAction(defaultAction)
        let emailText:String = emailTextField.text!
        let passwordText:String = passwordTextField.text!
        
        
        if (emailText.isEmail == false)
        {
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else if (passwordText.characters.count < 6)
        {
            
            alertEmailController = UIAlertController(title: "كلمة السر قصيرة جدا", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else
        {
            authenticateWithFirebase(email: emailText, password: passwordText)
        }
    }
    
    func authenticateWithFirebase(email:String, password:String)
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            var alertEmailController:UIAlertController = UIAlertController()
            
            if ((error) != nil)
            {
                if (error!.localizedDescription == "The email address is already in use by another account.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "هاذا البريد الالكتروني تم تسجيله مسبقا", preferredStyle: .alert)
                }
                
                else if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "خطأ في الشبكة الرجاء اعد المحاولة", preferredStyle: .alert)
                }
                
                else
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "حدث خطأ ما الرجاء اعد المحاولة", preferredStyle: .alert)
                }
                
                print (error?.localizedDescription)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
            }
                
            else
            {
                
                let userId = Auth.auth().currentUser!.uid
                self.addNewUserInformationToFirebase(emailText: self.emailTextField.text!, userNameText:  self.userNameTextField.text!, passwordText: self.passwordTextField.text!, userId: userId)
            }
        
        }
    }
    
    // all the work here
    func addNewUserInformationToFirebase(emailText: String, userNameText:String, passwordText:String, userId: String)
    {
        let endEmailTextIndex = emailText.index(emailText.endIndex, offsetBy: -4)
        let emailTruncatedDotCom = emailText.substring(to: endEmailTextIndex)
        let user = ["Email":emailText, "UserName":userNameText, "UserId": userId] // Here TODO The Location Name
        let storageRef = Storage.storage().reference().child("Profile_Pictures").child(userId).child("Profile.jpg")
    
        let firebaseUser = Auth.auth().currentUser
        let changeRequest = firebaseUser?.createProfileChangeRequest()
        changeRequest?.displayName = userNameText
    
        changeRequest?.commitChanges(completion: nil)
        
        self.addAnimationSuperView()
        
        if let uploadData = UIImageJPEGRepresentation(UIImage(named: "black_profile")! , 0.5)
        {
             storageRef.putData(uploadData, metadata: nil)
             {
                (metadata, error) in
                
                if (error != nil)
                {
                    print (error?.localizedDescription)
                    let alertEmailController = UIAlertController(title: "حدث خطأ ما", message: "الرجاء اعد المحاولة لاحقا", preferredStyle: .alert)
                    alertEmailController.view.tintColor = Constants.FirstColor
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: nil)
                    self.animationSuperView.removeFromSuperview()
                }
                    
                else
                {
                    Database.database().reference().child("Users").child(userId).setValue(user)
                    self.animationSuperView.removeFromSuperview()
                    let user = Auth.auth().currentUser!
                    WelcomeViewController.user.setUpUserId(userId: (user.uid))
                    WelcomeViewController.user.setUserEmail(email: (user.email)!)
                    WelcomeViewController.user.setUserDisplayName(name: user.displayName!)
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
                    self.present(tabViewController, animated: true, completion: nil)
                
                }
                
            }
        }
    }
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
      
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.dismiss(animated: true, completion: nil)
      //  self.present(welcomeViewController, animated: true, completion: nil)
       
    }
}
