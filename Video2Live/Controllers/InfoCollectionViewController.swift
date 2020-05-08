//
//  InfoCollectionViewController.swift
//  SimpleConvert
//
//  Created by Abayomi Ikuru on 21/01/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class InfoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "socialCell"
    
    var socialMedia = ["YomiTosh", "@yomi185"]
    
    var logoImages: [UIImage] = [UIImage(named: "youtube.png")!, UIImage(named: "twitter.png")!]
    
    var socialMediaLinks = ["http://youtube.com/yomitosh", "http://twitter.com/yomi_185"]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
//Recently commented this out
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        self.collectionView.contentInset = centerItemsInCollectionView(cellWidth: 185.0, numberOfItems: Double(socialMedia.count), spaceBetweenCell: 10, collectionView: collectionView)
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return socialMedia.count
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return socialMedia.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InfoCollectionViewCell
//        cell.backgroundColor = .black
    
        // Configure the cell
//        let image = myImages[indexPath.row]
//        cell.imageView.image = image
        
        let socialMediaLogo = photo(for: indexPath)
        let socialMediaUsername = self.socialMedia[indexPath.row]
        
//        cell.infoImage.image = socialMediaLogo
//        cell.infoLabel.text = socialMediaUsername
        cell.infoLabelButton.frame = CGRect(x: 0, y: 130, width: 120, height: 35)
        cell.infoLabelButton.setTitle(socialMediaUsername, for: .normal)
        cell.infoLabelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        
//        cell.infoImage.isHidden = true
//        cell.infoLabel.isHidden = true
        //Disabled UIImageView until further notice
        
        cell.infoButton.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        cell.infoButton.setImage(socialMediaLogo, for: .normal)
        cell.infoButton.imageView?.contentMode = .scaleAspectFit
        
        //Giving the boss its intern
        cell.socialDelegate = self
        cell.infoButton.tag = indexPath.row
        cell.infoLabelButton.tag = indexPath.row
        
        return cell
        
    }
    
    
    func photo(for IndexPath: IndexPath) -> UIImage {
        return logoImages[IndexPath.row]
    }
    
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 185)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension InfoCollectionViewController: socialDataDelegate {
    
    func didPressButton(_ tag: Int) -> String {
        print("I have pressed a button with a tag: \(tag)")
        return socialMediaLinks[tag]
    }

}
