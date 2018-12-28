//
//  CustomPhotoCell.swift
//  Hoyy!
//
//  Created by Ethan Chen on 3/4/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CustomPhotoCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
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
            self.nameLbl.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        } else {
            self.nameLbl.backgroundColor = UIColor.clear
        }
    }

}
