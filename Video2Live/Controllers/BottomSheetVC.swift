//
//  BottomSheetVC.swift
//  Video2Live
//
//  Created by Abayomi Ikuru on 04/05/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

class BottomSheetVC : UIViewController {
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds

        view.insertSubview(bluredView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            UIView.animate(withDuration: 0.3) { [weak self] in
                let frame = self?.view.frame
                let yComponent = UIScreen.main.bounds.height - 200
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)

    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        //let frame = self.view.frame
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        //self.view.frame = CGRect(x: 0, y: 200, width: frame.width, height: frame.height)
    }
    
}
