//
//  MeetupService.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/18/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

struct MeetupService {
    let meetupAPIKey: String
    let meetupBaseURL: String
    
    init(APIKey: String, category: Int = 34) {
        meetupAPIKey = APIKey
        meetupBaseURL = "https://api.meetup.com/2/open_events.json?key=\(meetupAPIKey)&category=\(category)"
    }
    
    func getMeetups(lat lat: Double, lon: Double, completion: MeetupResponse -> Void) {
        if let meetupURL = NSURL(string: meetupBaseURL + "&lat=\(lat)&lon=\(lon)") {
            let networkOperation = NetworkOperation(url: meetupURL)
            networkOperation.downloadJSONFromURL({ (JSONDictionary) -> Void in
                let meetups = MeetupResponse(meetupDictionary: JSONDictionary!)
                completion(meetups)
            })
        }
    }
}