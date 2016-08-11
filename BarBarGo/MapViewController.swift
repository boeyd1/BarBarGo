//
//  MapViewController.swift
//  BarBarGo
//
//  Created by Desmond Boey on 8/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import YelpAPI

// TODO: change this into a better organized subclass of map view, not its own controller
class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var routePickerView: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    
    var containerVC : ContainerViewController?
    
    var directionData : [String] = [String]()
    var client: YLPClient!
    var locationManager = CLLocationManager()
    var walkingRoute : MKRoute!
    var reviews : String! {
        didSet{
            NotificationHelper.notification.postNotificationName(NotificationHelper.ntfnBroadcast, object: self, userInfo: ["userReview":reviews])
        }
    }
    
    var counter = 0
    let searchLimit = 20
    
    var currentLocation: CLLocation?
    let updateDistance : Double = 50 //distance in meters user must move for update to trigger
    
    var shouldUpdateTempLocation = true
    var tempLocation: CLLocation? {
        didSet{
            runYelpSearch()
        }
    }
    
    var newYelpBusinesses : [YLPBusiness]! {
        didSet{
            //include codes that will notify users that there are updated entries; updated when location changes
        }
    }
    
    var yelpBusinesses : [YLPBusiness]! {
        didSet{
            //update the view
            dispatch_async(dispatch_get_main_queue(),{
            self.refreshMap()
            })
            
        }
    }

    // Refreshes entire view controller using a ref to previous view controller.
    func refreshMap(){
        
        let yelpBusiness = yelpBusinesses[counter]
         containerVC!.barNameLabel.text = yelpBusiness.name
         containerVC!.ratingsLabel.text = "\(yelpBusiness.rating)⭐️ | \(yelpBusiness.reviewCount) reviews"
        
        
        let walkingRouteRequest = MKDirectionsRequest()
        
        walkingRouteRequest.source = MKMapItem.mapItemForCurrentLocation()
        
        walkingRouteRequest.transportType = MKDirectionsTransportType.Walking
        
        let barLocation = yelpBusiness.location.coordinate
        
        let barLocationCoordinates2D = CLLocationCoordinate2D(latitude:  (barLocation?.latitude)!, longitude: (barLocation?.longitude)!)
        
        let barLocationPlacemark = MKPlacemark(coordinate: barLocationCoordinates2D, addressDictionary: nil)
        
        let destination = MKMapItem(placemark: barLocationPlacemark)
        
        walkingRouteRequest.destination = destination
        
        let walkingRouteDirections = MKDirections(request: walkingRouteRequest)
        
        
            walkingRouteDirections.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
                let overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                
                self.walkingRoute = response!.routes[0]
                self.mapView.addOverlay(self.walkingRoute.polyline, level: MKOverlayLevel.AboveRoads)
                
                self.mapView.setVisibleMapRect(self.walkingRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(35.0, 35.0, 35.0, 35.0) , animated: true)
                
                self.directionData = [String]()
                
                for routeStep in self.walkingRoute.steps{
                    self.directionData.append("\(routeStep.instructions) in \(Int(routeStep.distance))m")
                }
                self.routePickerView.reloadAllComponents()
            }
        
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = barLocationCoordinates2D
        annotation.title = "Horizontal Distance:"
        
        let distance = currentLocation?.distanceFromLocation(CLLocation(latitude:  (barLocation?.latitude)!, longitude: (barLocation?.longitude)!))
        
        annotation.subtitle = "\(Int(distance!)) meters"
        self.mapView.addAnnotation(annotation)
    }
    
    func addToReview(review: String){
        reviews.appendContentsOf("\"\(review)\"")
        reviews.appendContentsOf("\n\n")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        client = YLPClient(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, token: YELP_TOKEN, tokenSecret: YELP_TOKEN_SECRET)
        locationManager.distanceFilter = updateDistance
        locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.routePickerView.delegate = self
        self.routePickerView.dataSource = self
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    func runYelpSearch(){
        let lat = Double((currentLocation?.coordinate.latitude)!)
        let lon = Double((currentLocation?.coordinate.longitude)!)
        let alt = Double((currentLocation?.altitude)!)
        
        let coordinate = YLPGeoCoordinate(latitude: lat, longitude: lon, accuracy: 1000, altitude: alt, altitudeAccuracy: alt)
        let location = YLPCoordinate(latitude: lat, longitude: lon)
        
        self.client.searchWithGeoCoordinate(coordinate, currentLatLong: location, term: "bar", limit: UInt(self.searchLimit), offset: 0, sort: YLPSortType.Distance) { (results: YLPSearch?, error:NSError?) -> Void in
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let draw = MKPolylineRenderer(overlay: overlay)
        draw.strokeColor = UIColor.purpleColor()
        draw.lineWidth = 3.0
        return draw
    }

}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.last //get the last location in the array
        
        if shouldUpdateTempLocation {
            tempLocation = locations.last
            shouldUpdateTempLocation = false
        }
        
        //include code here to run yelp search but saved to newYelpBusinesses
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
        
    }
    
}

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return directionData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = directionData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        pickerLabel.textAlignment = .Left
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.attributedText = myTitle
        pickerLabel.numberOfLines = 3
        return pickerLabel
    }
    
}
