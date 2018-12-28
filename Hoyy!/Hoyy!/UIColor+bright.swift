//
//  UIColor+bright.swift
//  Hoyy!
//
//  Created by Ethan Chen on 4/20/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
