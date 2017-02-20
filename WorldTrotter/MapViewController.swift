//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sean Melnick Kelly on 2/8/17.
//  Copyright © 2017 Sean Melnick Kelly. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var locations = ["52 Wetherell St. Newton, Massachusetts", "New Orleans, LA",
                     "822 Sterling Oaks Blvd, Naples, FL 34110, USA"]
    var pIndex: Int = 0
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set is as *the* view of this view controller
        view = mapView
        
        let segmentedControl
            = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor
            = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint
            = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                    constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint
            = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint
            = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    
        let locateButton = UIButton()
        locateButton.setTitle("Locate Me", for: []) // [] = normal
        locateButton.setTitleColor(UIColor.black, for: [])
        locateButton.setTitleShadowColor(UIColor.darkGray, for: [])
        locateButton.frame = CGRect(x: 0, y: 0, width: 100, height: 225) // Change number?
        let xCenterConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,toItem: locateButton, attribute: .leftMargin, multiplier: 5.5, constant: 0)
        view.addConstraint(xCenterConstraint) // Above change constraint?
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateButton) // Reorganize
        locateButton.addTarget(self, action: #selector(locateMe), for: .touchUpInside)
        let findBottomConstraint = locateButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10)
        
        findBottomConstraint.isActive = true
        
        let pinSwitchButton = UIButton()
        pinSwitchButton.setTitle("Next Pin", for: [])
        pinSwitchButton.setTitleColor(UIColor.black, for: [])
        pinSwitchButton.setTitleShadowColor(UIColor.black, for: [])
        pinSwitchButton.frame = CGRect(x: 0, y: 0, width: 100, height: 225)
        let x2CenterConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: pinSwitchButton, attribute: .leftMargin, multiplier: 5.5, constant: 0)
        view.addConstraint(x2CenterConstraint)
        pinSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinSwitchButton)
        pinSwitchButton.addTarget(self, action: #selector(nextPin), for: .touchUpInside)
        let pinSwitchBottomConstraint = pinSwitchButton.bottomAnchor.constraint(equalTo:bottomLayoutGuide.topAnchor, constant: -30)
        
        pinSwitchBottomConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
        
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        dropPin(address: locations[0])
        dropPin(address: locations[1])
        dropPin(address: locations[2])
      
        print("MapView successfuly dropped pins")
        
        
    }
    
    func dropPin(address: String) {
        let geoaddress = CLGeocoder()
        
        geoaddress.geocodeAddressString(address) { CLPlacemark, error in
            for placemark in CLPlacemark!
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location!.coordinate)
                annotation.title = address
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @IBAction func locateMe(sender: UIButton) {
        
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsUserLocation = true
        
        print("Successful zoom on userLocation")
    }
    
    @IBAction func nextPin(sender: UIButton) {
        switch pIndex {
        case 0:
            let centerPoint = CLLocationCoordinate2D(latitude: 42.3118036, longitude: -71.21696250000002)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        case 1:
            let centerPoint = CLLocationCoordinate2D(latitude: 29.951066, longitude: -90.071532)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        case 2:
            let centerPoint = CLLocationCoordinate2D(latitude: 26.3135184, longitude: -81.80417349999999)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        default:    // Should this default to current location? Potentialy change...
            let userLocation = mapView.userLocation
            let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
            mapView.setRegion(region, animated: true)
        }
        
        print("Successful zoom on pin ")
        pIndex = (pIndex + 1) % 4
        print("pIndex is currently equal to: \(pIndex)")
    }
}

/*
protocol CLLocationManagerDelegate {  // Delegate protocal????
    optional func mapViewWillStartLocating
    
} */

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


