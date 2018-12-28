//
//  CustomInboxCell.swift
//  Hoyy!
//
//  Created by Ethan Chen on 2/22/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class CustomInboxCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var msgType: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
