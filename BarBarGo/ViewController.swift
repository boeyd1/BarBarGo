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


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var arrowButton: UIButton!

    @IBAction func arrowButtonPressed(sender: AnyObject) {
        costSegmentedControl.hidden = !costSegmentedControl.hidden
        arrowButton.selected = !arrowButton.selected
    }
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var costSegmentedControl: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var currLocation : CLLocation? {
        didSet{
            
            let coordinate = currLocation?.coordinate
            
            let region = MKCoordinateRegionMakeWithDistance(coordinate!, 1000, 1000)
            
            self.mapView.setRegion(region, animated: false)

        }
    }
    @IBAction func leftButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        costSegmentedControl.hidden = true
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currLocation = locations.last
        print("updating location")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
}

