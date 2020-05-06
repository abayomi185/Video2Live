//
//  AnimatedGradient.swift
//  Video2Live
//
//  Created by Abayomi Ikuru on 05/05/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
