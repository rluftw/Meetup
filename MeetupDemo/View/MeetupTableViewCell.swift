//
//  MeetupTableViewCell.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/20/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class MeetupTableViewCell: UITableViewCell {

    @IBOutlet var background: UIView?
    @IBOutlet var meetupTitle: UILabel?
    @IBOutlet var meetupGroupName: UILabel?
    @IBOutlet var meetupYesRSVP: UILabel?
    @IBOutlet var startTime: UILabel?
    @IBOutlet var meetupDate: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
