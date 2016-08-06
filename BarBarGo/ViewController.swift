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
    var locationManager: CLLocationManager!
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
        }
    }
    
    let updateDistance : Double = 50 //distance in meters user must move for update to trigger
    
    @IBOutlet weak var arrowButton: UIButton!
    
    

    @IBAction func arrowButtonPressed(sender: AnyObject) {
        costSegmentedControl.hidden = !costSegmentedControl.hidden
        arrowButton.selected = !arrowButton.selected
    }
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var costSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client = YLPClient(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, token: YELP_TOKEN, tokenSecret: YELP_TOKEN_SECRET)
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = updateDistance
        
        costSegmentedControl.hidden = true
        
    }
    
    func runYelpSearch(){
        let lat = Double((currentLocation?.coordinate.latitude)!)
        let lon = Double((currentLocation?.coordinate.longitude)!)
        let alt = Double((currentLocation?.altitude)!)
        
        let coordinate = YLPGeoCoordinate(latitude: lat, longitude: lon, accuracy: 1000, altitude: alt, altitudeAccuracy: alt)
        let location = YLPCoordinate(latitude: lat, longitude: lon)
        
        client.searchWithGeoCoordinate(coordinate, currentLatLong: location, term: "bar", limit: 20, offset: 0, sort: YLPSortType.Distance) { (results: YLPSearch?, error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if let results = results {
                print(results)
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
        currentLocation = locations[locations.count - 1] //get the last location in the array
    }

}
