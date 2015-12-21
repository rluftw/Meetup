//
//  NetworkOperation.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/19/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

class NetworkOperation {
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL

    typealias JSONDictionaryCompletion = [String: AnyObject]? -> Void
    
    init(url: NSURL) {
        queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        let request = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        if let retrievedData = data {
                            if let JSONDictionary = try NSJSONSerialization.JSONObjectWithData(retrievedData, options: .MutableLeaves) as? [String: AnyObject] {
                                completion(JSONDictionary)
                                NSNotificationCenter.defaultCenter().postNotificationName("dataFinishedLoading", object: self)
                            }
                        }
                    } catch { print("nil Value") }
                default:
                    print("get request not successful. HTTP status code: \(httpResponse.statusCode)")
                    NSNotificationCenter.defaultCenter().postNotificationName("dataNotFinishedLoading", object: self)
                }
            } else {
                print("Invalid HTTP response")
                NSNotificationCenter.defaultCenter().postNotificationName("dataNotFinishedLoading", object: self)
            }
        }
        
        dataTask.resume()
    }

}