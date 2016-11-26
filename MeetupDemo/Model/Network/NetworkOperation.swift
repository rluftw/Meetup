//
//  NetworkOperation.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/19/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import Foundation

class NetworkOperation {
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.config)
    let queryURL: URL

    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: URL) {
        queryURL = url
    }
    
    func downloadJSONFromURL(_ completion: @escaping JSONDictionaryCompletion) {
        let request = URLRequest(url: queryURL)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        if let retrievedData = data {
                            if let JSONDictionary = try JSONSerialization.jsonObject(with: retrievedData, options: .mutableLeaves) as? [String: AnyObject] {
                                completion(JSONDictionary)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "dataFinishedLoading"), object: self)
                            }
                        }
                    } catch { print("nil Value") }
                default:
                    print("get request not successful. HTTP status code: \(httpResponse.statusCode)")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "dataNotFinishedLoading"), object: self)
                }
            } else {
                print("Invalid HTTP response")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "dataNotFinishedLoading"), object: self)
            }
        }) 
        
        dataTask.resume()
    }

}
