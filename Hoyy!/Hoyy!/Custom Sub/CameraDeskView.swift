//
//  CameraDeskView.swift
//  Hoyy!
//
//  Created by Ethan Chen on 3/4/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CameraDeskView: UIView {

    var cornerradius : CGFloat = 40
    var color = UIColor.red
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }

}
