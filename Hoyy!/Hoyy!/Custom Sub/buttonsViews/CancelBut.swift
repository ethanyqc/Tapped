//
//  CancelBut.swift
//  Hoyy!
//
//  Created by Ethan Chen on 5/19/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CancelBut: UIButton {

    var shadowOffSetWidth : CGFloat = 0
    var shadowOffSetHeight : CGFloat = 5
    var shadowColor : UIColor = UIColor.black
    var shadowOpacity : CGFloat = 0.5
    var corRad : CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBtton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBtton()
    }
    func initBtton() {
        //layer.borderWidth = 5.0
        //layer.borderColor = UIColor.white.cgColor

        layer.cornerRadius = corRad
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corRad)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)

    }

}
