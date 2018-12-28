//
//  Scroll+paging.swift
//  Hoyy!
//
//  Created by Ethan Chen on 4/30/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}
