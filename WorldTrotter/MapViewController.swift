//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sean Melnick Kelly on 2/8/17.
//  Copyright © 2017 Sean Melnick Kelly. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
}

/*
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView: MKMapView!
}
*/

//Below needs its own delegate file, should be on Apple API site
/* func mapViewWillStartLocating... {
 
 }
*/

//  Not sure if this goes here
/* let locationManager = CCLLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
 } */


