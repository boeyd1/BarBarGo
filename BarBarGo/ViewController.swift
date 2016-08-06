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
        
        costSegmentedControl.hidden = true
      
        
        runYelpSearch()
    }
    
    func runYelpSearch(){
        let location = YLPGeoCoordinate(latitude: 48.2373425, longitude: -101.2706954, accuracy: 10000, altitude: 1000, altitudeAccuracy: 5000)
        
        client.searchWithGeoCoordinate(location) { (results: YLPSearch?, error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if let results = results {
                print(results)
                for restaurant in results.businesses{
                    print(restaurant.name)
                }
            }
            
            
        }
    }

}

