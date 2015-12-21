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
    
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "giftly")!)
            tableView?.estimatedRowHeight = 102
            tableView?.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var meetup: Meetup!
    
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
//                    self.mapView?.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MeetupDetailCell", forIndexPath: indexPath) as! DetailedMeetupTableViewCell
        
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "giftly")!)
        
        if let eventName = meetup.name {
            cell.eventName?.text = eventName
        }
        
        if let eventDescription = meetup.meetupDescription {
            cell.eventDescription?.text = eventDescription
        }
        
        if let eventStatus = meetup.status {
            cell.eventStatus?.text = eventStatus
        }
        
        return cell
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        // The map view will also call this method when annotating the user's location
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let annotationView  = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = UIColor(red: 29/255.0, green: 207/255.0, blue: 161/255, alpha: 0.9)
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?ll=\(meetup.venue.lat!),\(meetup.venue.lon!)")!)
    }
}
