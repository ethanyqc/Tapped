//
//  phoneView.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/24/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class phoneView: UIView {

    var cornerradius : CGFloat = 10
    
    
    
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerradius
        
        
    }

}
