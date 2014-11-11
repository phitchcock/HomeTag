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
                let location = CLLocationCoordinate2D(latitude: Double(home.latitude), longitude: Double(home.longitude))
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegionMake(location, span)
                mapview.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                annotation.title = home.streetName

                mapview.addAnnotation(annotation)
                println("lat \(home.latitude) and \(home.longitude)")
            }
        }

    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
