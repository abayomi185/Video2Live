//
//  Gradient.swift
//  Video2Live
//
//  Created by Abayomi Ikuru on 14/03/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor.black.cgColor
        let colorBottom = UIColor.blue.cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
