//
//  MeetupGroup.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/19/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

struct MeetupGroup {
    let joinMode: String?   // Values consist of "open", "approval", or "closed"
    let created: Int?       // Date and time that the group was founded, in milliseconds since the epoch
    let name: String?       // Group name
    let urlName: String?    // Group URL name
    let who: String?        // What the group calls its members
    let id: Int?            // Groups ID
}