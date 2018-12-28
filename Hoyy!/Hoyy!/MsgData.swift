//
//  MsgData.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/30/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
class MsgData {

    static let instance = MsgData()
    private var _msg = "😉"
    private var _color = UIColor.white
    private var _colorStr = "" + UIColor.white.hexString()
    private var _isBlack = true
    var msg: String {
        return _msg
    }
    var color: UIColor {
        return _color
    }
    var colorStr: String {
        return _colorStr
    }
    var isBlack: Bool {
        return _isBlack
    }
    func changeMsg(msg: String) {
        _msg = msg
    }
    func toggleText(isBlk: Bool) {
        _isBlack = isBlk
    }
    func changeColor(color: UIColor) {
        let colorStrToChg = color.hexString()
        _colorStr = colorStrToChg
        _color = color
    }

}
