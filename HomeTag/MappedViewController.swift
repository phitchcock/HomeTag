//
//  MappedViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/8/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MappedViewController: UIViewController, MKMapViewDelegate {

    //var home: Home!

    @IBOutlet weak var mapview: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapview.showsPointsOfInterest = true
        //mapView.pitchEnabled = true
        mapview.showsUserLocation = true
        mapview.mapType = MKMapType.Hybrid

    }

    override func viewWillAppear(animated: Bool) {


        let request = NSFetchRequest(entityName: "Home")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        var error:NSError?
        let homes = context.executeFetchRequest(request, error: &error)
        println(error)

        if homes!.count > 0 {
            for home in homes as [Home!] {
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(home.streetName, completionHandler: { placemarks, error in

                    if error != nil {
                        println(error)
                        return
                    }
                    if placemarks != nil && placemarks.count > 0 {
                        let placemark = placemarks[0] as CLPlacemark

                        let annotation = MKPointAnnotation()
                        annotation.title = home.streetName
                        annotation.subtitle = home.tag
                        annotation.coordinate = placemark.location.coordinate

                        self.mapview.showAnnotations([annotation], animated: true)
                        self.mapview.selectAnnotation(annotation, animated: true)
                    }
                })


                // DROP PIN BY LAT LONG
                /*
                let location = CLLocationCoordinate2D(latitude: Double(home.latitude), longitude: Double(home.longitude))
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegionMake(location, span)
                mapview.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                annotation.title = home.streetName

                mapview.addAnnotation(annotation)
                println("lat \(home.latitude) and \(home.longitude)")
                */
            }
        }

    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    /*
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
        /*
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: home.image)
        annotationView.leftCalloutAccessoryView = leftIconView
        */
        return annotationView
    }
    */

}
