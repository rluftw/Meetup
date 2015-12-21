//
//  ViewController.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/18/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit
import JHSpinner
import CoreLocation

class MeetupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var tableHeaderView: UIView? {
        didSet {
            tableHeaderView?.backgroundColor = UIColor(patternImage: UIImage(named: "ignasi_pattern_s")!)
        }
    }
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.rowHeight = UITableViewAutomaticDimension
            tableView?.estimatedRowHeight = 102
        }
    }
    var spinner: JHSpinnerView?
    
    private var APIKey = "API KEY HERE"
    var locationManager = CLLocationManager()
    
    // Model
    var meetups: [Meetup]?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Tech Meetups"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observe when data is finished loading
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataFetchFail:", name: "dataNotFinishedLoading", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataFetchSuccess:", name: "dataFinishedLoading", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "dataNotFinishedLoading", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "dataFinishedLoading", object: nil)
    }
    
    // Todo: Look back at this after pull to refresh implementation
    /*override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .Denied {
            performSegueWithIdentifier("GPSRequestNotify", sender: self)
        }
    }*/
    
    // MARK: - TableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = meetups?.count else { return 0 }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MeetupTableViewCell
        
        cell.selectionStyle = .None;
        
        if let name = meetups?[indexPath.row].name {
            cell.meetupTitle?.text = name
        }
        
        if let groupName = meetups?[indexPath.row].group.name {
            cell.meetupGroupName?.text = groupName
        }
        
        if let yesRSVPCount = meetups?[indexPath.row].yesRSVPCount, let groupWho = meetups?[indexPath.row].group.who {
            cell.meetupYesRSVP?.text = "\(yesRSVPCount) \(groupWho)"
        }
        
        if let startTime = meetups?[indexPath.row].startTime {
            let (date, time) = dateFromUnixTime(startTime)
            
            cell.startTime?.text = time
            cell.meetupDate?.text = date
        }
        
         cell.background?.backgroundColor = UIColor(patternImage: UIImage(named: "restaurant_icons")!)
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    // MARK: - CLLocationManager Delegate Methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            spinner = JHSpinnerView.showOnView(view,
                spinnerColor:UIColor.whiteColor(),
                overlay:.Circular,
                overlayColor:UIColor(red: 29/255.0, green: 207/255.0, blue: 161/255, alpha: 0.9))
            view.addSubview(spinner!)
            locationManager.startUpdatingLocation()
        case .Denied:
            if navigationController?.viewControllers.last is MeetupsViewController {
                spinner?.dismiss()
                performSegueWithIdentifier("GPSRequestNotify", sender: self)
            }
        default: break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let coordinates = locations.last?.coordinate {
            updateData(lat: coordinates.latitude, lon: coordinates.longitude)
        }
        
        print("Location Updated")
    }
    
    // MARK: - Observer Methods
    
    func dataFetchSuccess(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.spinner?.dismiss()
            self.tableView?.reloadData()
        }
    }
    
    func dataFetchFail(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.spinner?.dismiss()
            
            // May stack
            if !(self.navigationController?.viewControllers.last is UIAlertController) {
                let alert = UIAlertController(
                    title: "Network Error",
                    message: "Failed to retrieve meetups. Please check your network connection.",
                    preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func updateData(lat lat: Double, lon: Double) {
        // CLLocationManager to gather Location
        MeetupService(APIKey: APIKey).getMeetups(lat:lat, lon:lon) { (response) -> Void in
            self.meetups = response.results
        }
    }
    
    func dateFromUnixTime(time: Int) -> (date: String, time: String) {
        let dateObject = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let date = formatter.stringFromDate(dateObject)

        formatter.dateFormat = "h:mm a"
        let time = formatter.stringFromDate(dateObject)
        
        return (date, time)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMeetupDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView?.indexPathForCell(cell)
                if let detailVC = segue.destinationViewController as? MeetupDetailViewController {
                    detailVC.meetup = meetups![indexPath!.row]
                }
            }
        }
    }
}

