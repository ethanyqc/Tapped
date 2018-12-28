//
//  ButtonView.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/25/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class ButtonView: UIView {

    //for little circles
    var cornerradius : CGFloat = 15
    var shadowOffSetWidth : CGFloat = 0
    var shadowOffSetHeight : CGFloat = 5
    var shadowColor : UIColor = UIColor.black
    var shadowOpacity : CGFloat = 0.5
    
    
    
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }

}
