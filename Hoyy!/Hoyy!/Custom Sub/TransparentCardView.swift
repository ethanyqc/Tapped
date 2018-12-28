//
//  TransparentCardView.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/30/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class TransparentCardView: UIView {

     var borderWidth : CGFloat = 1
     var cornerradius : CGFloat = 2
    var shadowOffSetWidth : CGFloat = 0
    var shadowOffSetHeight : CGFloat = 5
    var shadowColor : UIColor = UIColor.black
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.borderWidth = borderWidth
         layer.cornerRadius = cornerradius
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
    

}
