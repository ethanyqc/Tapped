//
//  Date+toString.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/6/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
//MARK: date extension
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
