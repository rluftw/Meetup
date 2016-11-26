//
//  ViewController.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/18/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit
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
    
    fileprivate var APIKey = "5e5777d5e6b4037445d7d2845233672"
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observe when data is finished loading
        NotificationCenter.default.addObserver(self, selector: #selector(MeetupsViewController.dataFetchFail(_:)), name: NSNotification.Name(rawValue: "dataNotFinishedLoading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeetupsViewController.dataFetchSuccess(_:)), name: NSNotification.Name(rawValue: "dataFinishedLoading"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataNotFinishedLoading"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataFinishedLoading"), object: nil)
    }
    
    // Todo: Look back at this after pull to refresh implementation
    /*override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .Denied {
            performSegueWithIdentifier("GPSRequestNotify", sender: self)
        }
    }*/
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = meetups?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MeetupTableViewCell
        
        cell.selectionStyle = .none;
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        case .denied:
            if navigationController?.viewControllers.last is MeetupsViewController {
                performSegue(withIdentifier: "GPSRequestNotify", sender: self)
            }
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let coordinates = locations.last?.coordinate {
            updateData(lat: coordinates.latitude, lon: coordinates.longitude)
        }
        
        print("Location Updated")
    }
    
    // MARK: - Observer Methods
    
    func dataFetchSuccess(_ notification: Notification) {
        DispatchQueue.main.async { () -> Void in
            self.tableView?.reloadData()
        }
    }
    
    func dataFetchFail(_ notification: Notification) {
        DispatchQueue.main.async { () -> Void in            
            // May stack
            if !(self.navigationController?.viewControllers.last is UIAlertController) {
                let alert = UIAlertController(
                    title: "Network Error",
                    message: "Failed to retrieve meetups. Please check your network connection.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func updateData(lat: Double, lon: Double) {
        // CLLocationManager to gather Location
        MeetupService(APIKey: APIKey).getMeetups(lat:lat, lon:lon) { (response) -> Void in
            self.meetups = response.results
        }
    }
    
    func dateFromUnixTime(_ time: Int) -> (date: String, time: String) {
        let dateObject = Date(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let date = formatter.string(from: dateObject)

        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: dateObject)
        
        return (date, time)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMeetupDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView?.indexPath(for: cell)
                if let detailVC = segue.destination as? MeetupDetailViewController {
                    detailVC.meetup = meetups![indexPath!.row]
                }
            }
        }
    }
}

