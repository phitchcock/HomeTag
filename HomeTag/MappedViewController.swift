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

    var homes = [Home]()
    var home:Home!

    //var venuePoints:[Int: MapPointAnnotation] = [Int:MapPointAnnotation]()
    //var map:MKMapView?
    //var homes: [Home] = []
    //var home:Home!



    @IBOutlet weak var mapview: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapview.delegate = self
        mapview.showsPointsOfInterest = true
        

        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!

        let request = NSFetchRequest(entityName: "Home")

        var error:NSError?
        let fetchedResults = context.executeFetchRequest(request, error: &error) as [Home]?

        if let results = fetchedResults {
            homes = results

            if homes.count > 0 {

                for home in homes {
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(home.streetName, completionHandler: { placemarks, error in

                        if error != nil {
                            println(error)
                            return
                        }
                        if placemarks != nil && placemarks.count > 0 {

                            for placemark in placemarks {
                                let placemark = placemarks[0] as CLPlacemark

                                let annotation = MKPointAnnotation()
                                //annotation.title = self.home.streetName
                                //annotation.subtitle = self.home.city
                                annotation.coordinate = placemark.location.coordinate

                                self.mapview.showAnnotations([annotation], animated: true)
                                self.mapview.selectAnnotation(annotation, animated: true)

                            }

                        }
                    })
                }
            }

        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - MKMapViewDelegate
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
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: home.image)
        annotationView.leftCalloutAccessoryView = leftIconView

        return annotationView
    }
    */


}
