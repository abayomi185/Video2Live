//
//  InfoCollectionViewCell.swift
//  SimpleConvert
//
//  Created by Abayomi Ikuru on 22/01/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

protocol socialDataDelegate : class {
    func didPressButton(_ tag: Int) -> String
}

class InfoCollectionViewCell: UICollectionViewCell {
    
    var link: String?
    
    var socialDelegate: socialDataDelegate?
    //try passing button ta instead socialButtonTag
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //This doesn't work cause it assumes the storyboard is not in use and then it has a conflict.
    
//    @IBOutlet weak var infoImage: UIImageView!
//    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabelButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBAction func infoButtonAction(_ sender: UIButton) {
        link = socialDelegate?.didPressButton(sender.tag)
        //socialDelegate?.socialLink()
        
        guard let url = URL(string: link!) else { return }
        
        //print(link)
        print(url)
        
        UIApplication.shared.open(url)
    }
    

    func setupViews() {
//        infoImage.frame = CGRect(x: 0, y: 0, width: 185, height: 150)
        infoButton.frame = CGRect(x: 0, y: 0, width: 185, height: 150)
//        infoLabel.frame = CGRect(x: 0, y: 150, width: 185, height: 35)
        infoLabelButton.frame = CGRect(x: 0, y: 150, width: 185, height: 35)
        
    }
    
}
