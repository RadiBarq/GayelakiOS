//
//  BlockedUsersTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 1/4/18.
//  Copyright © 2018 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class BlockedUsersTableViewController: UITableViewController {

    
    var rootRef = Database.database().reference()
    var blockedUsersRef: DatabaseReference?
    let userID = Auth.auth().currentUser!.uid
    var blockedUsersKeys = [String]()
    var usersNames = [String]()
    //var clickedRow: Int?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(BlockedUser.self, forCellReuseIdentifier: "cellId")
        title = "قائمة المحذورين"
        
        blockedUsersRef = rootRef.child("Users").child(userID).child("block")
     
        fetchBlockedUsers()
    }
    
    func fetchBlockedUsers()
    {
        
      
        blockedUsersRef?.observe(.value, with: { (
            
            snapshot) in
  
            self.blockedUsersKeys = []
            self.usersNames = []
            for item in snapshot.children
            {
                var key = (item as! DataSnapshot).key
                var value = ((item as! DataSnapshot).value) as! String
                self.blockedUsersKeys.append(key)
                self.usersNames.append(value)
            }
            
            self.tableView.reloadData()
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
           self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        blockedUsersRef?.removeAllObservers()
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blockedUsersKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BlockedUser

        cell.removeBlockButton.tag = indexPath.row
        cell.removeBlockButton.addTarget(self, action: #selector(self.removeBlockButtonClicked), for: .touchUpInside)
        cell.setupBlockedUser(name: usersNames[indexPath.row])
        return cell
    }
    
   func removeBlockButtonClicked(sender: UIButton!)
    {
        
        var row =  sender.tag
        
         Database.database().reference().child("Users").child(self.userID).child("block").child(blockedUsersKeys[row]).removeValue()
        
        print(sender.tag)
        
        // Rest of function
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
}


class BlockedUser: UITableViewCell
{
    public var blockedUser: UILabel = {
    
        var lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
        
    }()
    
    public var removeBlockButton: UIButton = {
        
        var button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("الغاء الحذر", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Constants.FirstColor
        button.setTitleColor(Constants.FirstColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 16)
        return button
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(removeBlockButton)
        removeBlockButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        removeBlockButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        removeBlockButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        removeBlockButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        
        addSubview(blockedUser)
        blockedUser.widthAnchor.constraint(equalToConstant: 200).isActive = true
        blockedUser.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockedUser.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        blockedUser.rightAnchor.constraint(equalTo: self.rightAnchor, constant:  -10).isActive = true
        
    }
    
    
    func setupBlockedUser(name: String)
    {
        blockedUser.text = name
    
        
    }
    
}















