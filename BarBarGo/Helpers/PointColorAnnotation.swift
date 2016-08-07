//
//  PointColorAnnotation.swift
//  BarBarGo
//
//  Created by Desmond Boey on 7/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI

class PointColorAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
    
    static func createAnnotationForAlert(currLocation: CLLocation, bizLocation: YLPCoordinate, bizName: String, rating: Double) -> PointColorAnnotation{
        
        let annotation = PointColorAnnotation(pinColor: UIColor.redColor())
        
        if rating > 0 && rating < 3 {
            annotation.pinColor = UIColor.redColor()
        }
        
        if rating >= 3 && rating < 4 {
            annotation.pinColor = UIColor.orangeColor()
        }
        
        if rating >= 4 && rating <= 5 {
            annotation.pinColor = UIColor.greenColor()
        }
        
        /*let locationCoordinates = CLLocationCoordinate2D(latitude:  (businessLocationCoordinates?.latitude)!, longitude: (businessLocationCoordinates?.longitude)!)
        
                let annotationTitle = ""
        
        annotation.title = annotationTitle
        
        let annotationSubtitle : String?
        
        let distanceFromUser = String(Int(clLocation.distanceFromLocation(LocMgr.sharedInstance.lastLocation!)))
        
        
        annotation.subtitle = annotationSubtitle
        
        return annotation
    
    */
        return annotation
    }
}
