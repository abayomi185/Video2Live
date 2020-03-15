//
//  ViewController.swift
//  SimpleConvert
//
//  Created by Abayomi Ikuru on 03/08/2019.
//  Copyright © 2019 Abayomi Ikuru. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import Photos
import GoogleMobileAds
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //present(picker, animated: true, completion: nil)
    
    let imagePicker = UIImagePickerController()
    
    var inputURL : URL?
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var bannerView: GADBannerView!
    
    var rootVCContainer: NSPersistentContainer!
    
    var agreed: Bool = false
    
    var permissionStatus: Int = 0
    
    var secretCount = 0
    
//    let circle = UIView()

//    let gradientBG = CAGradientLayer()
    
    @IBOutlet weak var liveConvertHiddenButton: UIButton!
    
    @IBAction func liveConvertHiddenButton(_ sender: Any) {
        
        setGradientBackground(colorTop: UIColor.darkGray.cgColor, colorBottom: UIColor(red: 0.27, green: 0.44, blue: 0.65, alpha: 1).cgColor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.secretCount == 0 {
                self.secretCount = 1
                let alertController = UIAlertController(title: "You've Found The Hidden Button", message: "Stick around and you'll find a pleasant surprise in an update coming soon😉", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                alertController.show()
            }else {
                let alertController = UIAlertController(title: "Chill", message: "It's not gonna come quicker if you keep clicking", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                alertController.show()
            }
        }
        
    }
    
    
    @IBOutlet weak var convertButton: UIButton!
    
    //MARK: Convert Button and UIAlert
    @IBAction func convertButton(_ sender: UIButton) {
        
        verifyPermissions { (success) in
            if success {
                convertButtonFunction()
            }
        }
        
    }
    
    func convertButtonFunction() {
        let actionSheet = UIAlertController.init(title: "Video Source", message: "Choose a Video", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default)
        { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func setGradientBackground(colorTop: CGColor, colorBottom: CGColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        liveConvertHiddenButton.frame = CGRect(x: ((screenSize.width/2)-(272/2)), y: (screenSize.height*0.16), width: 272, height: 48)
        liveConvertHiddenButton.setTitleColor(UIColor.red, for: .highlighted)
        
        convertButton.frame = CGRect(x: ((screenSize.width/2)-(180/2)), y: (screenSize.height*0.58), width: 180, height: 54)
        //convertButton.setTitleColor(UIColor.white, for: .normal)
        convertButton.setTitleColor(UIColor.systemOrange, for: .highlighted)
        convertButton.backgroundColor = UIColor.systemOrange
        convertButton.layer.cornerRadius = 25
        
        infoButton.frame = CGRect(x: ((screenSize.width/2)-(195/2)), y: (screenSize.height*0.80), width: 195, height: 33)
        infoButton.backgroundColor = UIColor.systemTeal
        infoButton.setTitleColor(UIColor.systemOrange, for: .highlighted)
        infoButton.layer.cornerRadius = 15
        
        imagePicker.delegate = self
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.videoQuality = .typeHigh
        imagePicker.videoExportPreset = AVAssetExportPresetPassthrough
        imagePicker.allowsEditing = true
        
//        circle.frame = CGRect(x: convertButton.center.x, y: convertButton.center.y, width: 100, height: 100)
//        circle.layer.cornerRadius = circle.frame.size.height / 2
//        circle.backgroundColor = convertButton.backgroundColor
        
        //setGradientBackground(colorTop: UIColor.darkGray.cgColor, colorBottom: UIColor(red: 0.27, green: 0.44, blue: 0.65, alpha: 1).cgColor)
        
        
        //Show view controller for terms and conditions. Modify permission to be called as a completion
        
        
        //MARK: Permission to access photo library
        
//        verifyAdStatus { (success) in
//            if success {
//                //Permissions function to be moved to convertButton
//                //self.permissions()
//            } else{
//                print("Hmm, I think an error occured somewhere")
//            }
//        }
        
        verifyAdStatus()
        
        displayTerms { (success) in
            if success {
                //Permissions function to be moved to convertButton
                self.permissions()
            } else{
                print("Hmm, I think an error occured somewhere")
            }
        }
        
        //GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)

        bannerView.adUnitID = "ca-app-pub-1890050047502812/9448178019"
        bannerView.rootViewController = self


        bannerView.load(GADRequest())
        
        
    }
    
    func displayTerms(completion: (Bool)->Void) {
        if agreed == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
                self.performSegue(withIdentifier: "termsAndCo", sender: nil)
                //self.permissions()
            }
        }
        completion(true)
    }
    
    
    //MARK: Perform Function when view is dismissed
    //https://stackoverflow.com/questions/4150677/call-function-in-underlying-viewcontroller-as-modal-view-controller-is-dismissed
    
    
    func verifyPermissions(completion: (_ success: Bool)->Void) {
        
        //if statements based on returns from permissions
        if permissionStatus != 1 {
            //show alert to go to setting to change
            let alertController = UIAlertController(title: "Photo Library Permission Required", message: "Enable access to Photo Library in \"Live Convert\" Settings", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                
            }))
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (UIAlertAction) in
                if let url = URL(string:UIApplication.openSettingsURLString) {
                               if UIApplication.shared.canOpenURL(url) {
                                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                               }
                           }
            }))
            alertController.show()
            completion(false)
        }else {
           completion(true)
        }
    }
    
    
    func verifyAdStatus() {
        
        //if case first to check core data then...
        //Show adrequestviewcontroller
        
        //getData function here
        //https://www.youtube.com/watch?v=dIXkR-2rdvM&t=165s
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Create NSFetchRequest
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Consent")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                agreed = data.value(forKey: "termsAgreedTo") as! Bool
            }
            print(agreed)
        }catch{
            print("NSFetch failed")
        }
    
        //For when I needed to know how completion handlers work
        //Basically, once a first function is done, it sends a signal or a value of some sorts that says yes or no
        //The other function then proceeds based on that
        //if process completed; completion(true).
        //Then in function call, action for true case and false case
    }
    
    
    //MARK: Google code for test
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    //MARK: Navigation Controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    func permissions(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    self.permissionStatus = 1
                    print("Proceeds")
                default:
                    break
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previewVC = segue.destination as? PreviewViewController{
            previewVC.previewURL = inputURL
        }
        
        if let nextVC = segue.destination as? AdRequest {
            nextVC.adRequestContainer = rootVCContainer
        }
    }
    
    
    //MARK: Finish Picking Media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let videoURL = info[.mediaURL] as? URL else {
            //I changed it from a URL to UIImage; change variable names as I see fit later
            
            self.imagePicker.dismiss(animated: true, completion: nil)

            self.alert(alertTitle: "error", AlertMessage: "Error cccured while processing video")
            
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
            inputURL = videoURL
            self.imagePicker.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "goToPreview", sender: self)

        }
        

    //MARK: Cancel ImagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
    
    
    
    



