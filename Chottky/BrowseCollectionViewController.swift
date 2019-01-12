//
//  BrowseViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import SDWebImage
import FirebaseStorageUI
import GeoFire
import Foundation
import Lottie
import UserNotifications

private let reuseIdentifier = "itemCell"

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, CLLocationManagerDelegate, UISearchBarDelegate  {
    
    
    static var browseNavigaionController: UINavigationController?
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    //This the array were we should declare the items keys.
    var itemKeys = [String]() // this is for the geofire here
    var takePhotoButton = UIButton()    
    var indicator = UIActivityIndicatorView()
    let userID = Auth.auth().currentUser!.uid
    var stringLocation = String()
    var locationManager: CLLocationManager = CLLocationManager()
    let geofireRef = Database.database().reference().child("items-location")
    var radius = Int()
    var weGotFirstLocation = false
    var locationDisabledLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var locationDisabledButton  = UIButton(frame: .zero)
    var noItemAvailableLabel = UILabel(frame: .zero)
    var itemsDictionary: [String:Item] = [:]
    
    // these are the category-array of values here mother fucker
    var carCategoryArray = [String]()
    var phoneCategoryArray = [String]()
    var apartmentCategoryArray = [String]()
    var homeCategoryArray = [String]()
    var dogCategoryArray = [String]()
    var sportCategoryArray = [String]()
    var clothesCategoryArray = [String]()
    var kidsCategoryArray = [String]()
    var booksCategoryArray = [String]()
    var otherCategoryArray = [String]()
    static var queryChanged = false
    var finalArray =  [String]()
    var maximumRadius = Int()
    static var arrayLocation = [String]()
    var currentItemsCount = 0
    var favouritesDictionary: [String: Int] = [:]
    var uncommonArray = [String]()
    var pricesHighToLowDictionary: [String: Double]  = [:]
    var pricesLowToHighDictionary: [String: Double] = [:]
    var timestampDictionary: [String: Double] = [:]
    var animationSuperView = UIView()
    var indicatioAnimation = LOTAnimationView(name: "animation-w500-h500")
    var loadingAnimation = LOTAnimationView(name: "browsing-animation.json")
    var notItemsAnimation = LOTAnimationView(name: "not-items-animation.json")
    var dollarCurrenciesPrices: [String:Double] = ["SAR": 3.75,"ILS":3.44, "KWD": 0.3016, "AED": 3.672, "QAR": 3.640, "LYD": 1.359, "OMR": 0.3845,
                                                   "EGP":17.6541, "DZD": 114.343, "IQD": 1179, "MAD": 9.27913, "SDD":699.230, "SDG":6.99230,
                                                   "TND":2.46597, "LBP":1504.17, "SYP":214.550, "YER":249.856, "JOD": 0.70777, "BHD": 0.37456, "MRO": 349.800, "SOS": 548.639, "DJF": 177.296, "KMF": 409.221]
    var searchBar = UISearchBar()
    var searchButtonClicked:Bool = false
    var searchKeys = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //   UIApplication.share fd.setStatusBarHidden(false, with: .none)
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        //        navigationController??.navigationBar.barTintColor = .orange
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.white
        setupLefMenuProfileImage()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.tabBarController?.tabBar.isTranslucent = false
    
        if (BrowseCollectionViewController.queryChanged == true)
        {
            self.noItemAvailableLabel.removeFromSuperview()
            self.notItemsAnimation.removeFromSuperview()
            self.notItemsAnimation.removeFromSuperview()
            self.locationDisabledLabel.removeFromSuperview()
            self.locationDisabledButton.removeFromSuperview()
            initializeItems()
            addAnimationSuperView()
            
            if (BrowseSettingsTableViewController.selectedDistanceIndex == 0)
            {
                 maximumRadius = 1
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 1)
            {
                maximumRadius = 5
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 2)
            {
                maximumRadius = 10
                
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 3)
            {
                maximumRadius = 50
            }
            
            getItems()
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(ItemsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        BrowseCollectionViewController.browseNavigaionController = self.navigationController
        
        CollectionsCollectionViewController.browsingViewController = self

        self.navigationController?.navigationBar.isTranslucent = false
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.white
        //statusBar.tintColor = UIColor.white
        
        // notifications stuff
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        radius = 5
        maximumRadius = 50
        
        var leftMenuViewController = LeftMenuTableViewController()
       leftMenuViewController.browsingViewController = self
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: leftMenuViewController)
        menuLeftNavigationController.leftSide = true
   
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.MenuPresentMode.menuDissolveIn
        SideMenuManager.menuAnimationBackgroundColor = UIColor.white
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        databaseRef = Database.database().reference().child("items")
        storageRef = Storage.storage().reference(withPath: "Items_Photos")
        
        initializeIndicatior()
        indicator.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        setupNavigationBarItems()
        
        _ = Timer.scheduledTimer(withTimeInterval: 30000000000, repeats: true) { (
            time) in
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.weGotFirstLocation = false
            self.locationManager.delegate = self
            
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        addAnimationSuperView()
    }
    
    
   // func playLoadingAnimation()
    //{
      //  self.view.addSubview(loadingAnimation!)
        //loadingAnimation?.backgroundColor = UIColor.clear
        //self.view.bringSubview(toFront: loadingAnimation!)
        //finalArray = []
        //self.collectionView?.reloadData()
        //loadingAnimation?.translatesAutoresizingMaskIntoConstraints = false
        //loadingAnimation?.widthAnchor.constraint(equalToConstant: 500).isActive = true
        //loadingAnimation?.heightAnchor.constraint(equalToConstant: 500).isActive = true
        //loadingAnimation?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //loadingAnimation?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //loadingAnimation?.animationProgress = 0.0
        //loadingAnimation?.loopAnimation = true
        //loadingAnimation?.play()
        //self.collectionView?.isUserInteractionEnabled = false
    
    //}
    
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
        self.collectionView?.isUserInteractionEnabled = false
    }

    func setupNavigationBarItems()
    {
        
        var image = #imageLiteral(resourceName: "menu")
        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, 
        action:#selector(onClickBrowseSettings))
        searchBar = UISearchBar()
        searchBar.placeholder = "ابحث في جايلك"
        searchBar.tintColor = Constants.FirstColor
        searchBar.delegate = self
        //searchBar.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:50))
        var logoImage = UIImageView()
        logoImage.image = #imageLiteral(resourceName: "g30-white")
        logoImage.contentMode = .scaleAspectFit
        
        var logoLabel = UILabel()
        logoLabel.text = "GAYELAK"
        logoLabel.textAlignment = .center
        logoLabel.textColor = Constants.FirstColor
        logoLabel.font = UIFont(name: "DINRundschriftMittel",size: 40)
        
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: 45, height: 45))
        //userImageView.contentMode = .scaleAspectFit
        //userImageView.image = #imageLiteral(resourceName: "face-4")
        userImageView.layer.masksToBounds = true
      //  userImageView.image = #imageLiteral(resourceName: "face-4")
        userImageView.layer.cornerRadius = 20
        
        logoContainer.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoLabel.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor, constant:-5).isActive = true
        
        //self.navigationController?.view.addSubview(userImageView)
        //userImageView.translatesAutoresizingMaskIntoConstraints = false
        //userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //userImageView.topAnchor.constraint(equalTo: (self.navigationController?.view.topAnchor)!, constant: 30).isActive = true
        //logoImage.translar
        
       // let button = UIButton.init(type: .custom)
        
       // button.setImage(#imageLiteral(resourceName: "face-4"), for: .normal)
       // button.addTarget(self, action:#selector(ViewController.callMethod), for:.touchUpInside)
        //button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        //let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.leftBarButtonItem = barButton
        
        self.navigationItem.titleView = logoContainer
       // userImageView.leftAnchor.constraint(equalTo: (self.navigationController?.view.leftAnchor)!, constant: 15).isActive = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onClickOpenSideBar))
        singleTap.numberOfTapsRequired = 1
       // let userImage = UIImage()
        
        let logoImageView = UIImageView()
        var imageStorageRef: StorageReference = Storage.storage().reference(withPath: "Profile_Pictures")
        imageStorageRef = imageStorageRef.child(userID + "/" + "Profile.jpg")
        logoImageView.sd_setImage(with: imageStorageRef)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:35,height:35.0)
       // logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.masksToBounds = true
        logoImageView.layer.cornerRadius = 17.5
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(singleTap)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 35)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 35)
        
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem

    }
    
    func onClickOpenSideBar()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
      public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.noItemAvailableLabel.removeFromSuperview()
        self.notItemsAnimation.removeFromSuperview()
        self.locationDisabledLabel.removeFromSuperview()
        self.locationDisabledButton.removeFromSuperview()
        searchKeys = (searchBar.text?.lowercased().components(separatedBy: " "))!
        searchButtonClicked = true
        self.itemKeys = []
        addAnimationSuperView()
        initializeItems()
        self.getItems()
        
    }
    
    // this function used to clear the textfield somehow
     public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {

               self.noItemAvailableLabel.removeFromSuperview()
               self.notItemsAnimation.removeFromSuperview()
               self.locationDisabledLabel.removeFromSuperview()
               self.locationDisabledButton.removeFromSuperview()
                BrowseCollectionViewController.queryChanged = true
               addAnimationSuperView()
               initializeItems()
               self.getItems()
        }
    }
    func onClickBrowseSettings()
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let browseSetttingsController = mainStoryboard.instantiateViewController(withIdentifier: "browseSettingsTableViewController") as! BrowseSettingsTableViewController
        self.navigationController?.pushViewController(browseSetttingsController, animated: true)
    }
    
    func presseTakePhotoButton(button: UIButton) {
        
        // At the end of this, remember to add this.
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
       // self.navigationController?.pushViewController(cameraViewController, animated: true)
    }
    
    func initializeNoItemAvailable()
    {
        self.view.addSubview(noItemAvailableLabel)
        noItemAvailableLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemAvailableLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        noItemAvailableLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        noItemAvailableLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        noItemAvailableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noItemAvailableLabel.textColor = UIColor(red: 116/255, green: 121/255, blue: 142/255, alpha: 255/255)
        noItemAvailableLabel.lineBreakMode = .byWordWrapping
        noItemAvailableLabel.numberOfLines = 2
        noItemAvailableLabel.text = "لم نتمكن من ايجاد اي نتائج بالقرب منك، حاول البحث عن شئ اخر او حاول في وقت لاحق!"
        noItemAvailableLabel.textAlignment = .center
        self.view.addSubview(notItemsAnimation)
        notItemsAnimation.translatesAutoresizingMaskIntoConstraints = false
        notItemsAnimation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        notItemsAnimation.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        notItemsAnimation.widthAnchor.constraint(equalToConstant: 300).isActive = true
        notItemsAnimation.heightAnchor.constraint(equalToConstant: 300).isActive = true
        notItemsAnimation.play()
        notItemsAnimation.loopAnimation = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
            if indexPath.row + 1 == finalArray.count {
                
                if (radius <= maximumRadius)
                {
                    self.radius = self.radius + 10
                    addAnimationSuperView()
                    itemKeys = []
                    self.getItems()
                }
            }
        }
    
    func fetchGeofireDataToDictionary()
    {
        
        itemsDictionary = [:] // this is how to make the dictionary empty in this case
        favouritesDictionary = [:]
        pricesHighToLowDictionary = [:]
        pricesLowToHighDictionary = [:]
        self.timestampDictionary = [:]
        for i in 0..<uncommonArray.count
        {
            var oneItem = Item()
            var valueRef = Database.database().reference().child("items").child(uncommonArray[i]).observeSingleEvent(of: .value, with: {(snapshot)
                in
                for item in snapshot.children
                {
                    
                    var childValue = String(describing: (item as! DataSnapshot).value!) // Remeber this value maybe value.
                    let childKey = String(describing: (item as! DataSnapshot).key)
                    
                    if (childKey == "category")
                    {
                        oneItem.category = childValue as! String
                        
                        if (childValue == "category-car")
                        {
                            self.carCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else if (childValue == "phone-category")
                        {
                            self.phoneCategoryArray.append(self.uncommonArray[i])
                        }
                        
                        else if (childValue == "category-aparment")
                        {
                            self.apartmentCategoryArray.append(self.uncommonArray[i])
                            
                        }
                            
                        else if (childValue == "category-home")
                        {
                            self.homeCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else if (childValue == "category-dog")
                        {
                            self.dogCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else if (childValue == "category-sport")
                        {
                            self.sportCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else if (childValue == "category-clothes")
                        {
                            self.clothesCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else if (childValue == "category-kids")
                        {
                            
                            self.kidsCategoryArray.append(self.uncommonArray[i])
    
                        }
                            
                        else if (childValue == "category-books")
                        {
                            
                            self.booksCategoryArray.append(self.uncommonArray[i])

                        }
                            
                        else if (childValue == "category-others")
                        {
                            self.otherCategoryArray.append(self.uncommonArray[i])
                        }
                            
                        else
                        {
                            print("There is an issue with the category-type fellow")
                        }
                    }
                
                    else if (childKey == "currency")
                    {
                        oneItem.currency = childValue as! String
                    }
                    
                    else if (childKey == "description")
                    {
                        
                        oneItem.description = childValue as String
                    }
                        
                    else if (childKey == "displayName")
                    {
                        oneItem.displayName = childValue as! String
                    }
                        
                    else if (childKey == "imagesCount")
                    {
                        
                        oneItem.imagesCount = childValue as! String
                    }

                    else if (childKey == "price")
                    {
                        oneItem.price = childValue as! String
                        
                        if (childValue as! String == "غير محدد")
                        {
                            childValue = "0"
                        }
                        
                         var price = Double(childValue)
                         let local = Locale.current
                        
                        if (oneItem.currency == "$" && self.dollarCurrenciesPrices[local.currencyCode!] != nil)
                        {
            
                            price = price! * self.dollarCurrenciesPrices[local.currencyCode!]!

                        }
                        
                        self.pricesHighToLowDictionary[self.uncommonArray[i]] = price
                        self.pricesLowToHighDictionary[self.uncommonArray[i]] = price
                    }
                        
                    else if (childKey == "timestamp")
                    {
                        oneItem.timestamp = childValue as! String
                        var timestamp = Double(childValue)
                        self.timestampDictionary[self.uncommonArray[i]] = timestamp
                    }
                        
                    else if (childKey == "title")
                    {
                        
                        oneItem.title = childValue as! String
                    }
                        
                    else if (childKey == "userId")
                    {
                        oneItem.userId = childValue as! String
                    }
                        
                    else if (childKey == "favourites")
                    {
                        var numberOfFavourites = Int(childValue)
                        self.favouritesDictionary[self.uncommonArray[i]] = numberOfFavourites
                        oneItem.itemPrice = childValue as! String
                    }
                        
                    else
                    {
                        print("On of the keys is wrong in this case my lord.")
                    }
                    
                    self.itemsDictionary[self.uncommonArray[i]] = oneItem
                }
                
                
                if (i == self.uncommonArray.count - 1)
                {
                    // so here sorting the uncommonArray according to favourites here
                   // var keys = Array(self.favouritesDictionary.keys)
            
                    if (BrowseSettingsTableViewController.selectedsortedByIndex == 0)
                    {
                            self.favouritesQuery()
                    }
                    
                    else if (BrowseSettingsTableViewController.selectedsortedByIndex == 1)
                    {
                        self.pricesHighToLowQuery()
                    }
                    
                    else if (BrowseSettingsTableViewController.selectedsortedByIndex == 2)
                    {
                        self.pricesLowToHighQuery()
                    }
                    
                    else
                    {
                        self.newestQuery()
                    }
                }
            })
        }
    }
    
    func itemsSearchQuery()
    {
        var fetchedKeys = [String]()
        var keysRef = Database.database().reference().child("tags")
        
        var counter = 0
        for key in searchKeys
        {
            var keys = [String]()
        
            keysRef.child(key).observeSingleEvent(of: .value) { (snapshot, error) in
                
                if (error == nil)
                {
                    for item in snapshot.children
                    {
                        var childKey = String(describing: (item as! DataSnapshot).key)
                        keys.append(childKey)
                    }
                    
                    if (counter == 0)
                    {
                        fetchedKeys = keys
                    }
                
                    else
                    {
                        var fetchedSet = Set(fetchedKeys)
                        var keysSet = Set(keys)
                        fetchedSet = fetchedSet.intersection(keysSet)
                        fetchedKeys = Array(fetchedSet)
                    }
                    
                    if (counter == self.searchKeys.count - 1)
                    {
                    
                        
                        var finalSet = Set(self.finalArray)
                        var fetchedSet = Set(fetchedKeys)
                        finalSet = finalSet.intersection(fetchedSet)
                        self.finalArray = Array(finalSet)
                        
                        if (self.finalArray.count < 12)
                        {
                            
                            if (self.radius < self.maximumRadius)
                            {
                                self.radius = self.radius + 10
                                self.itemKeys = []
                                 self.currentItemsCount = self.finalArray.count
                                self.getItems()
                            }
                            
                            else
                            {
                                if (self.finalArray.count == 0)
                                {
                                    self.currentItemsCount = 0
                                    self.initializeNoItemAvailable()
                                    self.animationSuperView.removeFromSuperview()
                                    self.collectionView?.reloadData()
                                    self.collectionView?.isUserInteractionEnabled = true
                                    BrowseCollectionViewController.queryChanged = false
                                    self.searchButtonClicked = false
                                }
                                
                                else
                                {
                                    self.currentItemsCount = self.finalArray.count
                                    self.collectionView?.reloadData()
                                    
                                    if (BrowseCollectionViewController.queryChanged == true)
                                    {
                                        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                                          at: .top,
                                                                          animated: true)
                                        BrowseCollectionViewController.queryChanged = false
                                    }
                                    
                                    self.animationSuperView.removeFromSuperview()
                                    self.collectionView?.isUserInteractionEnabled = true
                                    self.searchButtonClicked = false
                                    
                                }
                            }
                        }
                        
                        else
                        {
                            self.currentItemsCount = self.finalArray.count
                            self.collectionView?.reloadData()
                        
                            if (BrowseCollectionViewController.queryChanged == true)
                            {
                                self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                              at: .top,
                                                              animated: true)
                                
                                BrowseCollectionViewController.queryChanged = false
                            }
                        
                                self.animationSuperView.removeFromSuperview()
                                self.collectionView?.isUserInteractionEnabled = true
                                self.searchButtonClicked = false
                          }
                     }
                }
                 
                else
                {
                    // we had to work on that
                    print("error happened while searching")
                    
                }
                
                   counter = counter + 1
            }
        }
    }
    
    func favouritesQuery()
    {
        
        var itemsRef = Database.database().reference().child("items")
        var tempArray = [String]()
        var checkIfAtLeastOneChecked = false
        var categoryFavouritesDic: [String: Int] = [:]
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![0] == 1)
        {
            //cars
            // carsSet = carsSet.intersection(givenSet)
            tempArray.mergeElements(newElements:  carCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![1] == 1)
        {
            //electronics
            //phonesSet =  phonesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: phoneCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![2] == 1)
        {
            // lands and aparatments
            //  apartmentSet =  apartmentSet.intersection(givenSet)
            tempArray.mergeElements(newElements: apartmentCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![3] == 1)
        {
            // home and garden
            // homeSet = homeSet.intersection(givenSet)
            tempArray.mergeElements(newElements: homeCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![4] == 1)
        {
            // animals
            //dogSet = dogSet.intersection(givenSet)
            tempArray.mergeElements(newElements: dogCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![5] == 1)
        {
            //sports and games
            // sportSet = sportSet.intersection(givenSet)
            tempArray.mergeElements(newElements: sportCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![6] == 1)
        {
            // clothes and accessories
            // clothesSet = clothesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: clothesCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![7] == 1)
        {
            //kids
            //kidsSet = kidsSet.intersection(givenSet)
            tempArray.mergeElements(newElements: kidsCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![8] == 1)
        {
            // books and movies
            //booksSet = booksSet.intersection(givenSet)
            tempArray.mergeElements(newElements: booksCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![9] == 1)
        {
            // others
            // othersSet = othersSet.intersection(givenSet)
            tempArray.mergeElements(newElements: otherCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (tempArray.count != 0)
        {
            for item in tempArray
            {
                categoryFavouritesDic[item] = self.favouritesDictionary[item]
            }

            self.uncommonArray = tempArray
            self.uncommonArray.sort{ (o1, o2) -> Bool in
                return categoryFavouritesDic[o1]! as! Int > categoryFavouritesDic[o2]! as! Int
            }
        
            self.finalArray = self.finalArray + self.uncommonArray
            self.currentItemsCount = self.finalArray.count
            
        }
            
        else
        {
            if (checkIfAtLeastOneChecked == true)
            {
                
                if (radius>maximumRadius && finalArray.count == 0)
                {
                    self.finalArray = tempArray
                    initializeNoItemAvailable()
                   self.animationSuperView.removeFromSuperview()
                    self.collectionView?.reloadData()
                    self.collectionView?.isUserInteractionEnabled = true
                    BrowseCollectionViewController.queryChanged = false
                    self.currentItemsCount = 0
                    return
                }
                    
                else
                {
                    self.currentItemsCount = finalArray.count
                }
            }
                
            else
            {
                self.uncommonArray.sort{ (o1, o2) -> Bool in
                    return self.favouritesDictionary[o1]! as! Int > self.favouritesDictionary[o2]! as! Int
                }
                
                self.finalArray = self.finalArray + self.uncommonArray
                self.currentItemsCount = self.finalArray.count
            }
        }
        
    
        if (finalArray.count < 12 && radius<=maximumRadius)
        {
            self.radius = self.radius + 10
            itemKeys = []
            self.getItems()
        }
            
        else
        {
            if (searchButtonClicked == true){
        
                self.itemsSearchQuery()
            }
                
            else
            {
            
            self.collectionView?.reloadData()
            
            if (BrowseCollectionViewController.queryChanged == true)
            {
                
                self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
                BrowseCollectionViewController.queryChanged = false
            }

            self.animationSuperView.removeFromSuperview()
            self.collectionView?.isUserInteractionEnabled = true
        }
    }
    }
    
    func pricesHighToLowQuery()
    {
        var tempArray = [String]()
        var checkIfAtLeastOneChecked = false
        var categoryPricesDic: [String: Double] = [:]
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![0] == 1)
        {
            //cars
            // carsSet = carsSet.intersection(givenSet)
            tempArray.mergeElements(newElements:  carCategoryArray)
            checkIfAtLeastOneChecked = true
            
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![1] == 1)
        {
            //electronics
            //phonesSet =  phonesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: phoneCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![2] == 1)
        {
            // lands and aparatments
            //  apartmentSet =  apartmentSet.intersection(givenSet)
            tempArray.mergeElements(newElements: apartmentCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![3] == 1)
        {
            // home and garden
            // homeSet = homeSet.intersection(givenSet)
            tempArray.mergeElements(newElements: homeCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![4] == 1)
        {
            // animals
            //dogSet = dogSet.intersection(givenSet)
            tempArray.mergeElements(newElements: dogCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![5] == 1)
        {
            //sports and games
            // sportSet = sportSet.intersection(givenSet)
            tempArray.mergeElements(newElements: sportCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![6] == 1)
        {
            // clothes and accessories
            // clothesSet = clothesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: clothesCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![7] == 1)
        {
            //kids
            //kidsSet = kidsSet.intersection(givenSet)
            tempArray.mergeElements(newElements: kidsCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![8] == 1)
        {
            // books and movies
            //booksSet = booksSet.intersection(givenSet)
            tempArray.mergeElements(newElements: booksCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![9] == 1)
        {
            // others
            // othersSet = othersSet.intersection(givenSet)
            tempArray.mergeElements(newElements: otherCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (tempArray.count != 0)
        {
            for item in tempArray
            {
                categoryPricesDic[item] = self.pricesHighToLowDictionary[item]
            }
            
            self.uncommonArray = tempArray
            self.uncommonArray.sort{ (o1, o2) -> Bool in
                return categoryPricesDic[o1]! as! Double > categoryPricesDic[o2]! as! Double
            }
            
            self.finalArray = self.finalArray + self.uncommonArray
            self.currentItemsCount = self.finalArray.count
        }
            
        else
        {
            if (checkIfAtLeastOneChecked == true)
            {
                
                if (radius>maximumRadius && finalArray.count == 0)
                {
                    self.finalArray = tempArray
                    initializeNoItemAvailable()
                    self.animationSuperView.removeFromSuperview()
                    self.collectionView?.reloadData()
                    self.collectionView?.isUserInteractionEnabled = true
                    BrowseCollectionViewController.queryChanged = false
                    self.currentItemsCount = 0
                    return
                }
                    
                else
                {
                    self.currentItemsCount = finalArray.count
                }
            }
                
            else
            {
                self.uncommonArray.sort{ (o1, o2) -> Bool in
                    return self.pricesHighToLowDictionary[o1]! > self.pricesHighToLowDictionary[o2]!
                }
                
                self.finalArray = self.finalArray + self.uncommonArray
                self.currentItemsCount = self.finalArray.count
            }
        }
        
        if (finalArray.count < 12 && radius<=maximumRadius)
        {
            self.radius = self.radius + 10
            itemKeys = []
            self.getItems()
        }
            
        else
        {
            if (searchButtonClicked == true){
                
                self.itemsSearchQuery()
            }
                
            else
            {
                self.collectionView?.reloadData()
            
                if (BrowseCollectionViewController.queryChanged == true)
                {
                
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
                    BrowseCollectionViewController.queryChanged = false
                }
            
                 self.animationSuperView.removeFromSuperview()
                self.collectionView?.isUserInteractionEnabled = true
            }
        }
    }
    
    func newestQuery()
    {
   
        var tempArray = [String]()
        var checkIfAtLeastOneChecked = false
        var categoryTimeStampDic: [String: Double] = [:]
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![0] == 1)
        {
            //cars
            // carsSet = carsSet.intersection(givenSet)
            tempArray.mergeElements(newElements:  carCategoryArray)
            checkIfAtLeastOneChecked = true
            
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![1] == 1)
        {
            //electronics
            //phonesSet =  phonesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: phoneCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![2] == 1)
        {
            // lands and aparatments
            //  apartmentSet =  apartmentSet.intersection(givenSet)
            tempArray.mergeElements(newElements: apartmentCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![3] == 1)
        {
            // home and garden
            // homeSet = homeSet.intersection(givenSet)
            tempArray.mergeElements(newElements: homeCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![4] == 1)
        {
            // animals
            //dogSet = dogSet.intersection(givenSet)
            tempArray.mergeElements(newElements: dogCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![5] == 1)
        {
            //sports and games
            // sportSet = sportSet.intersection(givenSet)
            tempArray.mergeElements(newElements: sportCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![6] == 1)
        {
            // clothes and accessories
            // clothesSet = clothesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: clothesCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![7] == 1)
        {
            //kids
            //kidsSet = kidsSet.intersection(givenSet)
            tempArray.mergeElements(newElements: kidsCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![8] == 1)
        {
            // books and movies
            //booksSet = booksSet.intersection(givenSet)
            tempArray.mergeElements(newElements: booksCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![9] == 1)
        {
            // others
            // othersSet = othersSet.intersection(givenSet)
            tempArray.mergeElements(newElements: otherCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (tempArray.count != 0)
        {
            for item in tempArray
            {
                categoryTimeStampDic[item] = self.timestampDictionary[item]
            }
            
            self.uncommonArray = tempArray
            self.uncommonArray.sort{ (o1, o2) -> Bool in
                return categoryTimeStampDic[o1]! > categoryTimeStampDic[o2]!
            }
            
            
            self.finalArray = self.finalArray + self.uncommonArray
            self.currentItemsCount = self.finalArray.count
        }
            
        else
        {
            
            if (checkIfAtLeastOneChecked == true)
            {
                
                if (radius>maximumRadius && finalArray.count == 0)
                {
                    self.finalArray = tempArray
                    initializeNoItemAvailable()
                    self.animationSuperView.removeFromSuperview()
                    self.collectionView?.reloadData()
                    self.collectionView?.isUserInteractionEnabled = true
                    BrowseCollectionViewController.queryChanged = false
                    self.currentItemsCount = 0
                    return
                }
                    
                else
                {
                    self.currentItemsCount = finalArray.count
                }
            }
                
            else
            {
                self.uncommonArray.sort{ (o1, o2) -> Bool in
                    return self.timestampDictionary[o1]! > self.timestampDictionary[o2]!
                }
                
                self.finalArray = self.finalArray + self.uncommonArray
                self.currentItemsCount = self.finalArray.count
                
            }
        }
        
        if (finalArray.count < 12 && radius<=maximumRadius)
        {
            self.radius = self.radius + 10
            itemKeys = []
            self.getItems()
        }
            
        else
        {
            
            if (searchButtonClicked == true){
                
                self.itemsSearchQuery()
            }
        
            else
            {
                self.collectionView?.reloadData()
                if (BrowseCollectionViewController.queryChanged == true)
                {
                
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
                    BrowseCollectionViewController.queryChanged = false
                }
                
                self.animationSuperView.removeFromSuperview()
                self.collectionView?.isUserInteractionEnabled = true
            }
        }
    }
    
    
    func pricesLowToHighQuery()
    {
        var itemsRef = Database.database().reference().child("items")
        let givenSet:Set<String> = Set(finalArray)
        var carsSet:Set<String> = Set(carCategoryArray)
        var phonesSet:Set<String> = Set(phoneCategoryArray)
        var apartmentSet:Set<String> = Set(apartmentCategoryArray)
        var homeSet: Set<String> = Set(homeCategoryArray)
        var dogSet: Set<String> = Set(dogCategoryArray)
        var sportSet: Set<String> = Set(sportCategoryArray)
        var clothesSet: Set<String> = Set(clothesCategoryArray)
        var kidsSet: Set<String> = Set(kidsCategoryArray)
        var booksSet: Set<String> = Set(booksCategoryArray)
        var othersSet: Set<String> = Set(otherCategoryArray)
        var finalSet: Set<String> = Set()
        var tempArray = [String]()
        var checkIfAtLeastOneChecked = false
        var categoryPricesDic: [String: Double] = [:]
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![0] == 1)
        {
            //cars
            // carsSet = carsSet.intersection(givenSet)
            tempArray.mergeElements(newElements:  carCategoryArray)
            checkIfAtLeastOneChecked = true
            

        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![1] == 1)
        {
            //electronics
            //phonesSet =  phonesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: phoneCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![2] == 1)
        {
            // lands and aparatments
            //  apartmentSet =  apartmentSet.intersection(givenSet)
            tempArray.mergeElements(newElements: apartmentCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![3] == 1)
        {
            // home and garden
            // homeSet = homeSet.intersection(givenSet)
            tempArray.mergeElements(newElements: homeCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![4] == 1)
        {
            // animals
            //dogSet = dogSet.intersection(givenSet)
            tempArray.mergeElements(newElements: dogCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![5] == 1)
        {
            //sports and games
            // sportSet = sportSet.intersection(givenSet)
            tempArray.mergeElements(newElements: sportCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![6] == 1)
        {
            // clothes and accessories
            // clothesSet = clothesSet.intersection(givenSet)
            tempArray.mergeElements(newElements: clothesCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![7] == 1)
        {
            //kids
            //kidsSet = kidsSet.intersection(givenSet)
            tempArray.mergeElements(newElements: kidsCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![8] == 1)
        {
            // books and movies
            //booksSet = booksSet.intersection(givenSet)
            tempArray.mergeElements(newElements: booksCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![9] == 1)
        {
            // others
            // othersSet = othersSet.intersection(givenSet)
            tempArray.mergeElements(newElements: otherCategoryArray)
            checkIfAtLeastOneChecked = true
        }
        
        if (tempArray.count != 0)
        {
            for item in tempArray
            {
                categoryPricesDic[item] = self.pricesLowToHighDictionary[item]
            }
            
            self.uncommonArray = tempArray
            self.uncommonArray.sort{ (o1, o2) -> Bool in
                return categoryPricesDic[o2]! > categoryPricesDic[o1]!
            }
            
            self.finalArray = self.finalArray + self.uncommonArray
            self.currentItemsCount = self.finalArray.count
        }
            
        else
        {
            if (checkIfAtLeastOneChecked == true)
            {
                
                if (radius>maximumRadius && finalArray.count == 0)
                {
                    self.finalArray = tempArray
                    initializeNoItemAvailable()
                    self.animationSuperView.removeFromSuperview()
                    self.collectionView?.reloadData()
                    self.collectionView?.isUserInteractionEnabled = true
                    BrowseCollectionViewController.queryChanged = false
                    self.currentItemsCount = 0
                    return
                }
                    
                else
                {
                    self.currentItemsCount = finalArray.count
                }
            }
                
            else
            {
                self.uncommonArray.sort{ (o1, o2) -> Bool in
                    return self.pricesLowToHighDictionary[o2]! > self.pricesLowToHighDictionary[o1]!
                }
                
                self.finalArray = self.finalArray + self.uncommonArray
                self.currentItemsCount = self.finalArray.count
            }
        }
        
        if (finalArray.count < 12 && radius<=maximumRadius)
        {
            self.radius = self.radius + 10
            itemKeys = []
            self.getItems()
        }
            
        else
        {
            
            if (searchButtonClicked == true){
                
                self.itemsSearchQuery()
                
            }
    
            else{
                
                self.collectionView?.reloadData()
                if (BrowseCollectionViewController.queryChanged == true)
                {
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
                    BrowseCollectionViewController.queryChanged = false
                }
            
                self.animationSuperView.removeFromSuperview()
                self.collectionView?.isUserInteractionEnabled = true
            }
        }
    }
    
    func addSellItemButton()
    {
        var takePhotoButton = UIButton()
        takePhotoButton.layer.cornerRadius = 25
        takePhotoButton.layer.masksToBounds = true
        takePhotoButton.frame = CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 75 , width:150 , height:60)
        takePhotoButton.backgroundColor = Constants.FirstColor
        takePhotoButton.layer.shadowOpacity = 5
        //  takePhotoButton.tintColor = UIColor.red
        takePhotoButton.layer.shadowColor = UIColor.black.cgColor
        takePhotoButton.layer.shadowOffset = CGSize.zero
        takePhotoButton.layer.shadowRadius = 10
        takePhotoButton.setTitle("بيع الاشياء خاصتك", for: UIControlState.normal)
        takePhotoButton.addTarget(self, action: #selector(presseTakePhotoButton(button:)), for: .touchUpInside)
        //then make a action method :
        super.view.addSubview(takePhotoButton)
    }
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)

    }

    func setupLefMenuProfileImage()
    {
        
        var imageStorageRef: StorageReference = Storage.storage().reference(withPath: "Profile_Pictures")
        imageStorageRef = imageStorageRef.child(userID + "/" + "Profile.jpg")
        LeftMenuTableViewController.profileImageView.sd_setImage(with: imageStorageRef)
        
    }
    
    func initializeItems()
    {
         itemKeys = []
         finalArray = []
         radius = 5
         currentItemsCount = 0
         carCategoryArray = []
         phoneCategoryArray = []
         apartmentCategoryArray = []
         homeCategoryArray = []
         dogCategoryArray = []
         sportCategoryArray = []
         clothesCategoryArray = []
         kidsCategoryArray = []
         booksCategoryArray = []
         otherCategoryArray = []
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of items
        return finalArray.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemsCell
        cell.backgroundColor = UIColor.white
        let imageRef = storageRef.child(finalArray[indexPath.row]).child("1.jpeg")
        // let placeholderImage = UIImage(named: "placeholder.jpg")
        
        //var image = UIImage()
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.gray)
        cell.itemImageView.sd_addActivityIndicator()
        cell.itemImageView.sd_setImage(with: imageRef,  placeholderImage: nil, completion:
            
            {  (image, error, cache, ref) in
                
                cell.itemImageView.sd_removeActivityIndicator()
                //  self.loadedImages[indexPath.item] = image
        })
        
        //cell.itemImageView.sd_showActivityIndicatorView()
        //cell.itemImageView.sd_setIndicatorStyle(.gray)
        return cell
        

    }
    
    @IBAction func onClickShowMenu(_ sender: UIButton) {
        
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return true
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        
        if (weGotFirstLocation == false)
        {
            let latestLocation: CLLocation = locations[locations.count - 1]
            stringLocation = String(latestLocation.coordinate.latitude)  + " " + String(latestLocation.coordinate.longitude)
            print(stringLocation)
            locationManager.stopUpdatingLocation()
            weGotFirstLocation = true
            itemKeys = []
            self.locationDisabledLabel.removeFromSuperview()
            self.locationDisabledButton.removeFromSuperview()
            getItems()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                initializeDisabledLocationComponents()
                print("Location services are not enabled")
                itemKeys = []
                weGotFirstLocation = false
                self.collectionView?.reloadData()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
            
            
        else {
            
        }
    }
    
    func initializeDisabledLocationComponents()
    {
        var alertEmailController = UIAlertController(title: "لم يتمكن جايلك من الحصول على موقعك", message: "لتمكين خدمة الموقع الرجاء الذهاب الى الاعدادات و من ثم Gayelak و من ثم الموقع و من ثم تمكين خدمة الموقع اثناء استخدام التطبيق", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
        alertEmailController.addAction(defaultAction)
        self.present(alertEmailController, animated: true, completion: nil)
        
        // initalize location disabled label
        self.view.addSubview(locationDisabledLabel)
        locationDisabledLabel.translatesAutoresizingMaskIntoConstraints = false
        locationDisabledLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        locationDisabledLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        locationDisabledLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationDisabledLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationDisabledLabel.textColor = Constants.FirstColor
        locationDisabledLabel.text = "لم يتمكن جايلك من الحصول على موقعك"
        
        locationDisabledButton.setTitle("الذهاب الى الاعدادات", for: .normal)
        locationDisabledButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(locationDisabledButton)
        locationDisabledButton.addTarget(self, action: #selector(goToLocationSettings), for: .touchUpInside)
        locationDisabledButton.backgroundColor = Constants.FirstColor
        locationDisabledButton.topAnchor.constraint(equalTo:  locationDisabledLabel.bottomAnchor, constant: 50).isActive = true
        locationDisabledButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationDisabledButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
        locationDisabledButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        locationDisabledButton.layer.cornerRadius = 35
        locationDisabledButton.layer.masksToBounds = true
    }
    
    func goToLocationSettings()
    {
        UIApplication.shared.open(URL(string:"App-Prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
        print("hi")
    }
    
    func getItems()
    {
        // we should make sure that the location is available here.
        BrowseCollectionViewController.arrayLocation = stringLocation.components(separatedBy: " ")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let lat = Double(BrowseCollectionViewController.arrayLocation[0])
        let lon = Double(BrowseCollectionViewController.arrayLocation[1])
        var queryHandle = geoFire.query(at: CLLocation(latitude: lat!, longitude: lon!), withRadius: Double(radius))
        
        queryHandle.observe(.keyEntered) { (key, location) in
            
            self.itemKeys.append(key)
        }
    
        queryHandle.observeReady({
            
           if (self.itemKeys.count == 0 && self.radius > self.maximumRadius)
            {
               self.animationSuperView.removeFromSuperview()
               self.collectionView?.isUserInteractionEnabled = true
               self.initializeNoItemAvailable()
            }
            
           else if (self.itemKeys.count - self.currentItemsCount < 12 && self.radius <= self.maximumRadius) //&& self.radius <= self.maximumRadius
           {
               self.radius = self.radius + 10
               self.itemKeys = []
               self.getItems()
            }
            
            else
            {
                self.carCategoryArray = []
                self.phoneCategoryArray = []
                self.apartmentCategoryArray = []
                self.homeCategoryArray = []
                self.dogCategoryArray = []
                self.sportCategoryArray = []
                self.clothesCategoryArray = []
                self.kidsCategoryArray = []
                self.booksCategoryArray = []
                self.otherCategoryArray = []
            
                 self.uncommonArray = self.itemKeys.filter{ item in !self.finalArray.contains(item)}
             //   self.itemKeys = self.currentKeys
             //   self.finalArray = self.itemKeys
                self.fetchGeofireDataToDictionary()
                queryHandle.removeAllObservers()
          }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.navigationController?.navigationBar.isTranslucent = false
        
        ItemViewController.itemKey = finalArray[indexPath.item]
        let itemStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //self.navigationController?.navigationBar.isTranslucent = true
        let itemViewController = itemStoryBoard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        self.navigationController?.pushViewController(itemViewController, animated: true)
        ItemViewController.isItOpenedFromProfileView = false
        
    }
    
    //These for the number of items my lord
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 16, height: collectionView.bounds.size.height/2)
        
    }
    
    
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, unit: String) -> Double
    {
        
        // this function will return the distance my lord.
        
        var radlat1 = Double.pi * lat1 / 180
        
        var radlat2 = Double.pi * lat2 / 180
        
        var radlon1 = Double.pi * lon1 / 180
        
        var radlon2 = Double.pi * lon2 / 180
        
        var theta = lon1 - lon2
        
        var radtheta = Double.pi * theta/180
        
        var dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta)
        
        dist = acos(dist)
        
        dist = dist * 180 / Double.pi
        
        dist = dist * 60 * 1.1515
        
        if unit == "k"
        {
            dist = dist * 1.609344
        }
        
        if unit == "m"
        {
            dist = dist * 0.8684
        }
        
        return dist
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


