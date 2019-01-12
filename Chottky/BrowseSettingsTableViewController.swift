//
//  BrowseSettingsTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 9/1/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class BrowseSettingsTableViewController: UITableViewController {

    @IBOutlet var resetButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    
    let sectionHeaderTitleArray = ["التصنيفات", "المسافة", "الترتيب حسب"]
    let categoriesArray = ["سيارات","الكترونيات","شقق و اراضي","البيت و الحديقة","حيوانات","الرياضة و الالعاب","ملابس و اكسسوارات","الاطفال","افلام، كتب و اغاني","اغراض اخرى"]
    //let postedWithinArray = ["اخر ٢٤ سيعة", "اخر ٧ ايام", "في اخر ٣٠ يوم", "كل المنتجات"]
    let distanceArray = ["قريب جدا (١ كم)", "في الاحياء القريبة (٥كم)", "في مدينيتي (١٠كم)", "في مدينيتي (١٠كم)", "لم يحدد"]
    let sortedByArray = ["الاقرب اولا", "السعر من الاعلى الى الاقل", "السعر من الاقل  الى الاعلى", "الاجدد اولا"]
    static var  selectedCategoriesIndexes: Array? = [0, 0 , 0, 0, 0, 0, 0, 0, 0, 0]
  //  static var selectedPostedWithInIndex: Int? = 3
    static var selectedDistanceIndex: Int? = 3
    static var selectedsortedByIndex: Int? = 0
    var copyOfSelectedCategory = [Int]()
    var copyOfSelectedDistance = Int()
    var copySortedByIndex = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.topItem?.title = ""
   //     self.navigationController?
        self.title = "اعدادات التصفح"
        
       //selectedPostedWithInIndex = 3
       // selectedDistanceIndex = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.topItem?.title = "اعدادات التصفح"
        self.navigationController?.navigationBar.isTranslucent = false
        var rightButtonItem = UIBarButtonItem(title: "اعادة", style: .done, target: self, action: #selector(resetButtonClicked))
        rightButtonItem.tintColor = Constants.FirstColor
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        self.navigationItem.title = "اعدادات التصفح"
        
       // let titleLabel = UILabel()
        //userImage.text = "اعدادات التصفح"
        //userImage.tintColor = UIColor.black
        //logoImageView.frame = CGRect(x:0.0,y:0.0, width:60,height:25.0)
        //let imageItem = UIBarButtonItem.init(customView: titleLabel)
        //let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 35)
        //let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 35)
        //navigationItem.rightBarButtonItem =  imageItem
        
        
      //  self.navigationController?.navigationBar.isTranslucent = false
      //  var rightButtonItem = UIBarButtonItem(title: "اعدادات التصفح", style: .done, target: self, action: #selector(resetButtonClicked))
       // rightButtonItem.tintColor = UIColor.black
        //self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        
        
        intializeCategoryArray()
        copyOfSelectedCategory = BrowseSettingsTableViewController.selectedCategoriesIndexes!
        copyOfSelectedDistance = BrowseSettingsTableViewController.selectedDistanceIndex!
        copySortedByIndex = BrowseSettingsTableViewController.selectedsortedByIndex!
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        if (copyOfSelectedCategory != BrowseSettingsTableViewController.selectedCategoriesIndexes! || copyOfSelectedDistance != BrowseSettingsTableViewController.selectedDistanceIndex ||  copySortedByIndex != BrowseSettingsTableViewController.selectedsortedByIndex)
        {
            BrowseCollectionViewController.queryChanged = true
        }
    }
    
    func intializeCategoryArray()
    {
        // unselectRowsInSection(rowsCount: (BrowseSettingsTableViewController.selectedCategoriesIndexes?.count)!, section: 0)
        var thirdSectionIndexPath = IndexPath(row:BrowseSettingsTableViewController.selectedDistanceIndex! , section: 0)
        self.tableView.scrollToRow(at: thirdSectionIndexPath, at: .bottom, animated: false)
        var thirdCell =  tableView.cellForRow(at: thirdSectionIndexPath) as! BrowseSettingsTableViewCell
        thirdCell.addImageView()
        
        var fivthSectionIndexPath = IndexPath(row:BrowseSettingsTableViewController.selectedDistanceIndex! , section: 1)
        self.tableView.scrollToRow(at: fivthSectionIndexPath, at: .bottom, animated: false)
        var fivthCell =  self.tableView.cellForRow(at: fivthSectionIndexPath) as! BrowseSettingsTableViewCell
        fivthCell.addImageView()
        
        
        if (BrowseSettingsTableViewController.selectedsortedByIndex != nil)
        {
            var fourthSectionIndexPath = IndexPath(row: BrowseSettingsTableViewController.selectedsortedByIndex!, section: 2)
            self.tableView.scrollToRow(at: fourthSectionIndexPath, at: .bottom, animated: false)
            let fourthCell =  tableView.cellForRow(at: fourthSectionIndexPath) as! BrowseSettingsTableViewCell
            fourthCell.addImageView()
        }
    
        self.tableView.scrollToRow(at: IndexPath(row: 0,section:0), at: .top, animated: false)
        var counter = 0
        for i in BrowseSettingsTableViewController.selectedCategoriesIndexes!
        {
            
            var indexPath = IndexPath(row: counter, section: 0)
            var cell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell

            if (i == 1)
            {
                cell.addImageView()
                cell.setSelected(true, animated: false)
            }
        
            else
            {
                cell.removeImageView()
                cell.setSelected(false, animated: false)
            }

            counter = counter + 1
        }
    }
    
    
    func resetButtonClicked()
    {
        var thirdSectionIndexPath = IndexPath(row:BrowseSettingsTableViewController.selectedDistanceIndex! , section: 0)
        self.tableView.scrollToRow(at: thirdSectionIndexPath, at: .bottom, animated: false)
        var thirdCell =  tableView.cellForRow(at: thirdSectionIndexPath) as! BrowseSettingsTableViewCell
        thirdCell.removeImageView()
        thirdCell.setSelected(false, animated: false)

        
        
        var fivthSectionIndexPath = IndexPath(row:BrowseSettingsTableViewController.selectedDistanceIndex! , section: 1)
        self.tableView.scrollToRow(at: fivthSectionIndexPath, at: .bottom, animated: false)
        var fivthCell =  self.tableView.cellForRow(at: fivthSectionIndexPath) as! BrowseSettingsTableViewCell
        fivthCell.removeImageView()
        fivthCell.setSelected(false, animated: false)
        
        
        if (BrowseSettingsTableViewController.selectedsortedByIndex != nil)
        {
            var fourthSectionIndexPath = IndexPath(row: BrowseSettingsTableViewController.selectedsortedByIndex!, section: 2)
            self.tableView.scrollToRow(at: fourthSectionIndexPath, at: .bottom, animated: false)
            let fourthCell =  tableView.cellForRow(at: fourthSectionIndexPath) as! BrowseSettingsTableViewCell
            fourthCell.removeImageView()
            fourthCell.setSelected(false, animated: false)
        }
        
        BrowseSettingsTableViewController.selectedDistanceIndex = 3
        BrowseSettingsTableViewController.selectedsortedByIndex = 0
        BrowseSettingsTableViewController.selectedCategoriesIndexes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        BrowseCollectionViewController.queryChanged = true
        viewWillAppear(false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaderTitleArray[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 30, width: view.frame.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: -10, y: 22, width: view.frame.size.width, height: 10))
        
        label.text = self.sectionHeaderTitleArray[section]
        label.textColor = UIColor.black

        label.textAlignment = .right
        returnedView.addSubview(label)
        return returnedView
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
        
        if indexPath.section == 0
        {
            selectedCell.removeImageView()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
     

        let row = indexPath.row  // this is the row number.
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
        let section = indexPath.section // this is the section number.
        
        if (section == 0)
        {
            if (selectedCell.isSelected == true)
            {
                selectedCell.removeImageView()
                BrowseSettingsTableViewController.selectedCategoriesIndexes![row] = 0
                selectedCell.setSelected(false, animated: true)
            }
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) ->
        IndexPath? {
        
        let section = indexPath.section // this is the section number.
        let row = indexPath.row  // this is the row number.
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
        
        if (section == 0)
        {
            if (selectedCell.isSelected == false)
            {
                selectedCell.addImageView()
                BrowseSettingsTableViewController.selectedCategoriesIndexes![row] = 1
                selectedCell.setSelected(true, animated: true)
            }
        }
        
        return indexPath
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section // this is the section number.
        let row = indexPath.row  // this is the row number.
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
    
         if (section == 1)
        {
            let sectionNumber = 1
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            unselectRowsInSection(rowsCount: numberOfRowsInSection, section: sectionNumber)
            selectedCell.addImageView()
            BrowseSettingsTableViewController.selectedDistanceIndex = row
        }
        
        else if (section == 2)
        {
            let sectionNumber = 2
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            unselectRowsInSection(rowsCount: numberOfRowsInSection, section: sectionNumber)
            selectedCell.addImageView()
            BrowseSettingsTableViewController.selectedsortedByIndex = row
        }
    }
    
    func unselectRowsInSection(rowsCount: Int, section: Int)
    {
        for row in 0 ..< rowsCount
        {
            var indexPath  = NSIndexPath(row: row, section: section)
            var cell = tableView.cellForRow(at: indexPath as IndexPath) as? BrowseSettingsTableViewCell
            
            if (cell != nil)
            {
                
                cell?.setSelected(false, animated: true)
                cell?.removeImageView()
            }
            
        }
    }
    
    func selectRowsInSection(rowsCount: Int, section: Int)
    {
        for row in 0 ..< rowsCount
        {
            
            var indexPath  = NSIndexPath(row: row, section: section)
            var cell = tableView.cellForRow(at: indexPath as IndexPath) as! BrowseSettingsTableViewCell
            
            if cell.isSelected == true
            {
                
                cell.addImageView()
            }
                
            else
            {
                cell.removeImageView()

            }
        }
    }
}
