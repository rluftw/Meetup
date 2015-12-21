//
//  GPSPromptViewController.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/20/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreLocation

class GPSPromptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onResume", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func onResume() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
