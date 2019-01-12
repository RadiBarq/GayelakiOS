//
//  ReportUserViewController.swift
//  Chottky
//
//  Created by Radi Barq on 1/1/18.
//  Copyright © 2018 Chottky. All rights reserved.
//

import UIKit
import Firebase



private let reuseIdentifier = "Cell"

class ReportUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    var categriesPhotosArray = ["chat", "thief", "volcano", "suspects", "zombie", "syringe", "spam", "dislike", "mailbox"]
    let categorisTextArray = ["اسلوب عدائي", "محتال", "لم يظهر في القائات", "اسلوب شائك","غير فعال", "يبيع بضائع ممنوعة", "يرسل رسائل مزعجة", "مزور بضائع",
                                              "امور اخرى"]
  
    var selectedInex: Int?
    
    let categoryTypes = ["offensive behaviour", "scammer", "did not show up in meetings", "suspecious behaviour",
                          
                          "not active", "selling illegal items","spammer", "selling fake items", "others"
                          ]
    
    
    
    @IBOutlet weak var reportDescription: UITextView!
    
    let userID = Auth.auth().currentUser!.uid
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return categriesPhotosArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReportCell
        cell.setupImage(image: UIImage(named: categriesPhotosArray[indexPath.row])!)
        cell.setUpLabel(text: categorisTextArray[indexPath.row])
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         var selectedCell = collectionView.cellForItem(at: indexPath) as! ReportCell
         unselectRowsInSection(rowsCount: categriesPhotosArray.count, section: 0)
          selectedCell.addMask()
        selectedInex = indexPath.row
        print(indexPath.row)
        
    }
    func unselectRowsInSection(rowsCount: Int, section: Int)
    {
        for row in 0 ..< rowsCount
        {
            var indexPath  = NSIndexPath(row: row, section: section)
            var selectedCell = self.reportUserCollectionView.cellForItem(at: indexPath as IndexPath ) as? ReportCell
            
            if (selectedCell != nil)
            {
                selectedCell?.removeMask()
                //cell?.removeImageView()
            }
        }
    }

    @IBOutlet weak var reportUserCollectionView: UICollectionView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        reportUserCollectionView.delegate = self
        reportUserCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.reportUserCollectionView.register(ReportCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        reportDescription.delegate = self
        reportDescription.layer.borderWidth = 0.5
        reportDescription.layer.borderColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1).cgColor
        reportDescription.layer.cornerRadius = 5
        
        reportDescription.text = "اضف تعليق (ليس ضروري)"
        reportDescription.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
     
        //self.navigationController?.navigationBar.backItem?.title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        
          super.viewWillDisappear(animated)
          self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        title = "التبليغ عن المستخدم"
        // self.navigationController?.navigationBar.topItem?.title = "اعدادات التصفح"
       // self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "تبليغ", style: .done, target: self, action: #selector(reportButtonClicked(_:)))
        //self.navigationController?.navigationBar.topItem?.title = ""
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func reportButtonClicked(_ sender: Any) {
        
        firebaseReportUser()
    }
    
    func firebaseReportUser()
    {
        
        if (selectedInex == nil){
            
            let alertEmailController = UIAlertController(title: "المعلومات المدخلة غير مكتملة", message: "الرجاء إختيار نوع البلاغ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            present(alertEmailController, animated: true, completion: nil)
        }
        
        else{
            
            Database.database().reference().child("users-reports").childByAutoId().updateChildValues([
                
                "type": categoryTypes[selectedInex!],
                "description": reportDescription.text,
                "timestamp": Int(NSDate().timeIntervalSince1970),
                "reportingUser": userID,
                "reportedUser": ProfileViewController.userId
                
            ]){ (error, ref) in
                
                if (error == nil)
                {
                
                    let alertEmailController = UIAlertController(title: "تم ارسال البلاغ بنجاح", message: "سيتم الرد عليك في اقرب وقت ممكن", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler:{ (UIAlertAction) in

                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    )
                    
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: nil)
    
                }
                
                else
                {
        
                    let alertEmailController = UIAlertController(title: "حدث خظأ في الشبكة", message: "الرجاء اعد المحاوله لاحقا", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertEmailController.addAction(defaultAction)
                    self.present(alertEmailController, animated: true, completion: nil)
                    
                }
    
            }
         
        }
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "الوصف")
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            var textWidth = textView.frame.width
            textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
            let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
            let numberOfLines = boundingRect.height / textView.font!.lineHeight;
            return numberOfLines <= 6;
        
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSFontAttributeName: font],
                                                 context: nil).size
        
    }
    

    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text.isEmpty)
        {
            textView.text = "اضف تعليق (ليس ضروري)"
            textView.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        }
            
        else if (textView.textColor == UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1))
        {
            
            var txt = textView.text
            
            if (txt == "اضف تعليق (ليس ضروري"  )
            {
                textView.text = nil
                textView.textColor = UIColor.black
            }
            
            else
            {
            
            //  textView.text = nil
            if let range = txt?.range(of: "اضف تعليق (ليس ضروري)") {
                txt?.removeSubrange(range)
            }
            textView.text = txt
            textView.textColor = UIColor.black
            }
        
        }
            
        else
        {

            textView.textColor = UIColor.black

        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "اضف تعليق(ليس ضروري)"
            textView.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: reportUserCollectionView.bounds.size.width/2 - 20, height: reportUserCollectionView.bounds.size.height/3 - 20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

class ReportCell: UICollectionViewCell
{
    
    var maskLayer : CALayer?
    var imageView: UIImageView = {
    
        var image = UIImageView()
        return image
    }()
    
    
    var whiteTick: UIImageView = {
       
        var image = UIImageView(frame: .zero)
        image.image = #imageLiteral(resourceName: "tick-white")
        return image
        
    }()
    
    var label: UILabel = {
        
        var lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30 , height:10))
        lbl.textColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
        lbl.textAlignment = .right
        lbl.font = lbl.font.withSize(13)
        return lbl
        
    }()
    
    var darkMask: UIView = {
        
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 75, height:75))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 37.5
        return view
        
    }()
    
    
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
   //     imageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
    //    addSubview(imageView)
      //  initializeItems()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage(image: UIImage)
    {
        imageView.image = image
    }
    
    func setUpLabel(text: String)
    {
        label.text = text
        
    }
    
    func setUpImage(image: UIImage)
    {
        self.backgroundColor = UIColor.white
        imageView.image = image
    }
    
    func addMask()
    {
        UIView.animate(withDuration: 1, animations: {
        
            self.darkMask.isHidden = false
           // self.layoutIfNeeded()
            
        }, completion: nil)

    }
    
    func removeMask()
    {
       self.darkMask.isHidden = true
        
    }
    
    func setupViews()
    {
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        // categoryLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        
        self.darkMask.addSubview(whiteTick)
        whiteTick.translatesAutoresizingMaskIntoConstraints = false
        whiteTick.widthAnchor.constraint(equalToConstant: 40).isActive = true
        whiteTick.heightAnchor.constraint(equalToConstant: 40).isActive = true
        whiteTick.centerXAnchor.constraint(equalTo: self.darkMask.centerXAnchor).isActive = true
        whiteTick.centerYAnchor.constraint(equalTo: self.darkMask.centerYAnchor).isActive = true
        
        self.imageView.addSubview(self.darkMask)
        self.imageView.bringSubview(toFront: self.darkMask)
        self.darkMask.isHidden = true
        
    }
}

