//
//  ContainerViewController.swift
//  BarBarGo
//
//  Created by Desmond Boey on 8/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import YelpAPI

class ContainerViewController: UIViewController{
    
    @IBOutlet weak var barNameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!

    @IBOutlet weak var map: MapView!
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var client : YLPClient!
    var mapVC : MapViewController?
    var yelpBusinesses : [YLPBusiness]!
    var yelpBusinessCache = [YLPBusiness]()
    var yelpBusinessIndex : Int = 0 {
        didSet{
            if yelpBusinessIndex < yelpBusinesses.count{
                //update the map
                let business = yelpBusinesses[yelpBusinessIndex]
                let ylpLoc = business.location
                let targetLoc = CLLocation(latitude: (ylpLoc.coordinate?.latitude)!, longitude: (ylpLoc.coordinate?.longitude)!)
                map.currentTarget = targetLoc
                //TODO: update the header
                barNameLabel.text = business.name
                ratingsLabel.text = "\(business.rating)"
            }
        }
    }
    
    let updateDistance : Double = 50 //Distance in meters that locaiton manager updates
    let searchLimit: Int = 20
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        map.directionsLabel = directionsLabel
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        client = YLPClient(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, token: YELP_TOKEN, tokenSecret: YELP_TOKEN_SECRET)
        locationManager.distanceFilter = updateDistance
        locationManager.startUpdatingLocation()

    }
    
    //MARK: Button presses
    @IBAction func moreInfoButtonTapped(sender: AnyObject) {
        print("more info please!")
        //TODO: moreInfoButton should change to map icon
        //TODO: unwinding should change back to ... icon
    }
    
    // TODO: Reset the icon
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        yelpBusinesses = yelpBusinessCache //ensures the correct map is there
        yelpBusinessIndex = 0 //resets index and refreshes map
    }
    
    // TODO: Run some sort of animation?
    //       If we've gotten to the end of our stack (or near), then run the yelp search and append the results
    @IBAction func nextBarButtonTapped(sender: AnyObject) {
        yelpBusinessIndex += 1
        
        if yelpBusinessIndex > 15 /*or something like that*/ {
            //run another yelp search
        }
    }
    
    // Runs a yelp search based upon the user's current location
    func runYelpSearch(){
        
        if currentLocation == nil { return }
        
        let lat = Double((currentLocation.coordinate.latitude))
        let lon = Double((currentLocation.coordinate.longitude))
        let alt = Double((currentLocation.altitude))
        
        let coordinate = YLPGeoCoordinate(latitude: lat, longitude: lon, accuracy: 1000, altitude: alt, altitudeAccuracy: alt)
        let location = YLPCoordinate(latitude: lat, longitude: lon)
        
        self.client.searchWithGeoCoordinate(coordinate, currentLatLong: location, term: "bar", limit: UInt(self.searchLimit), offset: 0, sort: YLPSortType.Distance) { (results: YLPSearch?, error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if let results = results {
                print("yelp search has returned")
                if self.yelpBusinesses == nil {
                    self.yelpBusinesses = results.businesses
                    self.yelpBusinessIndex = 0
                }
                self.yelpBusinessCache = results.businesses
            }
        }
    }
    
    
}

extension ContainerViewController: CLLocationManagerDelegate {
    // TODO: Run Yelp search
    //       Update icon
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.last!
        runYelpSearch()
    }

}





