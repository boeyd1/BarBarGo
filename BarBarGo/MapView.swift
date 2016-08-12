//
//  MapView.swift
//  BarBarGo
//
//  Created by Jottie Brerrin on 8/11/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import MapKit

//TODO: Have it update its own walking path based upon the user moving. This will be more granular than yelp search.
class MapView: MKMapView{
    
    var currentLocation: CLLocation!
    var currentTarget: CLLocation! {
        didSet{
            redisplayWalkingDirections()
            reannotateMap()
        }
    }
    var locationManager = CLLocationManager()
    weak var directionsLabel : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        locationManager.delegate = self
        locationManager.distanceFilter = 2 //distance in meters it takes to update location
        locationManager.startUpdatingLocation()
    }
    
    //Displays
    func redisplayWalkingDirections(){
        
        //Make sure the target exists
        if currentTarget == nil || currentLocation == nil { return }
        
        let walkingRouteRequest = MKDirectionsRequest()
        walkingRouteRequest.source = MKMapItem.mapItemForCurrentLocation()
        walkingRouteRequest.transportType = MKDirectionsTransportType.Walking
        
        let lat = currentTarget.coordinate.latitude
        let lon = currentTarget.coordinate.longitude
        
        let barLocationCoordinates2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let barLocationPlacemark = MKPlacemark(coordinate: barLocationCoordinates2D, addressDictionary: nil)
        let destination = MKMapItem(placemark: barLocationPlacemark)
        walkingRouteRequest.destination = destination
        
        let walkingRouteDirections = MKDirections(request: walkingRouteRequest)
        
        
        walkingRouteDirections.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let overlays = self.overlays
            self.removeOverlays(overlays)
            if let response = response{
                if response.routes.count > 0{
                    let walkingRoute = response.routes[0]
                    self.addOverlay(walkingRoute.polyline, level: MKOverlayLevel.AboveRoads)
                    
                    self.setVisibleMapRect(walkingRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(35.0, 35.0, 35.0, 35.0) , animated: true)
                }
                //TODO: display using self.directionsLabel
//                for routeStep in self.walkingRoute.steps{
//                    self.directionData.append("\(routeStep.instructions) in \(Int(routeStep.distance))m")
//                }
//                self.routePickerView.reloadAllComponents()
            }
        }
    }
    
    func reannotateMap(){
        removeAnnotations(annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentTarget.coordinate
        annotation.title = "Horizontal Distance:"
        
        let distance = currentTarget.distanceFromLocation(currentLocation)
        
        annotation.subtitle = "\(Int(distance)) meters"
        self.addAnnotation(annotation)

    }
    
}

extension MapView: CLLocationManagerDelegate{
    //TODO: redraw the map if we have a target
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        redisplayWalkingDirections()
        print("redisplaying walking directions")
    }
}