//
//  AddressTableViewCell.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/21/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet var address1: UILabel?
    @IBOutlet var address2: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
