//
//  LocationTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/3/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationTableViewController: UITableViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var home: Home!
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        updateLabels()
        configureGetLocationButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveHome(sender: AnyObject) {
        saveHome()
        resetTagHome()
        //performSegueWithIdentifier("showSegue", sender: self)
    }

    @IBAction func cancelAction(sender: AnyObject) {
        resetTagHome()
        //dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func getLocation(sender: AnyObject) {
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManager()

        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
        configureGetLocationButton()
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }

        lastLocationError = error
        stopLocationManager()
        updateLabels()
        configureGetLocationButton()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as CLLocation
        println("didUpdateLocations \(newLocation)")

        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            updateLabels()

            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                println("*** We are done!")
                stopLocationManager()
                configureGetLocationButton()
            }

            if !performingReverseGeocoding {
                println("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                    println("*** Found placemarks: \(placemarks), error: \(error)")
                    self.lastGeocodingError = error
                    if error == nil && !placemarks.isEmpty {
                        self.placemark = placemarks.last as? CLPlacemark

                    } else {
                        self.placemark = nil
                    }

                    self.performingReverseGeocoding = false
                    self.updateLabels()

                })
            }
        }

    }

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

        alert.addAction(okAction)

        presentViewController(alert, animated: true, completion: nil)
    }

    func updateLabels() {
        if let location = location {
            //latLabel.text = String(format: "%.8f", location.coordinate.latitude)
            //longLabel.text = String(format: "%.8f", location.coordinate.longitude)
            messageLabel.text = "Address search has completed. If incorrect address tap Get Location again or enter correct address"

            if let placemark = placemark {
                addressTextField.text = stringFromPlacemark(placemark)
            }
            else if performingReverseGeocoding {
                messageLabel.text = "Searching for Address..."
            }
            else if lastGeocodingError != nil {
                messageLabel.text = "Error Finding Address"

            } else {
                messageLabel.text = "No Address Found"
            }

        } else {
            //latLabel.text = ""
            //longLabel.text = ""
            addressTextField.text = ""
            messageLabel.text = "Tap Get Location to find address"

            var statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Services Disabled"

                } else {
                    statusMessage = "Error Getting Location"
                }
            }
            else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            }
            else if updatingLocation {
                statusMessage = "Searching..."

            } else {
                statusMessage = "Tap Get Location to find address"
            }

            messageLabel.text = statusMessage
        }
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }

    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

    func configureGetLocationButton() {
        if updatingLocation {
            locationButton.setTitle("Stop", forState: UIControlState.Normal)
        } else {
           locationButton.setTitle("Get Location", forState: UIControlState.Normal)
        }
    }

    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return "\(placemark.subThoroughfare) \(placemark.thoroughfare) " + "\(placemark.locality) \(placemark.administrativeArea)"
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: managedObjectContext) as Home
            home.streetName = addressTextField.text
            home.image = UIImagePNGRepresentation(imageView.image)
            home.note = "Add Notes"

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.delegate = self

                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self

            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func pickImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self

            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSegue" {
            let destinationController = segue.destinationViewController as ShowHomeTableViewController
            destinationController.home = home
        }
    }

    func resetTagHome() {
        location = nil
        lastLocationError = nil
        placemark = nil
        lastGeocodingError = nil
        imageView.image = UIImage(named: "add-image.png")
        addressTextField.text = ""
        messageLabel.text = "Tap Get Location to find address"
    }

}
