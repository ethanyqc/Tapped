//
//  CustomPicCell.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/30/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CustomPicCell: UITableViewCell {

    
    @IBOutlet weak var picUserLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.picUserLbl.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        } else {
            self.picUserLbl.backgroundColor = UIColor.clear
        }
    }

}
