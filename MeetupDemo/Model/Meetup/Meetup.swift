//
//  Meetup.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/19/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

class Meetup {
    let timeInMillisec: Int?
    let durationInMillisec: Int?
    var meetupDescription: String?
    let eventURL: URL?
    let yesRSVPCount: Int?
    let id: String?
    let status: String?
    let name: String?
    let group: MeetupGroup
    let venue: MeetupVenue
    
    var duration: Int? {
        get {
            guard let millisecTime = durationInMillisec else { return nil }
            return millisecTime/1000
        }
    }
    
    var startTime: Int? {
        get {
            guard let millisecTime = timeInMillisec else { return nil }
            return millisecTime/1000
        }
    }
    
    init(eventName: String?, meetupDescription: String?, eventURL: URL?, yesRSVPCount: Int?,
        durationInMillisec: Int?, id: String?, timeInMillisec: Int?, status: String?, group: MeetupGroup, venue: MeetupVenue) {
        self.name = eventName
        self.meetupDescription = meetupDescription
        self.eventURL = eventURL
        self.yesRSVPCount = yesRSVPCount
        self.durationInMillisec = durationInMillisec
        self.id = id
        self.timeInMillisec = timeInMillisec
        self.status = status
        self.group = group
        self.venue = venue
    }
}
