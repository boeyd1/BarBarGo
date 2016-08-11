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
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var client : YLPClient!
    var mapVC : MapViewController?
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
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
    
    // TODO: Reset the index into their maps to 0
    //       Grab the correct set of yelp profiles
    //       Refresh the map
    //       Reset the icon
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        mapVC!.runYelpSearch() // TODO: Shouldn't run yelp search here - should have already ran it in BG
        mapVC!.counter = 0
        dispatch_async(dispatch_get_main_queue(),{
        self.mapVC!.refreshMap()
        })
        
    }
    
    // TODO: Increase the index into their maps
    //       Refresh the map
    //       Run some sort of animation?
    @IBAction func nextBarButtonTapped(sender: AnyObject) {
        if mapVC!.counter == mapVC!.searchLimit-1 {
            mapVC!.counter = 0
        }else{
        mapVC!.counter += 1
        }
        mapVC!.refreshMap()
    }
    
}