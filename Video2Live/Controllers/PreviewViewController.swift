//
//  PreviewViewController.swift
//  SimpleConvert
//
//  Created by Abayomi Ikuru on 22/08/2019.
//  Copyright © 2019 Abayomi Ikuru. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import PhotosUI
import MobileCoreServices
import GoogleMobileAds

class PreviewViewController: UIViewController, PHLivePhotoViewDelegate {
    
    //var live = LivePhoto()
    
    var previewURL: URL?
    var urlDuplicate: URL?
    let screenSize: CGRect = UIScreen.main.bounds

    let assetIdentifierInput = UUID().uuidString
//    important piece of the pie for assetID function
    
    var photoURL: URL?
    var image: UIImage?
    
    var playerController: AVPlayerViewController?
    var livePhotoBadgeLayer = CALayer()
    //var livePhotoView: PHLivePhotoView?
    @IBOutlet weak var livePhotoView: PHLivePhotoView!
    
    var livePhotoStore: PHLivePhoto?
    //typealias livePhotoResources = (pairedImage: URL, pairedVideo: URL)
    var resourceStore: Any?
    
    var videoURL: URL?
    
    //pretty sure this is unused
    //var completion: Bool?
    
    //Google Interstitial Ad
    var interstitialAd: GADInterstitial!
    
    //MARK: Initial viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.frame = CGRect(x: (screenSize.width/2)-(184/2), y: (screenSize.height*0.86), width: 184, height: 37)
        activityIndicator.frame = CGRect(x: (screenSize.width/2)-(150/2), y: (screenSize.height/2), width: 150, height: 3)
        livePhotoView.frame = CGRect(x: (screenSize.width/2)-(343/2), y: (screenSize.height*0.108), width: (screenSize.width*0.91), height: (screenSize.height*0.68))
        progressView.frame = CGRect(x: (screenSize.width/2)-(125/2), y: (screenSize.height*0.93), width: 125, height: 2.5)
        
        guard let url = previewURL  else {

            _ = navigationController?.popViewController(animated: true)

            alert(alertTitle: "Error", AlertMessage: "Error cccured while selecting video")
            
            navigationController?.popViewController(animated: true)

            return}

        urlDuplicate = url
        
        saveAsLive(0)

        //MARK: New Implementation
        
        livePhotoView.contentMode = UIView.ContentMode.scaleAspectFit
        livePhotoView.delegate = self
        livePhotoView(livePhotoView, willBeginPlaybackWith: .hint)
        
        
//        interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let request = GADRequest()
//        interstitialAd.load(request)
        
        interstitialAd = createAndLoadInterstitial()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        livePhotoView.frame = CGRect(x: 0, y: topbarHeight, width: screenSize.width, height: screenSize.height * 0.72)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        livePhotoViewStop(livePhotoView)
    }
    
    
    func loadInterstitial(completion: (Bool)->Void){
        if interstitialAd.isReady {
          interstitialAd.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        completion(true)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1890050047502812/3288610105")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitialAd = createAndLoadInterstitial()
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    //MARK: Save Button
    
    @IBOutlet weak var saveButton: UIButton!

    
    @IBAction func saveButton(_ sender: UIButton) {
        
        loadInterstitial { (success) in
            if success && interstitialAd.isReady {
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.saveAsLive(1)
                }
            } else if success {
                self.saveAsLive(1)
            }
        }
        
        
        //saveAsLive(1)
        //To determine whether alert should should. I intend to use the live photo generated to preview as live photo. I would probably also need a progres bar for this process.

    }

    //TODO: Set up Nav Bar mute button
    
    
    //MARK: Save as LivePhoto
    
    func saveAsLive(_ choice:Int) {
        
        saveButton.isEnabled = false
        
        if #available(iOS 13.0, *) {
            activityIndicator.startAnimating()
        }
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
           guard let sourceVideoPath = self.urlDuplicate else {
               self.alert(alertTitle: "It seems a video was not selected.", AlertMessage: "Try again.")
               return
           }
           if let sourceKeyPhoto = self.image {
               guard let data = sourceKeyPhoto.jpegData(compressionQuality: 1.0) else { return }
               photoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("photo.jpg")
               if let photoURL = photoURL {
                   try? data.write(to: photoURL)
               }
           }
        
        if choice == 1{
            LivePhoto.saveToLibrary(resourceStore as! LivePhoto.LivePhotoResources, completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.saveButton.isEnabled = true
                                
                                if #available(iOS 13.0, *) {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
                                
                                //show alert
                                let alertController = UIAlertController(title: "Live Photo Saved!", message: "The live photo was successfully saved to Photos.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                    self.saveButton.isEnabled = false
                                    self.navigationController?.popViewController(animated: true)
                                }))
//                                alertController.addAction(UIAlertAction(title: "Open Photos", style: .cancel, handler: { (UIAlertAction) in
//                                        UIApplication.shared.open(URL(string:"photos-redirect://")!)
//                                }))
                                alertController.show()
                            }
                            print("success")
                        }
                        else {
                            DispatchQueue.main.async {
                                self.alert(alertTitle: "Live Photo Not Saved", AlertMessage:"The live photo was not saved to Photos.")
                            }
                            print("fail")
                        }
                    })
            //popback to main VC
            livePhotoViewStop(livePhotoView)
            
            //navigationController?.popViewController(animated: true)
            
        }
        else{
            LivePhoto.generate(from: photoURL, videoURL: sourceVideoPath, progress: { (percent) in
                DispatchQueue.main.async {
                    self.progressView.progress = Float(percent)
                }
            }) { (livePhoto, resources) in
                
                //Saves are right here
                self.livePhotoStore = livePhoto
                self.resourceStore = resources
                
                //Just testing out something here
                self.livePhotoView!.livePhoto = livePhoto
                self.saveButton.isEnabled = true
                self.progressView.isHidden = true
                print("Order 66 executed")
            }
        }
    }
    
    
    // MARK: PHLivePhotoViewDelegate
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        //self.livePhotoBadgeLayer.opacity = 0.0
        livePhotoView.startPlayback(with: playbackStyle)
    }
    func livePhotoViewStop(_ livePhotoView: PHLivePhotoView) {
        livePhotoView.stopPlayback()
    }
    
    func popVC(alertAction: UIAlertAction){
        navigationController?.popViewController(animated: true)
    }
    
}



extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    func alert(alertTitle: String, AlertMessage: String) {
            let alert = UIAlertController(title: alertTitle,
            message: AlertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
    }
    //it works without declaration in other vc because this is an extension of uiviewcontroller which the other view controller inherits from
}



extension UIAlertController {

    func show() {
        present(animated: true, completion: nil)
    }

    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }

    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
        if let tabVC = controller as? UITabBarController,
            let selectedVC = tabVC.selectedViewController {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        } else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
}
