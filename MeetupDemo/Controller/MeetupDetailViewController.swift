//
//  MeetupDetailViewController.swift
//  MeetupDemo
//
//  Created by Xing Hui Lu on 12/20/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit
import MapKit

class MeetupDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView? {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MeetupDetailViewController.mapTapped))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            mapView?.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "giftly")!)
            tableView?.estimatedRowHeight = 102
            tableView?.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var meetup: Meetup!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView?.delegate = self
        mapView?.showsCompass = true
        mapView?.showsScale = true
        mapView?.showsTraffic = true
        

        
        guard let latitude = meetup.venue.lat, let longitude = meetup.venue.lon  else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                annotation.title = self.meetup.name
                annotation.subtitle = self.meetup.group.name
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView?.showAnnotations([annotation], animated: true)
                    self.mapView?.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    // MARK: - TableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailedMeetupTableViewCell
            
            cell.backgroundColor = UIColor(patternImage: UIImage(named: "giftly")!)
            
            if let eventName = meetup.name {
                cell.eventName?.text = eventName
            }
            
            if let eventTime = meetup.startTime {
                let (date, time) = dateFromUnixTime(eventTime)
                cell.eventDate?.text = date
                cell.eventStartTime?.text = time
            }
            
            if let eventDescription = meetup.meetupDescription {
                cell.eventDescription?.text = eventDescription
            }
            
            if let eventStatus = meetup.status {
                cell.eventStatus?.text = eventStatus
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
            
            if let address1 = meetup.venue.address1 {
                cell.address1?.text = address1
            } else {
                cell.address1?.text = "N/A"
            }
            
            if let address2 = meetup.venue.address2 {
                cell.address2?.text = address2
            } else {
                cell.address2?.text = ""
            }
            
            cell.backgroundColor = UIColor(patternImage: UIImage(named: "giftly")!)
            
            return cell
        }
    }
    
    // MARK: - MKMapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let annotationView  = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = UIColor(red: 29/255.0, green: 207/255.0, blue: 161/255, alpha: 0.9)
        
        return annotationView
    }
    
    // MARK: - Selectors
    
    func mapTapped() {
        var url = "http://maps.apple.com/?ll="
        
        if let lat = meetup.venue.lat, let lon = meetup.venue.lon {
            url = "\(url)\(lat),\(lon)"
        }
        
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    // MARK: - Helper Methods
    
    func dateFromUnixTime(_ time: Int) -> (date: String, time: String) {
        let dateObject = Date(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let date = formatter.string(from: dateObject)
        
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: dateObject)
        
        return (date, time)
    }
}
