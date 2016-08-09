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
    
    var mapVC : MapViewController?
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBAction func moreInfoButtonTapped(sender: AnyObject) {
        
      mapVC?.showPopover(ratingsLabel)

        
        //moreInfoButton should change to map icon
        //unwinding should change back to ... icon
    }
    
    override func viewDidLoad(){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let identifier = segue.identifier{
            if identifier == "embeddedMapVC"{
                mapVC = segue.destinationViewController as? MapViewController
             
                mapVC!.containerVC = self
            }
        }
    }
    
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        mapVC!.runYelpSearch()
        mapVC!.counter = 0
        dispatch_async(dispatch_get_main_queue(),{
        self.mapVC!.refreshMap()
        })
        
    }
    
    @IBAction func nextBarButtonTapped(sender: AnyObject) {
        if mapVC!.counter == mapVC!.searchLimit-1 {
            mapVC!.counter = 0
        }else{
        mapVC!.counter += 1
        }
        mapVC!.refreshMap()
    }
    
}