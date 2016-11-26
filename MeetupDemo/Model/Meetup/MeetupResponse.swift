//
//  MeetupResponse.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/19/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

class MeetupResponse {
    var results: [Meetup]?
    
    init(meetupDictionary: [String: AnyObject]) {
        if let allMeetups = meetupDictionary["results"] as? [[String: AnyObject]] {
            results = allMeetups.map({ (meetupDictionary) -> Meetup in
                var eventDescription = meetupDictionary["description"] as? String
                eventDescription = eventDescription?.replacingOccurrences(of: "(<[^>]+>)",
                    with: "",
                    options: .regularExpression,
                    range: nil)
                
                var eventURL: URL?
                if let url = meetupDictionary["event_url"] as? String {
                    eventURL = URL(string: url)
                }
                
                let yesRSVPCount = meetupDictionary["yes_rsvp_count"] as? Int
                
                let eventDuration = meetupDictionary["duration"] as? Int
                let eventID = meetupDictionary["id"] as? String
                let eventTime = meetupDictionary["time"] as? Int
                let eventStatus = meetupDictionary["status"] as? String
                let eventName = meetupDictionary["name"] as? String
                
                // Gather data from the "venue" dictionary
                let venueDictionary = meetupDictionary["venue"] as? [String: AnyObject]
                
                let venueName = venueDictionary?["name"] as? String
                let venueCity = venueDictionary?["city"] as? String
                let venueState = venueDictionary?["state"] as? String
                let venueLon = venueDictionary?["lon"] as? Double
                let venueLat = venueDictionary?["lat"] as? Double
                let venuePhone = venueDictionary?["phone"] as? String
                let venueAddress1 = venueDictionary?["address_1"] as? String
                let venueAddress2 = venueDictionary?["address_2"] as? String
                
                let venue = MeetupVenue(
                    name: venueName,
                    city: venueCity,
                    state: venueState,
                    lon: venueLon,
                    lat: venueLat,
                    phone: venuePhone,
                    address1: venueAddress1,
                    address2:  venueAddress2)

                
                // Gather data from the "group" dictionary
                let groupDictionary = meetupDictionary["group"] as! [String: AnyObject]
                
                let joinMode = groupDictionary["join_mode"] as? String
                let groupCreation = groupDictionary["created"] as? Int
                let groupName = groupDictionary["name"] as? String
                let groupURLName = groupDictionary["urlname"] as? String
                let groupID = groupDictionary["id"] as? Int
                let groupWho = groupDictionary["who"] as? String
               
                
                let group = MeetupGroup(
                    joinMode: joinMode,
                    created: groupCreation,
                    name: groupName,
                    urlName: groupURLName,
                    who: groupWho,
                    id: groupID
                )
                
                print("Fetch TEST")
                
                return Meetup(
                    eventName: eventName,
                    meetupDescription: eventDescription,
                    eventURL: eventURL,
                    yesRSVPCount: yesRSVPCount,
                    durationInMillisec: eventDuration,
                    id: eventID,
                    timeInMillisec: eventTime,
                    status: eventStatus,
                    group: group,
                    venue: venue
                )
            })
        }
    }
}
