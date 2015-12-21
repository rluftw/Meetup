//
//  DetailedMeetupTableViewCell.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/20/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class DetailedMeetupTableViewCell: UITableViewCell {
    
    @IBOutlet var eventName: UILabel?
    @IBOutlet var eventDescription: UILabel?
    @IBOutlet var eventStatus: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
