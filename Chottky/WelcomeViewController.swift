//
//  LoginScreen.swift
//  Chottky
//
//  Created by Radi Barq on 3/4/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Lottie


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    public static var user = User()
    
    var loadingAnimation = LOTAnimationView(name: "animation-w500-h500")
    var indicatior = UIActivityIndicatorView()
    var animationSuperView = UIView()
    var indicatioAnimation = LOTAnimationView(name: "animation-w500-h500")
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        
        if( Auth.auth().currentUser != nil)
        {
            let user = Auth.auth().currentUser!
            WelcomeViewController.user.setUpUserId(userId: (user.uid))
            WelcomeViewController.user.setUserEmail(email: (user.email)!)
            WelcomeViewController.user.setUserDisplayName(name: user.displayName!)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
            self.present(tabViewController, animated: true, completion: nil)
            
        }
        
           initializeIndicator()
        
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
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
       // let loginButton = LoginButton(readPermissions: [.publicProfile])
        //loginButton.center = view.center
        //view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
        
       // setUpMenuBar()
        
        self.view.backgroundColor = UIColor.clear
        var backgroundImage = UIImageView()
        backgroundImage.image = #imageLiteral(resourceName: "house-photo")
        self.backgroundView.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImage.contentMode = .scaleAspectFill
        //backgroundImage.widthAnchor.constraint(equalToConstant: self.backgroundView.frame.width).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: self.backgroundView.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true

        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.clear
       // let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
      //  let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
       // blurEffectView.frame = self.view.bounds
       // blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // self.backgroundView.addSubview(blurEffectView)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFacebookButtonClicked(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                
                print("the error is \(error.localizedDescription)")
                let alertController = UIAlertController(title: "حدث خطأ ما في عملية تسجيل الدخول", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            self.addAnimationSuperView()
            
           // var photoUrl = ""
            
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        //facebookResult = value
                      //  photoUrl = facebookResult.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as String
                        
                        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                            if let error = error {
                                // ....
                                print("the error is \(error.localizedDescription)")
                                let alertController = UIAlertController(title: "حدث خطأ ما في عملية تسجيل الدخول", message: error.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                                self.animationSuperView.removeFromSuperview()
                                
                                return
                                
                            }
                            
                            var currentUser = Auth.auth().currentUser!
                            var userInstanceId = InstanceID.instanceID().token()
                            
                            var checkRef = Database.database().reference().child("Users").observe(.value, with: {
                                (snapshot) in
                                
                                if snapshot.hasChild(currentUser.uid){
                                    
                                    Database.database().reference().child("Users").child(currentUser.uid).updateChildValues(["Email": currentUser.email, "UserId": currentUser.uid, "UserName": currentUser.displayName, "instanceId": userInstanceId])
                                        self.animationSuperView.removeFromSuperview()
                                        let user = Auth.auth().currentUser!
                                        WelcomeViewController.user.setUpUserId(userId: (user.uid))
                                        WelcomeViewController.user.setUserEmail(email: (user.email)!)
                                        WelcomeViewController.user.setUserDisplayName(name: user.displayName!)
                                   
                                
                                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
                                        self.present(tabViewController, animated: true, completion: nil)

                                }
                                    
                                else
                                {
                                    
                                   // print("user not signed up")                                Database.database().reference().child("Users").child(currentUser.uid).updateChildValues(["Email": currentUser.email, "UserId": currentUser.uid, "UserName": currentUser.displayName, "instanceId": userInstanceId])
                                    
                                    
                                    let storageRef = Storage.storage().reference().child("Profile_Pictures").child(currentUser.uid).child("Profile.jpg")
                                    
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
                                           
                                            Database.database().reference().child("Users").child(currentUser.uid).updateChildValues(["Email": currentUser.email, "UserId": currentUser.uid, "UserName": currentUser.displayName, "instanceId": userInstanceId])
                                                
                                                let user = Auth.auth().currentUser!
                                                WelcomeViewController.user.setUpUserId(userId: (user.uid))
                                                WelcomeViewController.user.setUserEmail(email: (user.email)!)
                                                WelcomeViewController.user.setUserDisplayName(name: user.displayName!)
                                                self.animationSuperView.removeFromSuperview()
                                                
                                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
                                                self.present(tabViewController, animated: true, completion: nil)
                                                
                                            }
                                    
                                        }
                                        
                                    }
                                    
                                }
                                
                            })
                            
//                            Database.database().reference().child("Users").child(currentUser.uid).updateChildValues(["Email": currentUser.email, "UserId": currentUser.uid, "UserName": currentUser.displayName, "instanceId": userInstanceId])
                            
                            print("user signed in successfully")
                        }
                        
                        //print(value.dictionaryValue![])
                    case .failed(let error):
                        print(error)
                    }
                }
            
//                 var photoUrl = facebookResult.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as String
            }
        }
      
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "signInViewController")
        self.present(loginViewController, animated: false, completion: nil)
    }
    
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "signUpViewController")
        self.present(loginViewController, animated: true, completion: nil)
        
    }
   
    
}
