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


class ViewController: UIViewController, MKMapViewDelegate{
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
        costSegmentedControl.hidden = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}

