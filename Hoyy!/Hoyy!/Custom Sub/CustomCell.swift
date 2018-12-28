//
//  CustomCell.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/11/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var userLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: Select animation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)     
        // Configure the view for the selected state
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.userLbl.backgroundColor = UIColor.clear
        } else {
            self.userLbl.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }

        
    


}
