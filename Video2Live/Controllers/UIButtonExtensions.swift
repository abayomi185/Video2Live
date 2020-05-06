//
//  UIButtonExtensions.swift
//  Video2Live
//
//  Created by Abayomi Ikuru on 04/05/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 3
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
 
    func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 2
    flash.fromValue = 1
    flash.toValue = 0.2
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 4
    layer.add(flash, forKey: nil)
    }
    
}
