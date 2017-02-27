//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sean Melnick Kelly on 2/8/17.
//  Copyright © 2017 Sean Melnick Kelly. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    // A property of MapViewController
    let locationManager = CLLocationManager()
    
    var defaultLocationRegion: MKCoordinateRegion?
    
    var locations = ["52 Wetherell St. Newton, Massachusetts", "New Orleans, LA",
                     "822 Sterling Oaks Blvd, Naples, FL 34110, USA"]
    var pIndex: Int = 0
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set is as *the* view of this view controller
        view = mapView
        
        locationManager.requestAlwaysAuthorization()
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        
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
    
        // Creates locateButton
        let locateButton = UIButton()
        locateButton.setTitle("Locate Me", for: []) // [] = normal
        locateButton.setTitleColor(UIColor.black, for: [])
        let xCenterConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,toItem: locateButton, attribute: .leftMargin, multiplier: 5.5, constant: 0)
        view.addConstraint(xCenterConstraint) // Above change constraint?
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateButton) // Reorganize
        locateButton.addTarget(self, action: #selector(locateMe), for: .touchUpInside)
        let findBottomConstraint = locateButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10)
        findBottomConstraint.isActive = true
        
        // Creates pinSwitchButton
        let pinSwitchButton = UIButton()
        pinSwitchButton.setTitle("Next Pin", for: [])
        pinSwitchButton.setTitleColor(UIColor.black, for: [])
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
    }
    
    override func viewDidAppear(_ animated: Bool) { // Called everytime view controller is moved on screen
        defaultLocationRegion = mapView.region
    }
    
    func setDefaultLocationRegion() {
        let region = defaultLocationRegion
        mapView.setRegion(region!, animated: true)
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
    
/*    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        if mapView.showsUserLocation == false {
            if pIndex == 3 {
                defaultLocationRegion = mapView.region
            }
            mapView.showsUserLocation = true
        }
            -Determines based on pinIndex if something needs to be turned off AND if we need to capture
            -the default location.
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            -Display the current user location
    }
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
            -go back to default location
    } */
    
    @IBAction func locateMe(sender: UIButton) {
        
        if mapView.showsUserLocation == true {
            mapView.showsUserLocation = false
            setDefaultLocationRegion()
/*            if pIndex == 3 {
                mapView.removeAnnotations(self.mapView.annotations)
                pIndex = (pIndex + 1) % 4
            } */
        }
        else {
            mapView.showsUserLocation = true
            locationManager.requestAlwaysAuthorization()
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        
        
        
        print("Successful zoom on userLocation")
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
    
/*    func clearPin() {
        let annotationClear = self.mapView.annotations
        if annotationClear.count > 0    {
            print("AnnotationClear variable = \(annotationClear)")
                self.mapView.removeAnnotation(annotationClear as! MKAnnotation)
        }
        else {
            return
        }
    } */
    
    @IBAction func nextPin(sender: UIButton)
    {
//        clearPin()
// Maybe try clearing the pin that was prior...clearPin(locations[1])
        switch pIndex {
        case 0:
            mapView.removeAnnotations(self.mapView.annotations)
            dropPin(address: locations[0])
            let centerPoint = CLLocationCoordinate2D(latitude: 42.3118036, longitude: -71.21696250000002)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        case 1:
            mapView.removeAnnotations(self.mapView.annotations)
            dropPin(address: locations[1])
            let centerPoint = CLLocationCoordinate2D(latitude: 29.951066, longitude: -90.071532)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        case 2:
            mapView.removeAnnotations(self.mapView.annotations)
            dropPin(address: locations[2])
            let centerPoint = CLLocationCoordinate2D(latitude: 26.3135184, longitude: -81.80417349999999)
            let region = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        case 3:
            mapView.removeAnnotations(self.mapView.annotations)
            if mapView.showsUserLocation == true {
                let userLocation = mapView.userLocation
                let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
                mapView.setRegion(region, animated: true)
            }
            if mapView.showsUserLocation == false {
                setDefaultLocationRegion()
            }
        default:    // Should this default to current location? Potentialy change...
            print("Default case for switch statement called")
        }
        print("Successful zoom on pin \(pIndex)")
        pIndex = (pIndex + 1) % 4
    }
    
}


