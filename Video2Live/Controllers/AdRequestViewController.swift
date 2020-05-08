//
//  AdRequestViewController.swift
//  SimpleConvert
//
//  Created by Abayomi Ikuru on 10/02/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdRequest: UIViewController {
    
    var adRequestContainer: NSPersistentContainer!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var termsAndConditions: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    
    //let terms: String = "These are the terms and conditions for using this application"
    
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        
//        let mainvc = ViewController()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        //Change value of variable in CoreData here to true and dismiss view controller
        
        //Setting up entites and getting app ready to store into CoreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Consent", in: context)
        //new entity to save into database
        //entity as in the entity created above and insertinto as in the context created above
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
     
        //Set a value of item created in CoreData
        newEntity.setValue(true, forKey: "termsAgreedTo")
        
        do{
            try context.save()
            dismiss(animated: true, completion: nil)
            print("terms have been agreed to")
        } catch{
            print("Failed to agree to terms")
        }
    }
    
    override func viewDidLoad() {
        
        agreeButton.frame = CGRect(x: ((screenSize.width/2)-(180/2)), y: (screenSize.height*0.71), width: 180, height: 54)
        agreeButton.setTitleColor(UIColor.systemPurple, for: .highlighted)
        agreeButton.backgroundColor = UIColor.systemGreen
        agreeButton.layer.cornerRadius = 25
        agreeButton.setTitle("Agree and Continue", for: .normal)
        agreeButton.setTitleColor(UIColor.white, for: .normal)
        
        termsAndConditions.frame = CGRect(x: ((0.5*screenSize.width)-((0.9*screenSize.width)/2)), y: (0.1*screenSize.height), width: (0.9*screenSize.width), height: (0.57*screenSize.height))
        //termsAndConditions.text = terms
        termsAndConditions.layer.borderColor = UIColor.lightGray.cgColor
        termsAndConditions.layer.borderWidth = 1.0
        
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true // available in IOS13
        }else{
            modalPresentationStyle = .fullScreen
        }
        
    }
    
    
}
