//
//  MapViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Variables
    var home:Home!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        title = home.streetName
        mapView.showsPointsOfInterest = true
        mapView.pitchEnabled = true
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.Hybrid

        let mapCenter = mapView.userLocation.coordinate
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1000)
        mapView.setCamera(mapCamera, animated: true)

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(home.streetName, completionHandler: { placemarks, error in

            if error != nil {
                println(error)
                return
            }
            if placemarks != nil && placemarks.count > 0 {
                let placemark = placemarks[0] as CLPlacemark

                let annotation = MKPointAnnotation()
                annotation.title = self.home.streetName
                //annotation.subtitle = self.home.city
                annotation.coordinate = placemark.location.coordinate

                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "HomePin"

        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: home.image)
        annotationView.leftCalloutAccessoryView = leftIconView

        return annotationView
    }

}
