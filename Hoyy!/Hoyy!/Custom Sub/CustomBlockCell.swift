//
//  CustomBlockCell.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/10/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CustomBlockCell: UITableViewCell {

    @IBOutlet weak var blockLbl: UILabel!
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
            self.blockLbl.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        } else {
            self.blockLbl.backgroundColor = UIColor.clear
        }
    }

}
