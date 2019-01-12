//
//  CollectionsCollectionViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/14/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import Lottie

private let reuseIdentifier = "Cell"

class CollectionsCollectionViewController: UICollectionViewController,  UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var categriesPhotosArray = ["category-car", "phone-category", "category-aparment", "category-home", "category-dog", "category-sport", "category-clothes", "category-kids", "category-books", "category-others"]
    let categorisTextArray = ["سيارات","الكترونيات","شقق و اراضي","البيت و الحديقة","حيوانات","الرياضة و الالعاب","ملابس و اكسسوارات","الاطفال","افلام، كتب و اغاني","اغراض اخرى"]
    var selectedInex = 0
    // this should be enum in the future here my lord.
    static var presentedFor = "discover"
    var searchBar = UISearchBar()
    static var browsingViewController: BrowseCollectionViewController? = nil
    
     var animationSuperView = UIView()
    
    var tickAnimation = LOTAnimationView(name: "simple_tick-w80-h80.json")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(CollectionsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // self.collectionView?.delegate = self
        // Do any additional setup after loading the view.
       // self.navigationController?.navigationBar.topItem?.title = ""
       // addAnimationSuperView()
        
    }
    
    func addAnimationSuperView()
    {
        
        
         self.view.addSubview(animationSuperView)
        animationSuperView.layer.masksToBounds = true
        animationSuperView.translatesAutoresizingMaskIntoConstraints = false
        animationSuperView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        animationSuperView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        animationSuperView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        animationSuperView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        animationSuperView.layer.cornerRadius = 5
        animationSuperView.backgroundColor = Constants.LightGray.withAlphaComponent(0.85)
 
        

        self.animationSuperView.addSubview(tickAnimation)
        tickAnimation.translatesAutoresizingMaskIntoConstraints = false
        tickAnimation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tickAnimation.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tickAnimation.topAnchor.constraint(equalTo: animationSuperView.topAnchor, constant: 15).isActive = true
        tickAnimation.centerXAnchor.constraint(equalTo: animationSuperView.centerXAnchor).isActive = true
        tickAnimation.animationProgress = 0.0
       // tickAnimation.loopAnimation = true
        tickAnimation.animationSpeed = 0.6
       // tickAnimation.play()
        
        var label = UILabel()
        label.text = "تم اضافة منتجك بنجاح"
        label.translatesAutoresizingMaskIntoConstraints = false
        animationSuperView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: animationSuperView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: tickAnimation.bottomAnchor, constant: 10).isActive = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    
    
    
    func setupSearchBar()
    {
        searchBar.placeholder = "ابحث في جايلك"
        searchBar.tintColor = Constants.FirstColor
        searchBar.backgroundColor = UIColor.clear
        
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField){
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = Constants.LightGray
                }
            }
        }
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        unselectRowsInSection(rowsCount: 10, section: 1)
       
        if (CollectionsCollectionViewController.presentedFor == "discover")
        {
            title = "اكتشف"
            setupSearchBar()
        
        }
            
        else
        {
           // title = "نوع المنتج الذي تريد بيعه"
             var title = UILabel()
            title.text = "نوع المنتج الذي تريد بيعه"
            title.textColor = UIColor.black
            title.font = UIFont.boldSystemFont(ofSize: 18)
            
             self.navigationItem.titleView = title
             self.navigationController?.navigationBar.topItem?.title = "نوع المنتج الذي تريد بيعه"
            //  let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:50))
        
            //navigationBar.topItem.title = "some title"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "نشر", style: .done, target: self, action: #selector(resetButtonClicked))
            self.navigationItem.setHidesBackButton(true, animated:true)
            
            
        }
        
    }
    
    func resetButtonClicked()
    {
        Database.database().reference().child("items").child(PostedItemViewController.itemId).updateChildValues(["category":categriesPhotosArray[selectedInex]])
            CollectionsCollectionViewController.presentedFor = "sell"
            addAnimationSuperView()
            tickAnimation.play(completion:{ (block) in
            self.navigationController?.dismiss(animated: true, completion: nil)
                
        
            })
        
     }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        title = " "
        
        if (CollectionsCollectionViewController.presentedFor == "sell")
        {
            CollectionsCollectionViewController.presentedFor = "discover"
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categriesPhotosArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionsCell
        cell.setImage(image: UIImage(named: categriesPhotosArray[indexPath.row])!)
        cell.setUpLabel(text: categorisTextArray[indexPath.row])
        // Configure the cell
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionsCell
        
        if (CollectionsCollectionViewController.presentedFor == "discover")
        {
            BrowseSettingsTableViewController.selectedCategoriesIndexes = [0, 0 , 0, 0, 0, 0, 0, 0, 0, 0]
            BrowseSettingsTableViewController.selectedCategoriesIndexes![indexPath.row + indexPath.section] = 1
            selectedCell.backgroundColor = UIColor.lightGray
            BrowseCollectionViewController.queryChanged = true
            self.tabBarController?.selectedIndex = 0
        }
            
        else
        {
            
            unselectRowsInSection(rowsCount:categorisTextArray.count , section: 0)
          //  print(categriesPhotosArray[indexPath.row + indexPath.section])
            selectedCell.backgroundColor = UIColor.lightGray
            selectedInex = indexPath.row + indexPath.section
            
        }
    }
    
     public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText == "")
        {
            self.tabBarController?.selectedIndex = 0
            CollectionsCollectionViewController.browsingViewController?.searchBar(searchBar, textDidChange: searchText)
        }
        
        }
    
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
            self.tabBarController?.selectedIndex = 0
            //            var browsingViewController = self.tabBarController?.tabBar. as! BrowseCollectionViewController
        CollectionsCollectionViewController.browsingViewController!.searchBarSearchButtonClicked(searchBar)
        
        }
    
    func unselectRowsInSection(rowsCount: Int, section: Int)
    {
        for row in 0 ..< rowsCount
        {
            var indexPath  = NSIndexPath(row: row, section: 0)
            var selectedCell = self.collectionView?.cellForItem(at: indexPath as IndexPath ) as? CollectionsCell
            
            if (selectedCell != nil)
            {
                selectedCell!.backgroundColor = UIColor.white
                //cell?.removeImageView()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 0.5, height: collectionView.bounds.size.height/4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
