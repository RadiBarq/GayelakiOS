import AVFoundation
import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureButton: SwiftyRecordButton!
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var libraryButton: UIButton!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cameraDelegate = self
        
        captureButton = SwiftyRecordButton(frame: CGRect(x: 0, y: 0, width:75, height: 75))
        flashButton = UIButton()
        flipCameraButton = UIButton()
        
           UIApplication.shared.isStatusBarHidden = true
        
        
        imagePicker.delegate = self
        
        self.view.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
     //   captureButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
       // captureButton.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        captureButton.delegate = self
       // captureButton.shrinkButton()
        
        self.view.addSubview(flashButton)
        flashEnabled = false
        flashButton.frame = CGRect(x: 100, y: 100, width:18, height: 30)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.centerYAnchor.constraint(equalTo: self.captureButton.centerYAnchor).isActive = true
        flashButton.leftAnchor.constraint(equalTo: captureButton.rightAnchor, constant: 50).isActive = true
        flashButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        flashButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        flashButton.setImage(UIImage(named: "flashOutline"), for: .normal)
        flashButton.addTarget(self, action: #selector(flashButtonClicked), for: .touchUpInside)

        self.view.addSubview(flipCameraButton)
        flipCameraButton.frame = CGRect(x: 100, y: 100, width:30, height: 23)
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        flipCameraButton.centerYAnchor.constraint(equalTo: self.captureButton.centerYAnchor).isActive = true
        flipCameraButton.rightAnchor.constraint(equalTo: captureButton.leftAnchor, constant: -50).isActive = true
        flipCameraButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        flipCameraButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        flipCameraButton.setImage(UIImage(named: "flipCamera"), for: .normal)
        flipCameraButton.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)

        libraryButton = UIButton()
        self.view.addSubview(libraryButton)
        
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        libraryButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        libraryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        libraryButton.heightAnchor.constraint(equalToConstant: 37).isActive = true
        libraryButton.setImage(UIImage(named: "library"), for: .normal)
        libraryButton.addTarget(self, action: #selector(onClickLibrary), for: .touchUpInside)
    }
    

    func onClickLibrary()
    {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
        
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

    func flipCamera()
    {
        switchCamera()
    }
    
    
    func flashButtonClicked()
    {
        
         if(flashEnabled == true)
         {
            
            flashEnabled = false
            flashButton.setImage(UIImage(named: "flashOutline"), for: .normal)
        }
        
        else
         {
            flashEnabled = true
            flashButton.setImage(UIImage(named: "flash"), for: .normal)
        }
        
    }
    
    
    func takePicture(sender: UIButton!) {
        
       
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        
        PostedItemViewController.images[0] = photo
        PostedItemViewController.imagesValid[0] = true
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postedItemViewController = mainStoryboard.instantiateViewController(withIdentifier: "postedItemNavigationController")
        self.present(postedItemViewController, animated: true, completion: nil)
         print("Button tapped")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageView.contentMode = .ScaleAspectFit
            //imageView.image = pickedImage
            imagePicker.dismiss(animated:true, completion: nil)
            PostedItemViewController.images[0] = pickedImage
            PostedItemViewController.imagesValid[0] = true
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postedItemViewController = mainStoryboard.instantiateViewController(withIdentifier: "postedItemNavigationController")
            self.present(postedItemViewController, animated: true, completion: nil)
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
