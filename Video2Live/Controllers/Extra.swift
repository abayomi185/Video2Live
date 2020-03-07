////
////  PreviewViewController.swift
////  Live Convert
////
////  Created by Abayomi Ikuru on 22/08/2019.
////  Copyright © 2019 Abayomi Ikuru. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import AVKit
//import Photos
//import PhotosUI
//import MobileCoreServices
//
//
//protocol previewControllerDelegate{
//    func informationPassed(passedVideo:UIImage)
//}
//
//class PreviewViewController: UIViewController {
//
//    var previewURL: URL?
//
//    var urlDuplicate: URL?
//
//    var stillImage: UIImage?
//
//
//    var assetWriterURL: URL?
//
//    let screenSize: CGRect = UIScreen.main.bounds
//
//    var thumbnailImageURL: URL?
//    var thumbnailFinalImageURL: URL?
//
//    var imageIDProcess: Bool?
//
//    let assetIdentifierInput = UUID().uuidString
//    //important piece of the pie for assetID function
//
//    var videoURL: URL?
//    var imageURL: URL?
//
//
//    @IBOutlet weak var saveButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        guard let url = previewURL  else {
//
//            _ = navigationController?.popViewController(animated: true)
//
//            _ = UIAlertAction(title: "Ok", style: .destructive) { (action) in
//                //Respond to user selection of the action.
//                let alert = UIAlertController(title: "Error",
//                message: "Error cccured while selecting video", preferredStyle: .alert)
//                alert.addAction(.init(title: "Ok", style: .destructive, handler: { (_) in
//                print("No Video Data passed")
//                }))
//
//                self.present(alert, animated: true)
//            }
//
//            return}
//
//        urlDuplicate = url
//
//
//        let player = AVPlayer(url: url)
//        //url :: This here is the difference between if let and guard let. With guard let, the variable is open to use outside the block of code. With if let the variable is limited and can only be used within the curly braces of the if let (the block of code for the if let).
//
//        let metadata = AVPlayerItem.init(url: url)
//        print("metadata info starts here")
//        print(metadata.duration)
//
//
//
//        let playerController = AVPlayerViewController()
//
//        playerController.player = player
//
//        playerController.view.frame = CGRect(x: 0, y: topbarHeight, width: screenSize.width, height: screenSize.height * 0.72)
//        self.view.addSubview(playerController.view)
//        self.addChild(playerController)
//
//        playerController.showsPlaybackControls = false
//
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
//
//        player.play()
//
////        DispatchQueue.global(qos: .background).async {
////            self.imageFromVideo(assetURL: url, at: 0)
////            //MARK: linked to likely future issue
////            //I changed the way it delivers the info; as URL. I don't need to assign it to a variable 'Still Image'
////            //Older comment - This is my still image here that I can use for my Live Photo generation
////            //self.imageFromVideo(assetURL: url, at: 0)
////        }
////        //This is on dispatch queue because it can potentially lock up the device. Something about threads and being an intensive process
//
//
//        //MARK: Other Things to Consider
//        //PHLivePhotoView
//        //A preview in live photo form of the converted video after a save button or test button or convert button is pressed. Not sure yet
//    }
//
//    //MARK: Retrive Still Image from video
//
//    func imageFromVideo(assetURL: URL, at time: TimeInterval) -> UIImage? {
//        let asset = AVURLAsset(url: assetURL)
//
//        let assetIG = AVAssetImageGenerator(asset: asset)
//        assetIG.appliesPreferredTrackTransform = true
//        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
//
//        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
//        let thumbnailImageRef: CGImage
//
//        do {
//            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
//            //the only reason this works I Think is because i'm changing a certain property of the object and not the object value. Not sure though
//        } catch let error {
//            print("Error: \(error)")
//            return nil
//        }
//
//        //thumbnailImageURL = thumbnailImageRef as? URL
//        //thumbnailFinalImageURL = thumbnailImageRef as? URL
//        //These two don't throw errors but they really aren't doing anything
//        //MARK: Likely issue in future
//        //This might likely become an issue later due to initialisation which i've just learned about
//
//        return UIImage(cgImage: thumbnailImageRef)
//        //-> UIImage?
//        //Return type for this function
//        //return thumbnailImageURL
//    }
//
//
//    //MARK: Add assetID to image
//    func addAssetID(_ assetIdentifier: String, toImage imageURL: URL, saveTo destinationURL: URL) -> Bool {
//        guard let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil),
//            let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
//            var imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable : Any] else { return false }
//        let assetIdentifierKey = "17"
//        let assetIdentifierInfo = [assetIdentifierKey : assetIdentifier]
//        imageProperties[kCGImagePropertyMakerAppleDictionary] = assetIdentifierInfo
//        CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, imageProperties as CFDictionary)
//        CGImageDestinationFinalize(imageDestination)
//        return true
//    }
//
//
//    //MARK: Video Handling Functions
//
//    func metadataForAssetID(_ assetIdentifier: String) -> AVMetadataItem {
//            let item = AVMutableMetadataItem()
//            let keyContentIdentifier =  "com.apple.quicktime.content.identifier"
//            let keySpaceQuickTimeMetadata = "mdta"
//            item.key = keyContentIdentifier as (NSCopying & NSObjectProtocol)?
//            item.keySpace = AVMetadataKeySpace(rawValue: keySpaceQuickTimeMetadata)
//            item.value = assetIdentifier as (NSCopying & NSObjectProtocol)?
//            item.dataType = "com.apple.metadata.datatype.UTF-8"
//            return item
//    }
//
//    func createMetadataAdaptorForStillImageTime() -> AVAssetWriterInputMetadataAdaptor {
//        let keyStillImageTime = "com.apple.quicktime.still-image-time"
//        let keySpaceQuickTimeMetadata = "mdta"
//        let spec : NSDictionary = [
//            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as NSString:
//            "\(keySpaceQuickTimeMetadata)/\(keyStillImageTime)",
//            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as NSString:
//            "com.apple.metadata.datatype.int8"            ]
//        var desc : CMFormatDescription? = nil
//        CMMetadataFormatDescriptionCreateWithMetadataSpecifications(allocator: kCFAllocatorDefault, metadataType: kCMMetadataFormatType_Boxed, metadataSpecifications: [spec] as CFArray, formatDescriptionOut: &desc)
//        let input = AVAssetWriterInput(mediaType: .metadata,
//                                       outputSettings: nil, sourceFormatHint: desc)
//        return AVAssetWriterInputMetadataAdaptor(assetWriterInput: input)
//    }
//
//    func metadataItemForStillImageTime() -> AVMetadataItem {
//        let item = AVMutableMetadataItem()
//        let keyStillImageTime = "com.apple.quicktime.still-image-time"
//        let keySpaceQuickTimeMetadata = "mdta"
//        item.key = keyStillImageTime as (NSCopying & NSObjectProtocol)?
//        item.keySpace = AVMetadataKeySpace(rawValue: keySpaceQuickTimeMetadata)
//        item.value = 0 as (NSCopying & NSObjectProtocol)?
//        item.dataType = "com.apple.metadata.datatype.int8"
//        return item
//    }
//
//    //MARK: Documents directory
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//
//    //MARK: Save Button
//
//    @IBAction func saveButton(_ sender: UIButton) {
//
//
//        let thumbnailUIImage = imageFromVideo(assetURL: urlDuplicate!, at: .zero)
//
//        //guard let imageData = thumbnailUIImage?.jpegData(compressionQuality: 1) else { return }
//
//        guard let image = thumbnailUIImage?.jpegData(compressionQuality: 1) else { return }
//        let imageURL = getDocumentsDirectory().appendingPathComponent("copy.png")
//        try? image.write(to: imageURL)
//
//        var image2URL = imageURL
//
//        print("xx-00")
//        print("\(imageURL)")
//        print("xx-01")
//        print("\(String(describing: urlDuplicate))")
//        print("xx-02")
//
//        imageIDProcess = addAssetID(assetIdentifierInput, toImage: imageURL, saveTo: image2URL)
//        //There's no value inside thumbnailImageURL and thumbnailFinalImageURL
//        //MARK: Check this
//
//        guard let assetWriter = try? AVAssetWriter(url: urlDuplicate!, fileType: .mov) else { return }
//        //guard let assetWriter = try? AVAssetWriter(url: assetWriterURL!, fileType: .mov) else { return }
//
//        assetWriter.metadata = [metadataForAssetID(assetIdentifierInput)]
//
//        let stillImageTimeMetadataAdapter = createMetadataAdaptorForStillImageTime()
//        assetWriter.add(stillImageTimeMetadataAdapter.assetWriterInput)
//
//        // Start the Asset Writer
//        assetWriter.startWriting()
//        assetWriter.startSession(atSourceTime: CMTime.zero)
//        // Add still image metadata
//        stillImageTimeMetadataAdapter.append(AVTimedMetadataGroup(items: [metadataItemForStillImageTime()],timeRange: .zero))
//
////        var livePhotoRequestID:PHLivePhotoRequestID = PHLivePhotoRequestIDInvalid
////        livePhotoRequestID = PHLivePhoto.request(withResourceFileURLs: [urlDuplicate!, imageURL], placeholderImage: nil, targetSize: CGSize.zero, contentMode: PHImageContentMode.aspectFit, resultHandler: { (livePhoto: PHLivePhoto?, info: [AnyHashable : Any]) -> Void in
////            print("livePhoto")
////            //livePhoto
////        })
//
//        var livePhotoRequestID:PHLivePhotoRequestID = PHLivePhotoRequestIDInvalid
//        livePhotoRequestID = PHLivePhoto.request(withResourceFileURLs: [urlDuplicate!, image2URL], placeholderImage: nil, targetSize: CGSize.zero, contentMode: PHImageContentMode.aspectFit, resultHandler: { (livePhoto: PHLivePhoto?, info: [AnyHashable : Any]) -> Void in
//            //completion(livePhoto)
//
//        })
//
//        PHPhotoLibrary.shared().performChanges({
//            let creationRequest = PHAssetCreationRequest.forAsset()
//            let options = PHAssetResourceCreationOptions()
//            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: self.urlDuplicate!, options: options)
//            //creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: self.assetWriterURL!, options: options)
//            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: image2URL, options: options)
//        }, completionHandler: { (success, error) in
//            if error != nil {
//                print(error!)
//            }
//            (success)
//            self.navigationController?.popToRootViewController(animated: true)
//
//            _ = UIAlertAction(title: "Yay!", style: .default) { (action) in
//                //Respond to user selection of the action.
//                let alert = UIAlertController(title: "Success",
//                                              message: "Live Wallpaper saved to Photo Library", preferredStyle: .alert)
//                alert.addAction(.init(title: "Ok", style: .destructive, handler: { (_) in
//                    print("Success")
//                }))
//
//                self.present(alert, animated: true)
//            }
//        })
//
//
//        //popback to main VC
//
//
//    }
//
//}
//
//
//extension UIViewController {
//
//    /**
//     *  Height of status bar + navigation bar (if navigation bar exist)
//     */
//
//    var topbarHeight: CGFloat {
//        if #available(iOS 13.0, *) {
//            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
//                (self.navigationController?.navigationBar.frame.height ?? 0.0)
//        } else {
//            // Fallback on earlier versions
//            return UIApplication.shared.statusBarFrame.size.height +
//            (self.navigationController?.navigationBar.frame.height ?? 0.0)
//        }
//    }
//}
//
//
//
