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
import QuartzCore

class LocationTableViewController: UITableViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //tableView.backgroundColor = UIColor(patternImage: UIImage(named: "splash.jpg")!)

        var imageViewObject = UIImageView()
        imageViewObject.image = UIImage(named: "splash.jpg")
        tableView.backgroundView = imageViewObject

        addressTextField.layer.borderColor = UIColor(red: 0.086, green: 0.494, blue: 0.655, alpha: 1.0).CGColor
        addressTextField.layer.borderWidth = 1.0
        //imageViewObject.
        //imageViewObject = UIImageView(frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
        //imageViewObject.image = UIImage(named:"splash.jpg")

        //self.view.addSubview(imageViewObject)

        //imageViewObject.contentMode = UIViewContentMode.ScaleAspectFill



        updateLabels()
        configureGetLocationButton()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        saveButton.title = ""
        saveButton.enabled = false
        saveButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
        cancelButton.title = ""
        cancelButton.enabled = false
        cancelButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
        addressTextField.delegate = self
        messageLabel.text = "Tap + to Take a Picture \nTap Get Location to Start Searching for Address"

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.separatorColor = UIColor.clearColor()

        //self.screenName = "Test"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveHome(sender: AnyObject) {
        if addressTextField.text == "" {
            var alert = UIAlertController(title: "Hold On!", message: "Please enter and address or Tap Get Location", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "Got It", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            saveHome()
            resetTagHome()
            tabBarController?.selectedIndex = 0
            //performSegueWithIdentifier("showSegue", sender: self)
            println("lat \(home.latitude) and long \(home.longitude)")
        }

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
        saveButton.tintColor = UIColor.whiteColor()
        saveButton.enabled = true
        saveButton.title = "Save"
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.enabled = true
        cancelButton.title = "Cancel"

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

            //messageLabel.text = "Address search has completed. If incorrect address tap Get Location again or enter correct address"

            if let placemark = placemark {
                addressTextField.text = stringFromPlacemark(placemark)
            }
            else if performingReverseGeocoding {
                messageLabel.text = "Searching for Address..."
            }
            else if lastGeocodingError != nil {
                messageLabel.text = "Error Finding Address"

            } else {
                messageLabel.text = "Reverse GEOLocating..."
            }

        } else {
            //latLabel.text = ""
            //longLabel.text = ""
            addressTextField.text = ""
            messageLabel.text = "Tap + to Take a Picture \nTap Get Location to Start Searching for Address"

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
                statusMessage = "Tap + to Take a Picture \nTap Get Location to Start Searching for Address"
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
            locationButton.setTitle("Searching...", forState: UIControlState.Normal)
        } else {
           locationButton.setTitle("Get Location", forState: UIControlState.Normal)
            messageLabel.text = "Address search has completed. If incorrect address tap Get Location again or enter correct address"
        }
    }

    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return "\(placemark.subThoroughfare) \(placemark.thoroughfare) " + "\(placemark.locality) \(placemark.administrativeArea)"
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: managedObjectContext) as Home
            home.streetName = addressTextField.text
            home.image = UIImageJPEGRepresentation(imageView.image, 1.0)
            home.thumbNail = UIImageJPEGRepresentation(imageView.image, 0.1)
            home.note = "Add Notes"
            home.isFavorite = false
            home.tag = "Tagged"
            home.latitude = locationManager.location.coordinate.latitude
            home.longitude = locationManager.location.coordinate.longitude

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
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
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
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self

            self.presentViewController(imagePicker, animated: true, completion: nil)

        }
    }


    /*
    @IBAction func pickImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self

            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    */

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
        messageLabel.text = "Tap + to Take a Picture \nTap Get Location to Start Searching for Address"
        saveButton.title = ""
        saveButton.enabled = false
        saveButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
        cancelButton.title = ""
        cancelButton.enabled = false
        cancelButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.tintColor = UIColor(red: 0.086, green: 0.494, blue: 0.655, alpha: 1.0)
        saveButton.enabled = true
        saveButton.title = "Save"
        cancelButton.tintColor = UIColor(red: 0.086, green: 0.494, blue: 0.655, alpha: 1.0)
        cancelButton.enabled = true
        cancelButton.title = "Cancel"
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        return true
    }


}
