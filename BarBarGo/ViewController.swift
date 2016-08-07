//
//  ViewController.swift
//  BarBarGo
//
//  Created by Desmond Boey on 4/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import YelpAPI

class ViewController: UIViewController, MKMapViewDelegate{

    var client: YLPClient!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet{
            if currentLocation != nil{
                runYelpSearch()
            }
        }
    }
    var yelpBusinesses : [YLPBusiness]! {
        didSet{
            //update the view
            let coordinate = currentLocation?.coordinate
            
            let region = MKCoordinateRegionMakeWithDistance(coordinate!, 3000, 3000)
            
            self.mapView.setRegion(region, animated: false)
            
            for business in yelpBusinesses {
                let businessLocationCoordinates = business.location.coordinate
                
                let locationCoordinates = CLLocationCoordinate2D(latitude:  (businessLocationCoordinates?.latitude)!, longitude: (businessLocationCoordinates?.longitude)!)
                
                let locationInCLLocation = CLLocation(latitude: (businessLocationCoordinates?.latitude)!, longitude: (businessLocationCoordinates?.longitude)!)
                
                let distance = Int((currentLocation?.distanceFromLocation(locationInCLLocation))!)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinates
                annotation.title = business.name
                annotation.subtitle = "\(distance)m | \(business.rating)⭐️"
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    let updateDistance : Double = 50 //distance in meters user must move for update to trigger
    let initialBarsLoaded : UInt = 20
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBAction func arrowButtonPressed(sender: AnyObject) {
        costSegmentedControl.hidden = !costSegmentedControl.hidden
        arrowButton.selected = !arrowButton.selected
    }
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var costSegmentedControl: UISegmentedControl!
    
    
    @IBAction func leftButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costSegmentedControl.hidden = true
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        client = YLPClient(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, token: YELP_TOKEN, tokenSecret: YELP_TOKEN_SECRET)
        locationManager.distanceFilter = updateDistance

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func runYelpSearch(){
        let lat = Double((currentLocation?.coordinate.latitude)!)
        let lon = Double((currentLocation?.coordinate.longitude)!)
        let alt = Double((currentLocation?.altitude)!)
        
        let coordinate = YLPGeoCoordinate(latitude: lat, longitude: lon, accuracy: 1000, altitude: alt, altitudeAccuracy: alt)
        let location = YLPCoordinate(latitude: lat, longitude: lon)
        
        client.searchWithGeoCoordinate(coordinate, currentLatLong: location, term: "bar", limit: initialBarsLoaded, offset: 0, sort: YLPSortType.Distance) { (results: YLPSearch?, error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if let results = results {
                for restaurant in results.businesses{
                    print(restaurant.name)
                }
                self.yelpBusinesses = results.businesses
            }
            
            
        }
            
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.last //get the last location in the array
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
        
    }

}
