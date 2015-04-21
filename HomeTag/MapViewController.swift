//
//  MapViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Variables
    var home:Home?
    var locationManager: CLLocationManager!
    //var currentPlacemark:CLPlacemark?
    //let geoCoder = CLGeocoder()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let placemark = placemarks[0] as CLPlacemark
        mapView.delegate = self
        //title = home.streetName
        mapView.showsPointsOfInterest = true
        //mapView.pitchEnabled = true
        mapView.showsUserLocation = true
        //mapView.mapType = MKMapType.Hybrid

        //let mapCenter = mapView.userLocation.coordinate
        //var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1000)
        //mapView.setCamera(mapCamera, animated: true)
       // if home != nil {

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()

        if home != nil {

            let location = CLLocationCoordinate2D(latitude: Double(home!.latitude), longitude: Double(home!.longitude))
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location, span)

            mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.home!.streetName
            annotation.subtitle = "Whatever"

            mapView.addAnnotation(annotation)

        }


       // }



    }

    @IBAction func getDirections(sender: UIBarButtonItem) {


    }
/*
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "HomePin"
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))

        if annotation.isKindOfClass(Home.self) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.enabled = true
                annotationView.canShowCallout = true

                let btn = UIButton.buttonWithType(.DetailDisclosure) as? UIButton
                annotationView.rightCalloutAccessoryView = btn
            } else {
                leftIconView.image = UIImage(data: home!.image)
                annotationView.leftCalloutAccessoryView = leftIconView
                annotationView.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }


    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("locations = \(locations)")
    }
*/
    /*
    override func viewWillAppear(animated: Bool) {

        if home != nil {

            //dispatch_async(dispatch_get_main_queue()) {

            self.geoCoder.geocodeAddressString(self.home!.streetName, completionHandler: { placemarks, error in

                if error != nil {
                    println(error)
                    return
                }
                if placemarks != nil && placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark

                    let annotation = MKPointAnnotation()
                    annotation.title = self.home!.streetName
                    //annotation.subtitle = self.home.city
                    annotation.coordinate = placemark.location.coordinate

                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            })
            
        }
        //}
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "HomePin"
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))

        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.enabled = true
            annotationView.canShowCallout = true

            let btn = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            annotationView.rightCalloutAccessoryView = btn

        } else {
            leftIconView.image = UIImage(data: home!.image)
            annotationView.leftCalloutAccessoryView = leftIconView
            annotationView.annotation = annotation
        }


        return annotationView
    }
*/

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
