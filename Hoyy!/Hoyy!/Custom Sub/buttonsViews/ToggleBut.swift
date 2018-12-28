//
//  ToggleBut.swift
//  Hoyy!
//
//  Created by Ethan Chen on 5/16/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class ToggleBut: UIButton {

    var isOn = false
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
        backgroundColor = UIColor.black
        layer.cornerRadius = corRad
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corRad)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        setTitleColor(UIColor.white, for: .normal)
        addTarget(self, action: #selector(ToggleBut.buttonPressed), for: .touchUpInside)
    }
    @objc func buttonPressed() {
        buttonActivated(bool: !isOn)
    }
    func buttonActivated(bool: Bool) {
        isOn = bool
        let color = bool ? UIColor.white : UIColor.black
        let titleColor = bool ? UIColor.black : UIColor.white
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
        
    }
}
