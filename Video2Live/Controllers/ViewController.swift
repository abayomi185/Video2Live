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
import CoreHaptics
import StoreKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKPaymentTransactionObserver {
        
    let productID = "com.yomitosh.Video2Live.removeAds"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let imagePicker = UIImagePickerController()
    
    var inputURL : URL?
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var bannerView: GADBannerView!
    
    var rootVCContainer: NSPersistentContainer!
    
    var agreed: Bool = false
    
    var permissionStatus: Int = 0
    
    var secretCount = 0
    
    var socialButtonActive : Bool = false
    
    var socialMediaLinks = ["http://youtube.com/yomitosh", "http://twitter.com/yomi_185"]
    
    var gradientLayerStatus: Bool = false
        
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    var player: AVPlayer?
    
    var isPlayerActive: Bool = false
    
    var hyperdrive: Bool = false
    
    let animation = CABasicAnimation(keyPath: "opacity")
    
    var restored: Bool = false
    
//    let circle = UIView()

//    let gradientBG = CAGradientLayer()
    
    @IBOutlet weak var liveConvertHiddenButton: UIButton!
    
    @IBAction func liveConvertHiddenButton(_ sender: Any) {

        if traitCollection.userInterfaceStyle == .dark {
            if isPlayerActive == false {
                loadVideo(to: isPlayerActive)
            } else if isPlayerActive == true {
                if hyperdrive == false {
                    loadVideo(to: isPlayerActive)
                } else {
                    let alert = UIAlertController(title: "-HyperDrive Module-", message: "The hyperdrive module needs to be reset", preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true, completion:{
                        alert.view.superview?.isUserInteractionEnabled = true
                        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
                    })
                }
            }
        } else {
            //put in function for what to do otherwise
            let alert = UIAlertController(title: "-Dark Mode Required-", message: "Please enable dark mode to go into Deep Space", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        
    }
    
    
    func animatePlayer(playerLAyer: CALayer) {
            animation.fromValue = 0
            animation.toValue = 0.5
            animation.duration = 0.5
            self.view.layer.addSublayer(playerLAyer)
            playerLAyer.add(animation, forKey: "opacity")
    }
    
    //MARK: UIAlertView for Star Button Cause you're a Stat, yes you
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBAction func starButton(_ sender: UIButton) {
        
            springyButton(sender)
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        if UserDefaults.standard.bool(forKey: productID) == false {
            
            //        let textView = UITextView()
            let alert = UIAlertController(title: "Remove Ads", message: "This app is supported with revenue generated from ads. If you enjoy using the app and you'd prefer to continue using it without ads, you can purchase a lifetime in-app purchasee to disable ads and support the development of the app.", preferredStyle: .alert)
            
            //UIAlert Actions
            let purchaseAction = UIAlertAction(title: "Remove Ads", style: .default, handler: {
                (_)in
                //do something
                //SKPaymentQueue.default().add(self)
                self.loadingIndicator.isHidden = false
                self.removeAds(restoringPurchase: false)
            })
            
//            let redeemAction = UIAlertAction(title: "Redeem Code", style: .default, handler: {
//                (_)in
//                //SAVE DEMO DATA HERE
//                let alert2 = UIAlertController(title: "Redeem Code", message: "Please enter your special code here", preferredStyle: .alert)
//                alert2.addTextField { (textField) in
//                    textField.placeholder = "Enter code here"
//                }
//                let OKAction = UIAlertAction(title: "OK", style: .default, handler: {
//                    (_)in
//                    //SAVE DEMO DATA HERE
//
//                })
//                alert2.addAction(OKAction)
//                alert2.show()
//            })
            
            let restoreAction = UIAlertAction(title: "Restore Purchase", style: .default, handler: {
                (_)in
                //do something
                self.loadingIndicator.isHidden = false
                self.removeAds(restoringPurchase: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_)in
                //do another thing
            })
            if UserDefaults.standard.bool(forKey: productID) == false {
                alert.addAction(purchaseAction)
                alert.addAction(restoreAction)
                //alert.addAction(redeemAction)
                alert.addAction(cancelAction)
                alert.preferredAction = purchaseAction
            } else {
                alert.addAction(restoreAction)
                //alert.addAction(redeemAction)
                alert.addAction(cancelAction)
                alert.preferredAction = restoreAction
            }
            
            alert.show()

        } else {
            let alert = UIAlertController(title: "No more Ads", message: "Ads have already been killed off like GoT characters", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion:{
               alert.view.superview?.isUserInteractionEnabled = true
               alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var convertButton: UIButton!
    
    //MARK: Convert Button and UIAlert
    @IBAction func convertButton(_ sender: UIButton) {
        
        //sender.pulsate()
        springyButton(sender)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        verifyPermissions { (success) in
            if success {
                convertButtonFunction()
            }
        }
        
    }
    
    
    private func springyButton(_ viewToAnimate:UIView){
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion:  nil)
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
    
    func animatedGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor,
            UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        self.view.layer.addSublayer(gradient)
    }
    
    
    private func loadVideo(to removeVideo:Bool) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "AppVideo", ofType:"mov")

        let avAsset = AVAsset(url: NSURL(fileURLWithPath: path!) as URL)
        
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in

            if time == avAsset.duration {
                playerLayer.opacity = 0
                self?.gradient.opacity = 1
                self!.hyperdrive = true
            }
        }
        
        if removeVideo == false {
            gradient.opacity = 0
            
//            self.view.layer.addSublayer(playerLayer)
//            playerLayer.opacity = 0.5
            
            animatePlayer(playerLAyer: playerLayer)
            
            player?.seek(to: CMTime.zero)
            player?.play()
            
            isPlayerActive = true
            
        }
        
    }
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var youtubeButton: UIButton!
    @IBAction func youtubeButton(_ sender: UIButton) {
        guard let url = URL(string: socialMediaLinks[0]) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBAction func twitterButton(_ sender: UIButton) {
        guard let url = URL(string: socialMediaLinks[1]) else { return }
        UIApplication.shared.open(url)
    }
    
    private func animateSocialButton(_ youtubeView:UIView, _ twitterView: UIView, activeStatus:Bool) {
        if activeStatus == false{
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                youtubeView.alpha = 1
                twitterView.alpha = 1
            }, completion:  nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                youtubeView.alpha = 0
                twitterView.alpha = 0
            }, completion:  nil)
        }
    }

    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoButton(_ sender: UIButton) {
        
        springyButton(sender)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if socialButtonActive == false {
            animateSocialButton(youtubeButton, twitterButton, activeStatus: socialButtonActive)
            socialButtonActive = true
        } else {
            animateSocialButton(youtubeButton, twitterButton, activeStatus: socialButtonActive)
            socialButtonActive = false
        }
        
    }
    
    func addBottomSheetView() {
        // 1- Init bottomSheetVC
        let bottomSheetVC = BottomSheetVC()
        
        // 2- Add bottomSheetVC as a child view
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        
        verifyAdStatus()
        
        displayTerms { (success) in
            if success {
                //Permissions function to be moved to convertButton
                self.permissions()
                
            } else{
                print("Hmm, I think an error occured somewhere")
            }
        }
        
        runAds(isAdsRemovePurchased())
        
    }
    
    //MARK: Setup View
    
    func setupView() {
        
        liveConvertHiddenButton.frame = CGRect(x: (screenSize.width * -0.02), y: (screenSize.height*0.13), width: 272, height: 48)
        liveConvertHiddenButton.setTitleColor(UIColor.red, for: .highlighted)
        //liveConvertHiddenButton.layer.backgroundColor = UIColor(red: 0/255, green: 159/255, blue: 184/255, alpha: 1.0).cgColor
        
        starButton.frame = CGRect(x: (screenSize.width * 0.8), y: (screenSize.height*0.136), width: 37, height: 37)
        
        convertButton.frame = CGRect(x: ((screenSize.width/2)-(180/2)), y: (screenSize.height*0.58), width: 180, height: 54)
        //convertButton.setTitleColor(UIColor.white, for: .normal)
        //convertButton.setTitleColor(UIColor.systemOrange, for: .highlighted)
        convertButton.backgroundColor = UIColor.systemOrange
        convertButton.layer.cornerRadius = 25
        
        loadingIndicator.center = view.center
        loadingIndicator.isHidden = true
        
        youtubeButton.imageView?.sizeToFit()
        youtubeButton.frame = CGRect(x: (screenSize.width * 0.33), y: (screenSize.height * 0.698), width: 64, height: 40)
        youtubeButton.alpha = 0
        
        twitterButton.imageView?.sizeToFit()
        twitterButton.frame = CGRect(x: (screenSize.width * 0.55), y: (screenSize.height * 0.695), width: 45, height: 45)
        twitterButton.alpha = 0
        
        infoButton.frame = CGRect(x: ((screenSize.width/2)-(195/2)), y: (screenSize.height*0.80), width: 195, height: 33)
        infoButton.backgroundColor = UIColor.systemTeal
        //infoButton.setTitleColor(UIColor.systemOrange, for: .highlighted)
        infoButton.layer.cornerRadius = 15
        
        imagePicker.delegate = self
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.videoQuality = .typeHigh
        imagePicker.videoExportPreset = AVAssetExportPresetPassthrough
        imagePicker.allowsEditing = true
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        //circle.frame = CGRect(x: convertButton.center.x, y: convertButton.center.y, width: 100, height: 100)
        //circle.layer.cornerRadius = circle.frame.size.height / 2
        //circle.backgroundColor = convertButton.backgroundColor
                
        //setGradientBackground(colorTop: UIColor.darkGray.cgColor, colorBottom: UIColor(red: 0.27, green: 0.44, blue: 0.65, alpha: 1).cgColor)
        
    }
    
    //MARK: Enable Ads
    
    func runAds(_ purchased : Bool) {
        
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        if purchased == false {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)
            
            bannerView.adUnitID = "ca-app-pub-1890050047502812/9448178019"
            bannerView.rootViewController = self
            
            //Make sure to uncomment this to re-enable ads once testing is done
            bannerView.load(GADRequest())
        }
        
    }
    
    //MARK: In-App Purchase method
    
    func removeAds(restoringPurchase: Bool) {
        
        SKPaymentQueue.default().add(self)
        
        if SKPaymentQueue.canMakePayments() {
            //can make payments; no parental control
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            if restoringPurchase == true {
                SKPaymentQueue.default().restoreCompletedTransactions()
            } else {
                SKPaymentQueue.default().add(paymentRequest)
            }
            
        } else {
            //can't make payments
            print("User can't make payments")
            let alert = UIAlertController(title: "Transaction failed", message: "User can't make payments", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
            for transaction in transactions {
                if transaction.transactionState == .purchased {
                    //User payment successful
                    print("Transaction successful")
                    //code to remove ads here
                    
                    //perform action as a one time use sort of thing to disable ads
                    
                    removeAdInstances() //All required processes have been put into the method, remove ads
                    
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    let alert = UIAlertController(title: "Transaction Successful", message: "Thanks for your purchase, you will no longer see Ads in this app.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.loadingIndicator.isHidden = true
                        alert.show()
                    })
                    
                } else if transaction.transactionState == .failed {
                    //Payment failed
                    guard let error = transaction.error else { return }
                    print("Transaction failed due to error: \(error)")
                    
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    let alert = UIAlertController(title: "Transaction Failed", message: "Transaction request cannot be processed.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.loadingIndicator.isHidden = true
                        alert.show()
                    })
                    
                } else if transaction.transactionState == .restored {
                    print("In App Purchase restored")
                    
                    //                UserDefaults.standard.set(true, forKey: productID)
                    
                    removeAdInstances()
                    
                    restored = true
                    
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    let alert = UIAlertController(title: "Restore Successful", message: "You will no longer see Ads in this app.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.loadingIndicator.isHidden = true
                        alert.show()
                    })
                }
            }
        //loadingIndicator.isHidden = true
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        let transactionCount = queue.transactions.count
        
        if transactionCount == 0 {
            print("No previous transactions found")
            
            let alert = UIAlertController(title: "Restore failed", message: "Records of a previous purchase cannot be found", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.loadingIndicator.isHidden = true
                alert.show()
            })
        }
        
    }
    
    func isAdsRemovePurchased () -> Bool {
        
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    
    func removeAdInstances() {
        
        bannerView.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: productID)
        
    }
    
    
    //MARK: Display termsAndCo and verify permissions
    
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
    
    //MARK: Verify Ad Status
    
    func verifyAdStatus() {
        
        //if case first to check core data then...
        //Show adrequestviewcontroller
        
        //getData function here
        //https://www.youtube.com/watch?v=dIXkR-2rdvM&t=165s
        
        
        //Create NSFetchRequest
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Consent")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                agreed = data.value(forKey: "termsAgreedTo") as! Bool
            }
            print(agreed)
            GADMobileAds.sharedInstance().start(completionHandler: nil)
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
        
        if traitCollection.userInterfaceStyle == .dark {
            self.view.layer.insertSublayer(gradient, at: 0)
            animateGradient()
            gradientLayerStatus = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //addBottomSheetView()
        if UserDefaults.standard.bool(forKey: productID) == false {
            starButton.pulsate()
            starButton.flash()
        }
    }
    
    //MARK: Dark Mode animation
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      // Do something
        
        if traitCollection.userInterfaceStyle == .light {
            if gradientLayerStatus == true {
                gradient.removeFromSuperlayer()
            }
        } else {
            self.view.layer.insertSublayer(gradient, at: 0)
            animateGradient()
            gradientLayerStatus = true
        }
    }
    
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 10.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    //MARK: Photo Library Permissions
    
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
    
    //MARK: Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previewVC = segue.destination as? PreviewViewController{
            let purchaseCheck = UserDefaults.standard.bool(forKey: productID)
            previewVC.previewURL = inputURL
            previewVC.purchaseCheckReceiver = purchaseCheck
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
